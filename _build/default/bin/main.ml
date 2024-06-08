open Lexing
open Error

let main =
  let lexbuf = Lexing.from_channel stdin in
  try
    Parser.program Lexer.lexer lexbuf ();
    exit 0
  with Parsing.Parse_error ->
    error "Syntax error\n";
    exit 1
