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

let int_type  = i64_type context
let char_type = i8_type context
let bool_type = i1_type context
let void_type = void_type context

let zero = const_int int_type 0

let libs = ["readString"; "readInteger"; "readChar"; "readByter";
            "writeString"; "writeInteger"; "writeChar";
            "strlen"; "strcmp"; "strcpy"; "strcat";
            "ascii"; "chr";
           ]

let current_function = ref None

let return_encountered = ref false

let reset_return_flag () = return_encountered := false
let set_return_flag () = return_encountered := true
let check_return_flag () = !return_encountered


let rec typ_to_lltype grace_type =
  match grace_type with
  | TYPE_int -> int_type
  | TYPE_char -> char_type
  | TYPE_proc -> void_type
  | TYPE_array (base_type, _) -> pointer_type (typ_to_lltype base_type)
  | _ -> failwith "grace to lltype didn't work"

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

type local_def_type =
    | VarDef of (string list * Types.typ)
    | FuncDef of (string * param list * Types.typ * local_def_type list * ((unit -> unit) list))
    | FuncDecl of (string * param list * Types.typ)

type expr_type =
  | Str of string
  | Expr of llvalue * typ
  | LValue of string * typ * llvalue list

let lib_ret_type lib_func =
  match lib_func with
  | "readInteger" | "strlen" | "strcmp" | "ascii" -> TYPE_int
  | "readByter" | "readChar" | "chr" -> TYPE_char
  | _ -> TYPE_proc

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


let gen_bounds_check name indices sizes =
  let zero = Llvm.const_int (Llvm.i64_type context) 0 in
  let within_bounds_checks = List.map2 (fun idx size ->
    let in_bounds = Llvm.build_icmp Llvm.Icmp.Slt idx size "in_bounds" builder in
    let not_negative = Llvm.build_icmp Llvm.Icmp.Sge idx zero "not_negative" builder in
    Llvm.build_and not_negative in_bounds "within_bounds" builder
  ) indices sizes in
  let within_bounds_combined = List.fold_left (fun acc check ->
    Llvm.build_and acc check "within_bounds_combined" builder
  ) (List.hd within_bounds_checks) (List.tl within_bounds_checks) in
  let err_msg = Llvm.build_global_stringptr (name ^ ": Array index out of bounds\n") "err_msg" builder in
  let printf_ty = Llvm.var_arg_function_type (Llvm.i32_type context) [| Llvm.pointer_type (Llvm.i8_type context) |] in
  let printf_func = Llvm.declare_function "printf" printf_ty the_module in
  let exit_func = Llvm.declare_function "exit" (Llvm.function_type (Llvm.void_type context) [| Llvm.i32_type context |]) the_module in
  let err_block = Llvm.append_block context "error" (Llvm.block_parent (Llvm.insertion_block builder)) in
  let continue_block = Llvm.append_block context "continue" (Llvm.block_parent (Llvm.insertion_block builder)) in
  Llvm.build_cond_br within_bounds_combined continue_block err_block builder |> ignore;
  Llvm.position_at_end err_block builder;
  Llvm.build_call printf_func [| err_msg |] "" builder |> ignore;
  Llvm.build_call exit_func [| Llvm.const_int (Llvm.i32_type context) 1 |] "" builder |> ignore;
  Llvm.build_unreachable builder |> ignore;
  Llvm.position_at_end continue_block builder


let genVarDef name t =
  let lltype = typ_to_lltype t in
  match t with
  | TYPE_array (base_type, dimensions) ->
    List.iter (fun a -> if (a <= 0) then error "Size of array %s must be a positive number" name) dimensions;
    let element_type = typ_to_lltype base_type in
    let array_type = array_type element_type (List.fold_left ( * ) 1 dimensions) in
    let array = build_alloca array_type name builder in
    build_gep array [| const_int int_type 0; const_int int_type 0 |] "array_ptr" builder
  | _ ->
    build_alloca lltype name builder


let calc_flat_index indices dimensions =
  let linear_index = ref zero in
  let dim_product = ref (const_int int_type 1) in
  List.iter2 (fun idx dim ->
    linear_index := Llvm.build_add !linear_index (Llvm.build_mul idx !dim_product "idx_mul" builder) "idx_add" builder;
    dim_product := Llvm.build_mul !dim_product dim "dim_mul" builder
  ) (List.rev indices) (List.rev dimensions);
  !linear_index


