open Llvm
open Llvm_analysis
open Llvm_target
open Symbol
open Types
open Error
open Identifier
open Parsing

exception Terminate

let context    = global_context ()
let builder    = builder context
let the_module = create_module context "grace"

let int_type  = i32_type context
let char_type = i8_type context
let bool_type = i1_type context
let void_type = void_type context

let zero = const_int int_type 0

let write_lib_funcs = [("writeString", [PASS_BY_REFERENCE]); ("writeInteger", [PASS_BY_VALUE]); ("writeChar", [PASS_BY_VALUE]);
                       ("strlen", [PASS_BY_REFERENCE]); ("strcmp", [PASS_BY_REFERENCE; PASS_BY_REFERENCE]);
                       ("strcpy", [PASS_BY_REFERENCE; PASS_BY_REFERENCE]); ("strcat", [PASS_BY_REFERENCE; PASS_BY_REFERENCE])
                      ]
let libs = ["readString"; "readInteger"; "readChar"; "readByter";
            "writeString"; "writeInteger"; "writeChar";
            "strlen"; "strcmp"; "strcpy"; "strcat";
            "ascii"; "chr";
           ]

let rec typ_to_lltype grace_type =
    match grace_type with
    | TYPE_int                  -> int_type
    | TYPE_char                 -> char_type
    | TYPE_proc                 -> void_type
    | TYPE_array (t, n)         -> pointer_type (typ_to_lltype t)
    | _ -> fatal "grace to lltype didn't work"

let param_to_lltype (p: param) = match p.mode with
    | PASS_BY_VALUE -> typ_to_lltype p.param_type
    | PASS_BY_REFERENCE ->
    begin
      match p.param_type with
      | TYPE_array (t, n) -> typ_to_lltype p.param_type
      | t -> pointer_type (typ_to_lltype t)
    end

let rec string_of_type x = match x with
    | TYPE_none         -> "none"
    | TYPE_int          -> "int"
    | TYPE_char         -> "char"
    | TYPE_proc         -> "proc"
    | TYPE_array (y, _) -> "array of " ^ (string_of_type y)

type local_def =
    | VarDef of (unit -> unit)
    | FuncDef of (unit -> unit)
    | FuncDecl of (unit -> unit)

type expr_type =
  | Str of string
  | Expr of llvalue

let declareLib () =
    let declare_func name ret_type arg_l =
        let ft = function_type ret_type (Array.of_list arg_l) in
        ignore(declare_function name ft the_module)
    in
    declare_func "writeInteger" void_type [int_type];
    declare_func "writeChar" void_type [char_type];
    declare_func "writeString" void_type [pointer_type char_type];
    declare_func "readInteger" int_type [];
    declare_func "readByter" char_type [];
    declare_func "readChar" char_type [];
    declare_func "readString" void_type [int_type; pointer_type char_type];
    declare_func "strlen" int_type [pointer_type char_type];
    declare_func "strcmp" int_type [pointer_type char_type; pointer_type char_type];
    declare_func "strcpy" void_type [pointer_type char_type; pointer_type char_type];
    declare_func "strcat" void_type [pointer_type char_type; pointer_type char_type];
    declare_func "ascii" int_type [char_type];
    declare_func "chr" char_type [int_type];

    let extend_f =
        let ft = function_type int_type [|char_type|] in
        declare_function "extend" ft the_module
    in
    let bb = append_block context "entry" extend_f in
    position_at_end bb builder;
    let the_param = param extend_f 0 in
    let ret_val = build_zext the_param int_type "extend" builder in
    ignore(build_ret ret_val builder);

    let shrink_f =
        let ft = function_type char_type [|int_type|] in
        declare_function "shrink" ft the_module
    in
    let bb = append_block context "entry" shrink_f in
    position_at_end bb builder;
    let the_param = param shrink_f 0 in
    let ret_val = build_trunc the_param char_type "shrink" builder in
    ignore(build_ret ret_val builder);

    let writeByte_f =
        let ft = function_type void_type [|char_type|] in
        declare_function "writeByte" ft the_module
    in
    let bb = append_block context "entry" writeByte_f in
    position_at_end bb builder;
    let the_param = param writeByte_f 0 in
    let ext_param = build_call extend_f [|the_param|] "ext-wb" builder in
    let wi_f = match lookup_function "writeInteger" the_module with
    | Some x -> x
    | _ -> assert false
    in
    let _ret_val = build_call wi_f [|ext_param|] "" builder in
    ignore(build_ret_void builder);

    let readByte_f =
        let ft = function_type char_type [||] in
        declare_function "readByte" ft the_module
    in
    let bb = append_block context "entry" readByte_f in
    position_at_end bb builder;
    let ri_f = match lookup_function "readInteger" the_module with
    | Some x -> x
    | _ -> assert false
    in
    let the_int = build_call ri_f [||] "" builder in
    let ret_val = build_call shrink_f [|the_int|] "ri-shrink" builder in
    ignore(build_ret ret_val builder)


