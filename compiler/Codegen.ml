open Llvm
open Llvm_analysis
open Llvm_target
open Symbol
open Types
open Error

exception Terminate 

let context = global_context ()
let the_module = create_module context "grace"
let builder = builder context

let int_type = i16_type context (* lltype *)
let byte_type = i8_type context
let bool_type = i1_type context
let proc_type = void_type context
let void_type = void_type context

let rec typ_to_lltype grace_type =
    match grace_type with
    | TYPE_int                  -> int_type
    | TYPE_proc                 -> void_type
    | TYPE_array (base_type, _) -> pointer_type (typ_to_lltype base_type)
    | _ -> fatal "grace to lltype didn't work"; raise Terminate


let is_type_int llvm_type = 
    classify_type llvm_type = 
        TypeKind.Integer && integer_bitwidth llvm_type = 32


let is_type_char llvm_type = 
    classify_type llvm_type = 
        TypeKind.Integer && integer_bitwidth llvm_type = 8


let declare_variable name context builder =
    let i32_type = i32_type context in
    let alloca = build_alloca i32_type name builder in
    alloca

let generate_expr_value context builder value =
    const_int (i32_type context) value

let store_expr_value_in_var var_address expr_value builder =
    ignore (build_store expr_value var_address builder)

let declare_1d_array name size context builder =
    let array_type = array_type (i32_type context) size in
    let alloca = build_array_alloca array_type name builder in
    alloca

let calculate_element_address array_address index context builder =
    let zero = const_int (i32_type context) 0 in
    let indices = [| zero; const_int (i32_type context) index |] in
    build_gep array_address indices "elementPtr" builder

let load_variable_value var_address builder =
    Llvm.build_load var_address "loadtmp" builder

let load_array_element_value element_address builder =
    Llvm.build_load element_address "elementLoad" builder

