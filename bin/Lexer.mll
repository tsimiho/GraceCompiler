{
open Parser
open Error

let escape1char scp = match scp with
    | 'n' -> '\n'
    | 't' -> '\t'
    | 'r' -> '\r'
    | '0' -> '\x00'
    | _ -> scp

let escape2char scp = Char.chr (int_of_string ("0x" ^(String.sub scp 2 (String.(length scp)-2))))

}


let digit  = ['0'-'9']
let letter = ['A'-'Z' 'a'-'z']
let white  = [' ' '\t' '\r']
let common = [^ '\'' '"' '\\' '\n']
let hex = ['0'-'9' 'a'-'f' 'A'-'F']
let escape = '\\' (['n' 't' 'r' '0' '\\' '\'' '"'] | ('x' hex hex ))
let escape1 = '\\' ['n' 't' 'r' '0' '\\' '\'' '"']
let escape2 = '\\' ('x' ( digit | ['a'-'f'] ) ( digit | ['a'-'f'] ) )
let chars = [^ '"' '\n' '\t' '\'' '\\']

rule lexer = parse
  | "and"       { T_and }
  | "char"	    { T_char }
  | "div"       { T_div }
  | "do"        { T_do }
  | "else"      { T_else }
  | "fun"       { T_fun }
  | "if"        { T_if }
  | "int"       { T_int }
  | "mod"       { T_mod }
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
  | "<-"        { T_assign }

  | letter (letter|digit|'_')* as id { T_id id }

  | '\n'                   { lines := !lines + 1; Lexing.new_line lexbuf; lexer lexbuf }
  | (digit+  as num_string) { T_int_const (int_of_string num_string) }
  | "'" (chars as ch) "'" {T_char_const ch}
  | "'" (escape1 as scp1) "'" {T_char_const (escape1char scp1.[1])}
  | "'" (escape2 as scp2) "'" {T_char_const (escape2char scp2)}
  | '"' {str_lit [] lexbuf}

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
                    lexer lexbuf
                  }

and comment = parse
  | "$$" { lexer lexbuf }
  | '\n' { lines := !lines + 1; Lexing.new_line lexbuf; comment lexbuf }
  | _ {comment lexbuf}

and str_lit acc = parse
  | '"' { T_string_literal (String.concat "" (List.map (String.make 1)  (List.rev acc)))  }
  | chars as ch { str_lit (ch::acc) lexbuf}
  | escape1 as scp1 { str_lit ((escape1char scp1.[1])::acc) lexbuf}
  | escape2 as scp2 { str_lit ((escape2char scp2)::acc) lexbuf}
