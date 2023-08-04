type var  = char
type oper = O_plus | O_minus | O_times
type typ  = TY_int | TY_bool

type ast_decl =
| Decl of var * int ref * typ

type ast_stmt =
| S_print of ast_expr
| S_let of var * int ref * ast_expr
| S_for of ast_expr * ast_stmt
| S_block of ast_block
| S_if of ast_expr * ast_stmt

and ast_expr =
| E_const of int
| E_var of var * int ref
| E_op of ast_expr * oper * ast_expr

and ast_block =
| Block of ast_decl list * ast_stmt list
