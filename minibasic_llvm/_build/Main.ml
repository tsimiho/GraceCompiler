open Ast

let main =
  let lexbuf = Lexing.from_channel stdin in
  try
    let asts = Parser.program Lexer.lexer lexbuf in
    llvm_compile_and_dump asts;
    exit 0
  with Parsing.Parse_error ->
    Printf.eprintf "syntax error\n";
    exit 1

