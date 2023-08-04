type symbol_table
type symbol_entry

exception UnknownVariable of Ast.var
exception DuplicateVariable of Ast.var

val st : symbol_table

val open_scope : symbol_table -> unit
val close_scope : symbol_table -> unit

val lookup : symbol_table -> Ast.var -> symbol_entry
val insert : symbol_table -> Ast.var -> Ast.typ -> int

val get_type : symbol_entry -> Ast.typ
val get_offset : symbol_entry -> int
