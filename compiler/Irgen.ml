open Llvm
open Llvm_analysis

let context = global_context ()
let the_module = create_module context "grace"
let builder = builder context

let int_type = i16_type context (* lltype *)
let byte_type = i8_type context
let bool_type = i1_type context
let proc_type = void_type context

let rec give_lltype grace_type =
    match grace_type with
    | TYPE_int                          -> int_type
    | TYPE_byte                         -> byte_type
    | TYPE_array (elem_type, _)         -> pointer_type (give_lltype elem_type) (* element type can only be a basic data type in alan - int or byte *)
    | _ -> fatal "grace to lltype didn't work"; raise Terminate



