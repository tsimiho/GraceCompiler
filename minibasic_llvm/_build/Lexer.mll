{
open Lexing
open Parser
}

let digit  = ['0'-'9']
let letter = ['a'-'z']
let white  = [' ' '\t' '\r' '\n']

rule lexer = parse
    "print"  { T_print }
  | "let"    { T_let }
  | "for"    { T_for }
  | "do"     { T_do }
  | "begin"  { T_begin }
  | "end"    { T_end }
  | "if"     { T_if }
  | "then"   { T_then }

  | digit+   { T_const (int_of_string (lexeme lexbuf)) }
  | letter   { T_var (lexeme lexbuf).[0] }

  | '='      { T_eq }
  | '('      { T_lparen }
  | ')'      { T_rparen }
  | '+'      { T_plus }
  | '-'      { T_minus }
  | '*'      { T_times }

  | white+               { lexer lexbuf }
  | "'" [^ '\n']* "\n"   { lexer lexbuf }

  |  eof          { T_eof }
  |  _ as chr     { Printf.eprintf "invalid character: '%c' (ascii: %d)"
                      chr (Char.code chr);
                    lexer lexbuf }

