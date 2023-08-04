open Sem
open Interp

let main =
  let lexbuf = Lexing.from_channel stdin in
  try
    let ast = Parser.program Lexer.lexer lexbuf in
    sem ast;
    run ast;
    exit 0
  with
  | Parsing.Parse_error ->
      Printf.eprintf "syntax error\n";
      exit 1
  | TypeError ->
      Printf.eprintf "type mismatch\n";
      exit 1
  | Symbol.UnknownVariable x ->
      Printf.eprintf "unknown variable: %c\n" x;
      exit 1
  | Symbol.DuplicateVariable x ->
      Printf.eprintf "duplicate variable: %c\n" x;
      exit 1
