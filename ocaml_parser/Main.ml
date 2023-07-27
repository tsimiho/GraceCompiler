let main =
  let lexbuf = Lexing.from_channel stdin in
  try
    Parser.program Lexer.lexer lexbuf;
    exit 0
  with
  | Parsing.Parse_error ->
      let curr_pos = lexbuf.Lexing.lex_curr_p in
      let line = curr_pos.Lexing.pos_lnum in
      let col = curr_pos.Lexing.pos_cnum - curr_pos.Lexing.pos_bol in
      let token = Lexing.lexeme lexbuf in
      Printf.eprintf "Syntax error at line %d, column %d: unexpected token '%s'\n" line col token;
      exit 1
