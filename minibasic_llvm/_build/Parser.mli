type token =
  | T_print
  | T_let
  | T_for
  | T_do
  | T_begin
  | T_end
  | T_if
  | T_then
  | T_const of (int)
  | T_var of (char)
  | T_eq
  | T_rparen
  | T_lparen
  | T_plus
  | T_minus
  | T_times
  | T_eof

val program :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Ast.ast_stmt list
