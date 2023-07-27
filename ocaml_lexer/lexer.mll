{
type token =
  | T_eof | T_and | T_char | T_div | T_do | T_else | T_fun | T_if
  | T_int | T_mod | T_not | T_nothing | T_or | T_ref | T_return
  | T_then | T_var | T_while | T_id | T_int_const | T_char_const | T_string_literal
  | T_eq | T_lparen | T_rparen | T_plus | T_minus | T_times
  | T_less | T_more | T_lbrack | T_rbrack | T_lbrace | T_rbrace
  | T_hash | T_comma | T_semicolon | T_colon | T_leq | T_geq | T_prod


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


  | '\n'     { incr lines; lexer lexbuf }
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
  | '\n' { incr lines; comment lexbuf }
  | ([^ '$' '\n']|('$' [^ '$' '\n']))* {comment lexbuf} 

{
  let string_of_token token =
    match token with
      | T_eof       -> "T_eof"
      | T_and	    -> "T_and"
      | T_char	    -> "T_char"
      | T_div	    -> "T_div"
      | T_do	    -> "T_do"
      | T_else	    -> "T_else"
      | T_fun	    -> "T_fun"
      | T_if	    -> "T_if"
      | T_int	    -> "T_int"
      | T_mod	    -> "T_mod"
      | T_not       -> "T_not"
      | T_nothing   -> "T_nothing"
      | T_or        -> "T_or"
      | T_ref       -> "T_ref"
      | T_return    -> "T_return"
      | T_then      -> "T_then"
      | T_var       -> "T_var"
      | T_while     -> "T_while"
   
      | T_eq        -> "T_eq"
      | T_lparen    -> "T_lparen"
      | T_rparen    -> "T_rparen"
      | T_plus      -> "T_plus"
      | T_minus     -> "T_minus"
      | T_times     -> "T_times"
      | T_less      -> "T_less"
      | T_more      -> "T_more"
      | T_lbrack    -> "T_lbrack"
      | T_rbrack    -> "T_rbrack"
      | T_lbrace    -> "T_lbrace"
      | T_rbrace    -> "T_rbrace"
      | T_hash      -> "T_hash"
      | T_comma     -> "T_comma"
      | T_semicolon -> "T_semicolon"
      | T_colon     -> "T_colon"

      | T_id             -> "T_id"
      | T_int_const      -> "T_int_const"
      | T_string_literal -> "T_string_literal"
      | T_char_const     -> "T_char_const"
      | T_leq            -> "T_leq"
      | T_geq            -> "T_geq"
      | T_prod           -> "T_prod"


  let main =
    let lexbuf = Lexing.from_channel stdin in
    let rec loop () =
      let token = lexer lexbuf in
      Printf.printf "token = %s, lexeme = \"%s\"%d\n"
        (string_of_token token) (Lexing.lexeme lexbuf) (!lines);
      if token <> T_eof then loop () in
    loop ()
}