let genVarDef name t =
  let lltype = typ_to_lltype t in
  match t with
  | TYPE_array (base_type, dimensions) ->
      let element_type = typ_to_lltype base_type in
      begin match dimensions with
      | (-1)::t -> error "The first dimension of array %a must be specified" pretty_id (id_make name); raise Terminate
      | _ ->  let element_type = typ_to_lltype base_type in
              let total_size = List.fold_left ( * ) 1 dimensions in
              let array_type = array_type element_type total_size in
              define_global name (const_array element_type (Array.make total_size (const_null element_type))) the_module
      end
  | _ -> define_global name (const_null lltype) the_module

let calc_flat_index indices dimensions  =
  let zero = zero in
  let flat_index = ref zero in
  let dim_product = ref (const_int int_type 1) in
  for i = (List.length indices - 1) downto 0 do
    let idx = List.nth indices i in
    let dim = List.nth dimensions i in
    flat_index := build_add !flat_index (build_mul idx !dim_product "tmp" builder) "tmp" builder;
    dim_product := build_mul !dim_product dim "tmp" builder;
  done;
  !flat_index


let genVarRead name indices =
  let var_entry = lookupEntry (id_make name) LOOKUP_ALL_SCOPES true in
  let base_ptr, entry_type, is_param, param_mode = match var_entry.entry_info with
  | ENTRY_variable info -> (info.variable_ptr, info.variable_type, false, None)
  | ENTRY_parameter info -> (info.parameter_ptr, info.parameter_type, true, Some info.parameter_mode)
  | _ -> failwith (Printf.sprintf "Identifier '%s' does not refer to a variable or parameter" name)
  in
  match entry_type with
  | TYPE_array (t, dimensions) ->
    begin match indices with
    | [] ->
      if is_param && param_mode = Some PASS_BY_REFERENCE then
        base_ptr
      else
        let zero = const_int int_type 0 in
        build_gep base_ptr [| zero; zero |] "array_ptr" builder
    | _ ->
      let dims = List.map (fun d -> const_int int_type d) dimensions in
      let index_val = calc_flat_index indices dims in
      let element_ptr =
        if is_param && param_mode = Some PASS_BY_REFERENCE then
          build_gep base_ptr [| index_val |] "element_ptr" builder
        else
          build_gep base_ptr [| const_int int_type 0; index_val |] "element_ptr" builder
      in
      build_load element_ptr "load_element" builder
    end
  | _ ->
    if indices = [] then
      build_load base_ptr "load_read" builder
    else
      failwith (Printf.sprintf "Variable '%s' is not an array; indices not allowed" name)


let genVarWrite name indices exp =
  let expr = match exp with
    | Expr l      -> l
    | Str s       -> build_global_stringptr s "mystr" builder
  in
  let var_entry = lookupEntry (id_make name) LOOKUP_ALL_SCOPES true in
  let base_ptr, entry_type, is_param, param_mode = match var_entry.entry_info with
  | ENTRY_variable info -> (info.variable_ptr, info.variable_type, false, None)
  | ENTRY_parameter info -> (info.parameter_ptr, info.parameter_type, true, Some info.parameter_mode)
  | _ -> failwith (Printf.sprintf "Identifier '%s' does not refer to a variable or parameter" name)
  in
  let lltype = typ_to_lltype entry_type in
  match entry_type with
  | TYPE_array (t, dimensions) when indices <> [] ->
    let dims = List.map (fun d -> const_int int_type d) dimensions in
    let index_val = calc_flat_index indices dims in
    let element_ptr =
      if is_param && param_mode = Some PASS_BY_REFERENCE then
        build_gep base_ptr [| index_val |] "element_ptr" builder
      else
        build_gep base_ptr [| const_int int_type 0; index_val |] "element_ptr" builder
    in
    ignore (build_store expr element_ptr builder)
  | TYPE_array (_, _) -> failwith "Array variable without indices not supported for write"
  | _ ->
    if indices = [] then
      match is_param, param_mode with
        | true, Some PASS_BY_REFERENCE -> ignore (build_store expr base_ptr builder)
        | _, _ -> ignore (build_store expr base_ptr builder)
    else
      failwith (Printf.sprintf "Variable '%s' is not an array; indices not allowed" name)


let semaFuncDef fname pars ret_type func forward =
  let f = newFunction (id_make fname) true in
  openScope ();
  let fparams = Array.to_list (Llvm.params func) in
  let flat_pars = List.flatten (List.map (fun p -> List.map (fun id -> (id, p.param_type, p.mode)) p.id) pars) in
  List.iter2 (fun (id, t, mode) llvm_param ->
    match mode with
    | PASS_BY_REFERENCE ->
      ignore (newParameter (id_make id) t llvm_param mode f true)
    | PASS_BY_VALUE -> begin
      if not forward then begin
        let llvm_param_copy = genVarDef id t in
        ignore (build_store llvm_param llvm_param_copy builder);
        ignore (newParameter (id_make id) t llvm_param_copy mode f true)
      end
      else
      ignore (newParameter (id_make id) t llvm_param mode f true)
    end
  ) flat_pars fparams;
  endFunctionHeader f ret_type;
  if forward then forwardFunction f;
  match f.entry_info with
  | ENTRY_function func -> func.function_result <- ret_type
  | _ -> error "%a is not a function" pretty_id (id_make fname)


