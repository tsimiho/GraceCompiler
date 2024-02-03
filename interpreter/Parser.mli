
(* The type of tokens. *)

type token = 
  | T_while
  | T_var
  | T_times
  | T_then
  | T_string_literal
  | T_semicolon
  | T_rparen
  | T_return
  | T_ref
  | T_rbrack
  | T_rbrace
  | T_prod
  | T_plus
  | T_or
  | T_nothing
  | T_not
  | T_more
  | T_mod
  | T_minus
  | T_lparen
  | T_less
  | T_leq
  | T_lbrack
  | T_lbrace
  | T_int_const
  | T_int
  | T_if
  | T_id
  | T_hash
  | T_geq
  | T_fun
  | T_eq
  | T_eof
  | T_else
  | T_do
  | T_div
  | T_comma
  | T_colon
  | T_char_const
  | T_char
  | T_and

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val program: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (unit -> unit)
