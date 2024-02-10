type var  = char
type oper = O_plus | O_minus | O_times

type ast_stmt =
| S_print of ast_expr
| S_let of var * ast_expr
| S_for of ast_expr * ast_stmt
| S_block of ast_stmt list
| S_if of ast_expr * ast_stmt

and ast_expr =
| E_const of int
| E_var of var
| E_op of ast_expr * oper * ast_expr

val run : ast_stmt list -> unit
val llvm_compile_and_dump : ast_stmt list -> unit