(* let rec gen_fcall str frame f = *)
(*     let gen_param frame (arg, is_byref) = *)
(*         if (is_byref)  then *)
(*             begin *)
(*             let lval = match arg.kind with *)
(*             | Lval x -> x *)
(*             | _ -> internal "Semantic analysis error (parameter passed by ref \ *)
(*                                 but is not an lvalue"; raise Terminate *)
(*             in match lval with *)
(*             | Id lid -> gen_lval_id frame lid *)
(*             | StringLit s -> *)
(*                     let the_string = build_global_string s "string-lit" builder in *)
(*                     build_struct_gep the_string 0 "string_to_char_ptr" builder *)
(*             end *)
(*         else gen_expr frame arg *)
(*     in *)
(*     let func = match lookup_function f.full_name the_module with *)
(*     | Some x -> x *)
(*     | None -> internal "Semantic analysis error (calling undefined function)"; *)
(*                 raise Terminate *)
(*     in *)
(*     let expr_list = *)
(*         if (Array.length (params func) = List.length f.fargs) then *)
(*             List.map (gen_param frame) f.fargs *)
(*         else *)
(*             let nest_link = get_fr_ptr frame (f.fnest_diff + 1) *)
(*             in nest_link::(List.map (gen_param frame) f.fargs) *)
(*     in *)
(*         let expr_array = Array.of_list expr_list in *)
(*         build_call func expr_array str builder *)
(**)
(**)
(* let rec gen_func f isOuter = *)
(*     let helper x = match x with *)
(*     | FuncDef f -> gen_func f false *)
(*     | _ -> () *)
(*     in  List.iter helper f.def_list; *)
(*     let param_list = *)
(*         if isOuter *)
(*             then (List.map param_to_llvm_type f.par_list) *)
(*         else *)
(*             let parent_f = match f.parent_func with *)
(*             | Some x -> x *)
(*             | None -> internal "Trying to get parent function but pointer is not set"; *)
(*                         raise Terminate *)
(*             in let parent_ft = match parent_f.frame_t with *)
(*             | Some x -> x *)
(*             | None -> internal "Trying to get parent's frame_t but pointer is not set"; *)
(*                         raise Terminate *)
(*             in (pointer_type parent_ft)::(List.map param_to_llvm_type f.par_list) *)
(*     in *)
(*     let param_array = Array.of_list param_list in *)
(*     let ret_type = to_llvm_type f.ret_type in *)
(*     let func_t = function_type ret_type param_array in *)
(*     let func = match lookup_function f.nested_name the_module with *)
(*         | None -> declare_function f.nested_name func_t the_module *)
(*         | Some _ -> *)
(*                 internal "Semantic analysis error (function %s already declared)" *)
(*                 f.nested_name; raise Terminate *)
(*     in *)
(*     let bb = append_block context "entry" func in *)
(*     position_at_end bb builder; *)
(*     let frame_type = match f.frame_t with *)
(*     | Some x -> x *)
(*     | None -> internal "Trying to get frame_t but pointer is not set"; *)
(*                 raise Terminate *)
(*     in *)
(*     let frame = build_alloca frame_type "frame" builder in *)
(*     let i = ref 0 in *)
(*     let store_param param = *)
(*         let elem_ptr = build_struct_gep frame !i "frame_elem" builder in *)
(*         ignore(build_store param elem_ptr builder); incr i; *)
(*         in *)
(*     iter_params store_param func; *)
(*     List.iter (gen_stmt frame) f.comp_stmt; *)
(*     begin match block_terminator (insertion_block builder) with *)
(*     | None -> *)
(*         begin match f.ret_type with *)
(*         | TYPE_proc -> ignore(build_ret_void builder) *)
(*         | TYPE_int -> ignore(build_ret (const_int int_type 0) builder) *)
(*         | TYPE_byte -> ignore(build_ret (const_int char_type 0) builder) *)
(*         | _ -> internal "Function %s returns invalid type" f.nested_name; raise Terminate *)
(*         end *)
(*     | Some _ -> () end; *)
(*     if isOuter then begin *)
(*         match lookup_function "main" the_module with *)
(*         | Some _ -> () *)
(*         | None -> begin *)
(*             let main_func = declare_function "main" func_t the_module in *)
(*             let main_bb = append_block context "entry" main_func in *)
(*             position_at_end main_bb builder; *)
(*             if (return_type func_t != void_type) then begin *)
(*                 let res = build_call func (params main_func) "main_call" builder in *)
(*                 ignore(build_ret res builder) *)
(*             end else begin *)
(*                 ignore(build_call func (params main_func) "" builder); *)
(*                 ignore(build_ret_void builder) *)
(*             end *)
(*         end *)
(*     end *)


let genFuncDef func_name params return_type bodyFuncs =
    let llvm_return_type = typ_to_lltype return_type in
    let llvm_param_types = params in
    let func_type = function_type llvm_return_type (Array.of_list llvm_param_types) in
    let the_function = define_function func_name func_type the_module in
    let entry_block = append_block context "entry" the_function in
    position_at_end entry_block builder;
    List.iter (fun gen_ir -> gen_ir builder) bodyFuncs

(* let genFuncCall func_name args = *)
(*     let llvm_func =  *)
(*         match lookup_function func_name the_module with *)
(*         | Some f -> f *)
(*         | None -> error "Function '%s' not found." pretty_id func_name in *)
(*     let evaluated_args = List.map (fun gen -> gen ()) args in *)
(*     let call_instr = build_call llvm_func (Array.of_list evaluated_args) "calltmp" builder in *)
(*     call_instr *)


let genFuncDecl func_name param_types return_type =
  let llvm_return_type = typ_to_lltype return_type in
  let func_type = function_type llvm_return_type (Array.of_list param_types) in
  ignore (declare_function func_name func_type the_module)


(* let add_opts pm = *)
(*     let opts = [ *)
(*         add_memory_to_register_promotion; add_dead_arg_elimination; *)
(*         add_instruction_combination; add_cfg_simplification; *)
(*         add_function_inlining; add_function_attrs; add_scalar_repl_aggregation; *)
(*         add_early_cse; add_cfg_simplification; add_instruction_combination; *)
(*         add_tail_call_elimination; add_reassociation; add_loop_rotation; *)
(*         add_loop_unswitch; add_instruction_combination; add_cfg_simplification; *)
(*         add_ind_var_simplification; add_loop_idiom; add_loop_deletion; *)
(*         add_loop_unroll; add_gvn; add_memcpy_opt; add_sccp; add_licm; *)
(*         add_global_optimizer; add_global_dce; *)
(*         add_aggressive_dce; add_cfg_simplification; add_instruction_combination; *)
(*         add_dead_store_elimination; add_loop_vectorize; add_slp_vectorize; *)
(*         add_strip_dead_prototypes; add_global_dce;  *)
(*         add_cfg_simplification *)
(*     ] in *)
(*     List.iter (fun f -> f pm) opts *)


let codegen func do_opts =
    Llvm_all_backends.initialize ();
    let triple = Target.default_triple () in
    set_target_triple triple the_module;
    let target = Target.by_triple triple in
    let machine = TargetMachine.create ~triple:triple target in
    let dly = TargetMachine.data_layout machine in
    set_data_layout (DataLayout.as_string dly) the_module;
    (* declare_lib (); *)
    (* add_ft func; *)
    (* gen_func func true; *)
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
    assert_valid_module the_module