let semaBinOp lhs_expr lhs_type rhs_expr rhs_type op =
  match (lhs_type, rhs_type) with
  | (TYPE_int, TYPE_int) -> true
  | (TYPE_char, TYPE_char) -> true
  | _ -> (error "Incompatible types for %s: %s and %s"
          op (string_of_type lhs_type) (string_of_type rhs_type); false)


let semaComp lhs rhs =
  let lhs_type = Llvm.type_of lhs in
  let rhs_type = Llvm.type_of rhs in
  if (lhs_type = int_type || lhs_type = char_type) && lhs_type = rhs_type then
    true
  else
    (error "Incompatible types for comparison: %s and %s"
      (string_of_lltype lhs_type) (string_of_lltype rhs_type); false)


let semaCond expr =
  let expr_type = Llvm.type_of expr in
  if expr_type = Llvm.i1_type context then
    true
  else
    (error "Operand is not a condition"; false)


let rec get_sub_array_type typ indices =
  match typ, indices with
  | TYPE_array (t, _ :: ds), _ :: rest_indices -> get_sub_array_type (TYPE_array (t, ds)) rest_indices
  | TYPE_array (t, ds), [] -> TYPE_array (t, ds)
  | _ -> typ

let rec calc_sub_array_index base_ptr indices dims =
  match indices, dims with
  | [], _ -> base_ptr
  | idx :: idx_rest, dim :: dim_rest ->
    let linear_idx = build_mul idx (const_int int_type (List.fold_left ( * ) 1 dim_rest)) "linear_idx" builder in
    let new_base_ptr = build_gep base_ptr [| linear_idx |] "sub_array_ptr" builder in
    calc_sub_array_index new_base_ptr idx_rest dim_rest
  | _ -> error "Mismatched indices and dimensions"; raise Terminate


let genVarRead name indices m =
  let var_entry = lookupEntry (id_make name) LOOKUP_ALL_SCOPES true in
  let base_ptr, entry_type, is_param, param_mode = match var_entry.entry_info with
    | ENTRY_variable info  -> (info.variable_ptr, info.variable_type, false, None)
    | ENTRY_parameter info -> (info.parameter_ptr, info.parameter_type, true, Some info.parameter_mode)
    | _ -> error "Identifier '%s' does not refer to a variable or parameter" name; raise Terminate
  in
  match entry_type with
  | TYPE_array (t, dimensions) ->
    let dims = List.map (fun d -> const_int int_type d) dimensions in
    let num_indices = List.length indices in
    let num_dimensions = List.length dimensions in
    if num_indices > num_dimensions then
      (error "Too many indices for array '%s'" name; raise Terminate)
    else if num_indices = num_dimensions then
      let index_val = calc_flat_index indices dims in
      let element_ptr = build_gep base_ptr [| index_val |] "element_ptr" builder in
      if m = "ref" then
        (element_ptr, t)
      else
        (build_load element_ptr "load_element" builder, t)
    else
    let sub_array_ptr = calc_sub_array_index base_ptr indices dimensions in
      let sub_array_type = TYPE_array (t, []) in
      (sub_array_ptr, sub_array_type)
  | _ ->
    if indices = [] then
      if m = "ref" then
        (base_ptr, entry_type)
      else
        (build_load base_ptr "load_read" builder, entry_type)
    else
      (error "Variable '%s' is not an array; indices not allowed" name; raise Terminate)


