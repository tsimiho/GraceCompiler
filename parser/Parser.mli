type token =
  | T_eof
  | T_and
  | T_char
  | T_div
  | T_do
  | T_else
  | T_fun
  | T_if
  | T_int
  | T_mod
  | T_not
  | T_nothing
  | T_or
  | T_ref
  | T_return
  | T_then
  | T_var
  | T_while
  | T_id
  | T_int_const
  | T_char_const
  | T_string_literal
  | T_eq
  | T_lparen
  | T_rparen
  | T_plus
  | T_minus
  | T_times
  | T_less
  | T_more
  | T_lbrack
  | T_rbrack
  | T_lbrace
  | T_rbrace
  | T_hash
  | T_comma
  | T_semicolon
  | T_colon
  | T_leq
  | T_geq
  | T_prod

val program :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> unit