let rec genFuncDef fname fparams ret_type local_def_list block isOuter =
  List.iter (function local_def ->
    match local_def with
    | VarDef a -> a ()
    | _ -> ()
  ) local_def_list;
  List.iter (function local_def ->
    match local_def with
    | FuncDef a | FuncDecl a -> a ()
    | _ -> ()
  ) local_def_list;
  let llvm_ret_type = typ_to_lltype ret_type in
  let param_types = List.flatten (List.map (fun p ->
    List.map (fun _ -> param_to_lltype p) p.id
  ) fparams) |> Array.of_list in
  let function_type = function_type llvm_ret_type param_types in
  let the_function = (match lookup_function fname the_module with
    | Some f -> f
    | None -> declare_function fname function_type the_module) in
  let entry_bb = append_block context "entry" the_function in
  position_at_end entry_bb builder;
  ignore(semaFuncDef fname fparams ret_type the_function false);
  List.iter (fun stmt -> stmt ()) block;
  begin match block_terminator (insertion_block builder) with
      | None ->
          begin match ret_type with
          | TYPE_proc -> ignore(build_ret_void builder)
          | TYPE_int -> ignore(build_ret (zero) builder)
          | TYPE_char -> ignore(build_ret (const_int char_type 0) builder)
          | _ -> error "Function %a returns invalid type" pretty_id (id_make fname); raise Terminate
          end
      | Some _ -> () end;
  if isOuter then begin
            match lookup_function "main" the_module with
            | Some _ -> ()
            | None -> begin
                let main_func = declare_function "main" function_type the_module in
                let main_bb = append_block context "entry" main_func in
                position_at_end main_bb builder;
                if (return_type function_type != void_type) then begin
                    error "Main function %a must be a void" pretty_id (id_make fname); raise Terminate
                end else begin
                    ignore(build_call the_function (params main_func) "" builder);
                    ignore(build_ret_void builder)
                end
            end
        end


let genFuncDecl fname fparams ret_type =
  let llvm_ret_type = typ_to_lltype ret_type in
  let param_types = List.flatten (List.map (fun p ->
    List.map (fun _ -> param_to_lltype p) p.id
  ) fparams) |> Array.of_list in
  let function_type = function_type llvm_ret_type param_types in
  let the_function = (match lookup_function fname the_module with
    | Some f -> f
    | None -> declare_function fname function_type the_module) in
  ignore(semaFuncDef fname fparams ret_type the_function true)


let rec genFuncCall fname fargs =
  let func = (match lookup_function fname the_module with
  | Some fm -> fm
  | None -> error "Semantic analysis error (calling undefined function %a)" pretty_id (id_make fname); raise Terminate)
  in
  let is_type_array = function
    | TYPE_array _ -> true
    | _ -> false
  in
  let args = if (List.mem fname libs) then
    List.map (fun e ->
      match e with
      | Expr exp -> exp
      | Str str  -> let the_string = build_global_string str "string-lit" builder in
                    build_struct_gep the_string 0 "string_to_char_ptr" builder
    ) fargs
  else begin
    let isArray t = match t with
      | TYPE_array (_,_) -> true
      | _                -> false
    in
    let e = lookupEntry (id_make fname) LOOKUP_ALL_SCOPES true in
    let fparams = (match e.entry_info with
        | ENTRY_function info -> List.map ( fun p -> match p.entry_info with
          | ENTRY_parameter param -> param
          | _                     -> error "not a parameter"; raise Terminate
        ) info.function_paramlist
        | _ -> error "%a is not a function" pretty_id (id_make fname); raise Terminate)
    in
    let rec process_lists args par_types_modes =
      (match args, par_types_modes with
        | [], [] -> []
        | a::at, fp::fps -> ( match a with
          | Expr exp -> begin
            if fp.parameter_mode = PASS_BY_REFERENCE && not (isArray fp.parameter_type) then
                (operand exp 0)::(process_lists at fps)
              else
                exp::(process_lists at fps)
            end
          | Str str  -> let the_string = build_global_string str "string-lit" builder in
            (build_struct_gep the_string 0 "string_to_char_ptr" builder)::(process_lists at fps)
        )
        | _ -> failwith "Lists are not of the same length") in
    process_lists fargs fparams end
  in
  build_call func (Array.of_list args) "" builder


let codegen func do_opts =
  Llvm_all_backends.initialize ();
  declareLib ();
  func ();
  if (do_opts) then begin
      let fpm = PassManager.create () in
      List.iter (fun optimization -> optimization fpm) [
          Llvm_scalar_opts.add_memory_to_register_promotion;
          Llvm_scalar_opts.add_instruction_combination;
          Llvm_scalar_opts.add_reassociation;
          Llvm_scalar_opts.add_gvn;
          Llvm_scalar_opts.add_cfg_simplification;
      ];
      end;
  print_module "a.ll" the_module;
  assert_valid_module the_module;;