let genVarWrite name indices exp =
  let expr, expr_type = match exp with
    | Expr (e, t) -> (e, t)
    | LValue (v, _, i) -> (let ll, t = (genVarRead v i "val") in
      match t with
      | TYPE_array (ty, _) -> (ll, ty)
      | ty                 -> (ll, ty))
    | Str s -> error "Assignment of strings to arrays or variables is not allowed"; raise Terminate
  in
  let var_entry = lookupEntry (id_make name) LOOKUP_ALL_SCOPES true in
  let base_ptr, entry_type, is_param, param_mode = match var_entry.entry_info with
    | ENTRY_variable info -> info.initialized <- true; (info.variable_ptr, info.variable_type, false, None)
    | ENTRY_parameter info -> (info.parameter_ptr, info.parameter_type, true, Some info.parameter_mode)
    | _ -> error "Identifier '%s' does not refer to a variable or parameter" name; raise Terminate
  in
  match entry_type with
  | TYPE_array (t, dimensions) ->
      if not (equalType t expr_type) then
        (error "Type mismatch for %s: cannot assign %s to %s" name (string_of_type expr_type) (string_of_type t); raise Terminate)
      else (match indices with
        | [] -> error "Assignment to array '%s' is not allowed" name; raise Terminate
        | _ -> let dims = List.map (fun d -> const_int int_type d) dimensions in
                (match dimensions with
                | -1 :: _ -> ()
                | _ -> gen_bounds_check name indices dims);
                List.iter (fun i -> if (type_of i) != int_type then error "Array index must be an integer (%s)" name) indices;
                let index_val = calc_flat_index indices dims in
                let element_ptr = build_gep base_ptr [| index_val |] "element_ptr" builder in
                ignore (build_store expr element_ptr builder))
  | _ ->
    if not (equalType entry_type expr_type) then
      (error "Type mismatch for %s: cannot assign %s to %s" name (string_of_type expr_type) (string_of_type entry_type); raise Terminate)
    else
      if indices = [] then
        ignore (build_store expr base_ptr builder)
      else
        (error "Variable '%s' is not an array; indices not allowed" name; raise Terminate)

let string_of_mode m =
  match m with
  | PASS_BY_REFERENCE -> "ref"
  | PASS_BY_VALUE     -> "val"

let semaFuncDef f fname pars local_vars ret_type func forward =
  let fparams = Array.to_list (Llvm.params func) in
  let flat_pars = List.flatten (List.map (fun p -> List.map (fun id -> (id, p.param_type, p.mode)) p.id) pars) in
  List.iter2 (fun (id, t, mode) llvm_param ->
    match mode with
    | PASS_BY_REFERENCE ->
      ignore (newParameter (id_make id) t llvm_param mode f true)
    | PASS_BY_VALUE -> begin
      match t with
        | TYPE_array (_, _) -> error "Arrays must be passed by reference"; raise Terminate
        | _ -> (if not forward then
          begin
          let llvm_param_copy = genVarDef id t in
            ignore (build_store llvm_param llvm_param_copy builder);
            ignore (newParameter (id_make id) t llvm_param_copy mode f true)
            end
          else
            ignore (newParameter (id_make id) t llvm_param mode f true))
    end
  ) flat_pars fparams;
  if forward then forwardFunction f;
  endFunctionHeader f ret_type;
  match ret_type with
  | TYPE_array (_, _) -> error "%a: The return type of a function cannot be an array" pretty_id (id_make fname)
  | _ -> (match f.entry_info with
    | ENTRY_function func -> func.function_result <- ret_type;
                              func.function_local_vars <- local_vars
    | _ -> error "%a is not a function" pretty_id (id_make fname))


let genFuncDecl fname fparams ret_type n =
  let f = newFunction (id_make fname) n true in
  openScope ();
  let llvm_ret_type = typ_to_lltype ret_type in
  let param_types = List.flatten (List.map (fun p ->
    List.map (fun _ -> param_to_lltype p) p.id
  ) fparams) |> Array.of_list in
  let function_type = function_type llvm_ret_type param_types in
  let the_function = (match lookup_function fname the_module with
    | Some f -> f
    | None -> declare_function fname function_type the_module) in
  ignore(semaFuncDef f fname fparams [] ret_type the_function true);
  closeScope ()


