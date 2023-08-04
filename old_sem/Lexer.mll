{
open Parser

let lines = ref 0

}


let digit  = ['0'-'9']
let letter = ['A'-'Z' 'a'-'z']
let white  = [' ' '\t' '\r']
let common = [^ '\'' '"' '\\' '\n']
let hex = ['0'-'9' 'a'-'f' 'A'-'F']
let escape = '\\' (['n' 't' 'r' '0' '\\' '\'' '"'] | ('x' hex hex ))

rule lexer = parse
  | "and"	    { T_and }
  | "char"	    { T_char }
  | "div"	    { T_div }
  | "do"	    { T_do }
  | "else"	    { T_else }
  | "fun"	    { T_fun }
  | "if"	    { T_if }
  | "int"	    { T_int }
  | "mod"	    { T_mod }
  | "not"       { T_not }
  | "nothing"   { T_nothing }
  | "or"        { T_or }
  | "ref"       { T_ref }
  | "return"    { T_return }
  | "then"      { T_then }
  | "var"       { T_var }
  | "while"     { T_while }
  | "<="        { T_leq }
  | ">="        { T_geq }
  | "<-"        { T_prod }

  | letter (letter|digit|'_')*  { T_id }


  | '\n'     { Lexing.new_line lexbuf; lexer lexbuf }
  | digit+   { T_int_const }
  | '\'' (letter | digit | common | escape ) '\'' { T_char_const }
  | '\"' (letter | digit | common | escape )* '\"' { T_string_literal }

  | '='       { T_eq }
  | '('       { T_lparen }
  | ')'       { T_rparen }
  | '+'       { T_plus }
  | '-'       { T_minus }
  | '*'       { T_times }
  | '<'       { T_less }
  | '>'       { T_more }
  | '['       { T_lbrack }
  | ']'       { T_rbrack }
  | '{'       { T_lbrace }
  | '}'       { T_rbrace }
  | '#'       { T_hash} 
  | ','       { T_comma }
  | ';'       { T_semicolon }
  | ':'       { T_colon } 

  | white+             { lexer lexbuf }
  | '$' [^ '\n' '$']*  { lexer lexbuf } 
  | "$$"               { comment lexbuf }
 

  |  eof          { T_eof }
  |  _ as chr     { Printf.eprintf "Invalid character: '%c' (ascii: %d) on line %d \n"
                    chr (Char.code chr) !lines;
                    lexer lexbuf }

and comment = parse
  | "$$" { lexer lexbuf }
  | '\n' { Lexing.new_line lexbuf; lexer lexbuf }
  | ([^ '$' '\n']|('$' [^ '$' '\n']))* {comment lexbuf} 