let rec genFuncDef fname fparams ret_type local_def_list block isOuter n =
  let f = newFunction (id_make fname) n true in
  let prev_function = !current_function in
  current_function := Some f;
  reset_return_flag ();
  openScope ();
  let local_vars = List.fold_left (fun acc local_def ->
    match local_def with
    | VarDef (vars, var_type) -> (vars, var_type) :: acc
    | _ -> acc
  ) [] local_def_list in
  let local_param_names = List.flatten (List.map (fun p -> p.id) fparams) in
  let local_var_names = List.flatten (List.map fst local_vars) in
  let local_names = local_var_names @ local_param_names in
  let local_var_defs = List.fold_left (fun acc (vars, var_type) ->
    List.fold_left (fun acc var ->
      { id = [var]; mode = PASS_BY_REFERENCE; param_type = var_type } :: acc
    ) acc vars
  ) [] local_vars in
  let fparam_defs = List.fold_left (fun acc par ->
    List.fold_left (fun acc var ->
      if not (List.mem var local_var_names) then
        { id = [var]; mode = PASS_BY_REFERENCE; param_type = par.param_type } :: acc
      else
        { id = [var ^ "_outer"]; mode = PASS_BY_REFERENCE; param_type = par.param_type } :: acc
    ) acc par.id
  ) [] fparams in
  let filter_params fparams local_var_names =
    List.map (fun p ->
      let filtered_ids = List.map (fun id -> if not (List.mem id local_var_names) then id else id ^ "_outer") p.id in
      p.id <- filtered_ids; p
    ) fparams in
  let filtered_fparams = filter_params fparams local_var_names in
  List.iter (function
    | FuncDef (func_name, params, rt, nested_local_defs, body) ->
      let param_names = List.flatten (List.map (fun p -> p.id) params) in
      let additional_params = fparam_defs @ local_var_defs in
      let new_additional_params = List.fold_left (fun acc p ->
        if List.mem (List.hd p.id) param_names then
          (let id  = p.id in
            p.id <- [(List.hd id) ^ "_" ^ fname]; p :: acc)
        else p :: acc
      ) [] additional_params in
      let all_params = params @ new_additional_params in
      genFuncDef func_name all_params rt nested_local_defs body false (List.length param_names)
    | FuncDecl (func_name, params, rt) ->
      let param_names = List.flatten (List.map (fun p -> p.id) params) in
      let additional_params = fparam_defs @ local_var_defs in
      let new_additional_params = List.fold_left (fun acc p ->
        if List.mem (List.hd p.id) param_names then
          (let id  = p.id in
            p.id <- [(List.hd id) ^ "_" ^ fname]; p :: acc)
        else p :: acc
      ) [] additional_params in
      let all_params = params @ new_additional_params in
      genFuncDecl func_name all_params rt (List.length param_names)
    | VarDef _ -> ()
  ) local_def_list;
  let llvm_ret_type = typ_to_lltype ret_type in
  let param_types = List.flatten (List.map (fun p ->
    List.map (fun _ -> param_to_lltype p) p.id
  ) filtered_fparams) |> Array.of_list in
  let function_type = function_type llvm_ret_type param_types in
  let the_function = match lookup_function fname the_module with
    | Some f -> f
    | None -> declare_function fname function_type the_module in
  let entry_bb = append_block context "entry" the_function in
  position_at_end entry_bb builder;
  ignore(semaFuncDef f fname filtered_fparams local_var_names ret_type the_function false);
  List.iter (fun (vars, var_type) ->
    List.iter (fun var ->
      let ptr = genVarDef var var_type in
      ignore (newVariable (id_make var) var_type ptr true)
    ) vars
  ) local_vars;
  List.iter (fun stmt -> stmt ()) block;
  let ensure_terminator block =
    let terminator = block_terminator block in
    if terminator = None then
      match ret_type with
      | TYPE_proc -> ignore(build_ret_void builder)
      | TYPE_int -> ignore(build_ret zero builder)
      | TYPE_char -> ignore(build_ret (const_int char_type 0) builder)
      | _ -> error "Function %a returns invalid type" pretty_id (id_make fname); raise Terminate
  in
  iter_blocks ensure_terminator the_function;
  if not (check_return_flag ()) && fname != "main" && ret_type <> TYPE_proc then
      error "Function %s does not return in all paths" fname;
  if isOuter then begin
    match lookup_function "main" the_module with
    | Some _ -> ()
    | None -> begin
        let main_func = declare_function "main" int_type the_module in
        let main_bb = append_block context "entry" main_func in
        position_at_end main_bb builder;
        if (return_type function_type != void_type) then begin
          error "Main function %a must be a void" pretty_id (id_make fname); raise Terminate
        end else begin
          ignore(build_call the_function (params main_func) "" builder);
          ignore(build_ret (const_int int_type 0) builder)
        end
    end
  end;
  closeScope ();
  current_function := prev_function


let genLibCall fname fargs =
  let func = match lookup_function fname the_module with
    | Some fm -> fm
    | None -> error "Semantic analysis error (calling undefined function %a)" pretty_id (id_make fname); raise Terminate
  in
  let a = List.map (function
    | Expr (exp, t) -> exp
    | LValue (v, t, i) -> let ll, _ = genVarRead v i "val" in ll
    | Str str  -> let the_string = build_global_string str "string-lit" builder in
                  build_struct_gep the_string 0 "string_to_char_ptr" builder
  ) fargs in
  build_call func (Array.of_list a) "" builder


let rec take n lst =
  match lst with
  | [] -> []
  | _ when n <= 0 -> []
  | x :: xs -> x :: take (n - 1) xs


let is_rvalue (instr : Llvm.llvalue) : bool =
  match Llvm.classify_value instr with
  | Llvm.ValueKind.Instruction _ ->
    begin
      match Llvm.instr_opcode instr with
      | Llvm.Opcode.Load | Llvm.Opcode.Add | Llvm.Opcode.Sub | Llvm.Opcode.Mul -> true
      | _ -> false
    end
  | _ -> false

let rec genFuncCall fname fargs =
  let func = match lookup_function fname the_module with
    | Some fm -> fm
    | None -> error "Semantic analysis error (calling undefined function %a)" pretty_id (id_make fname); raise Terminate
  in
  if List.mem fname libs then
    genLibCall fname fargs
  else
    let current_func_name =
      let current_block = insertion_block builder in
      value_name (block_parent current_block)
    in
    let is_recursive_call = (String.equal fname current_func_name) in
    let scc = !currentScope in
    let current_func_entry = lookupEntry (id_make current_func_name) LOOKUP_ALL_SCOPES true in
    let current_nesting_level = current_func_entry.entry_scope.sco_nesting in
    let e = lookupEntry (id_make fname) LOOKUP_ALL_SCOPES true in
    let callee_nesting_level = e.entry_scope.sco_nesting in
    let all_param_names = match e.entry_info with
      | ENTRY_function info -> List.map (fun p -> id_name p.entry_id) info.function_paramlist
      | _ -> error "%a is not a function" pretty_id (id_make fname); raise Terminate
      in
    let param_names = take (List.length fargs) all_param_names in
    let inner_func_vars = match e.entry_info with
      | ENTRY_function info -> info.function_local_vars
      | _ -> error "Expected function entry"; raise Terminate
    in
    (match e.entry_info with
    | ENTRY_function f ->
      if (f.function_isForward && (callee_nesting_level != current_nesting_level)) then (error "Function %a has not been defined" pretty_id (id_make fname); raise Terminate)
      else if f.function_actual_params != (List.length fargs) then (error "Wrong number of parameters passed to function %s" fname; raise Terminate)
    | _ -> error "Not a function");
    let pars_and_vars = param_names @ inner_func_vars in
    let outer_vars, outer_vars_names, outer_params, outer_params_names =
      let collected_vars = ref [] in
      let collected_vars_names = ref [] in
      let collected_params = ref [] in
      let collected_params_names = ref [] in
      List.iter (fun entry ->
        match entry.entry_info with
        | ENTRY_parameter param_info ->
          collected_params_names := (id_name entry.entry_id) :: !collected_params_names;
          let param_ptr =
            match param_info.parameter_type with
            | TYPE_array (_, _) ->
              param_info.parameter_ptr
            | _ ->
              build_gep param_info.parameter_ptr [| const_int int_type 0 |] "param_ptr" builder
          in
          collected_params := param_ptr :: !collected_params
        | ENTRY_variable var_info ->
          collected_vars_names := (id_name entry.entry_id) :: !collected_vars_names;
          let var_ptr =
            match var_info.variable_type with
            | TYPE_array (_, _) ->
              let gep = build_gep var_info.variable_ptr [|  const_int int_type 0 |] "array_ptr" builder in
              gep
            | _ ->
              build_gep var_info.variable_ptr [| const_int int_type 0 |] "var_ptr" builder
          in
          collected_vars := var_ptr :: !collected_vars
        | _ -> ()
      ) scc.sco_entries;
      !collected_vars, !collected_vars_names, !collected_params, !collected_params_names in
    let outer_args_tmp =
      if (callee_nesting_level = current_nesting_level) then begin
      match current_func_entry.entry_info with
        | ENTRY_function f -> List.rev (take ((List.length outer_params) - (f.function_actual_params)) (List.rev outer_params))
        | _                -> error "%s is not a function" current_func_name; raise Terminate
      end
      else
        (outer_vars @ outer_params)  in
    let outer_args = if outer_args_tmp = [] && (callee_nesting_level = current_nesting_level)
      then
        let outer = (match current_func_entry.entry_info with
          | ENTRY_function f -> List.rev (take ((List.length f.function_paramlist) - f.function_actual_params) (List.rev f.function_paramlist))
          | _ -> error "%s is not a function" fname; raise Terminate) in
        List.map (fun a -> match a.entry_info with
          | ENTRY_parameter p -> p.parameter_ptr
          | _                 -> error "not a parameter"; raise Terminate
        ) outer
      else outer_args_tmp in
    let outer_args_names = outer_vars_names @ outer_params_names in
    let isArray t = match t with
      | TYPE_array (_, _) -> true
      | _ -> false
    in
    let args =
      let fparams = match e.entry_info with
        | ENTRY_function info -> List.map (fun p -> match p.entry_info with
          | ENTRY_parameter param -> param
          | _ -> error "not a parameter"; raise Terminate
          ) info.function_paramlist
        | _ -> error "%a is not a function" pretty_id (id_make fname); raise Terminate
      in
      let rec process_lists args par_types_modes =
        match args, par_types_modes with
        | [], [] -> []
        | a::at, fp::fps ->
          let processed_arg, arg_type = match a with
            | Expr (exp, t) ->
              if fp.parameter_mode = PASS_BY_REFERENCE then
                (if (is_rvalue exp) then
                  (error "Cannot pass an r-value by reference in function %s" fname; raise Terminate)
                  else (exp, t))
              else
                let exp_type = Llvm.type_of exp in
                if Llvm.classify_type exp_type = Llvm.TypeKind.Pointer then
                  (Llvm.build_load exp "load_tmp" builder, t)
                else
                  (exp, t)
            | LValue (v, t, i) -> if fp.parameter_mode = PASS_BY_REFERENCE then
              genVarRead v i "ref"
              else genVarRead v i "val"
            | Str str ->
              let the_string = build_global_string str "string-lit" builder in
              (build_struct_gep the_string 0 "string_to_char_ptr" builder, TYPE_array (TYPE_char, []))
          in
          if not (equalType fp.parameter_type arg_type) then
            (error "Type mismatch for parameter %s of function %s: expected %s but got %s"
              fp.parameter_name
              fname
              (string_of_type fp.parameter_type)
              (string_of_type arg_type); raise Terminate)
          else
          processed_arg :: process_lists at fps
        | _ -> error "Wrong number of parameters passed to function %s" fname; raise Terminate
      in
      let n = List.length fargs in
      let fparams_new = take n fparams in
      process_lists fargs fparams_new
    in
    let all_args = if is_recursive_call then args @ List.rev (take ((List.length outer_params) - (List.length args)) (List.rev outer_args)) else args @ outer_args in
    build_call func (Array.of_list all_args) "" builder


let codegen func do_opts =
  Llvm_all_backends.initialize ();
  declareLib ();
  let has_errors = ref false in
  begin
    try
      match func () with
      | FuncDef (func_name, params, return_type, local_defs, body) ->
        (match params with
        | [] -> (match return_type with
          | TYPE_proc -> ignore (genFuncDef "main" params TYPE_int local_defs body false 0)
          | _         -> error "The return type of main must be nothing"; raise Terminate)
        | _  -> error "Main cannot take arguments"; raise Terminate)
      | _ ->
        error "Main function must be defined";
        has_errors := true
    with
    | ex -> has_errors := true
  end;
  if !has_errors || !Error.numErrors > 0 then
    ()
  else begin
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
    begin
      try
        print_module "a.ll" the_module;
        assert_valid_module the_module;
      with
      | ex -> error "Exception during module printing/validation: %s\n" (Printexc.to_string ex)
    end;
  end;
