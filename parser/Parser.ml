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

open Parsing
let _ = parse_error;;
let yytransl_const = [|
  257 (* T_eof *);
  258 (* T_and *);
  259 (* T_char *);
  260 (* T_div *);
  261 (* T_do *);
  262 (* T_else *);
  263 (* T_fun *);
  264 (* T_if *);
  265 (* T_int *);
  266 (* T_mod *);
  267 (* T_not *);
  268 (* T_nothing *);
  269 (* T_or *);
  270 (* T_ref *);
  271 (* T_return *);
  272 (* T_then *);
  273 (* T_var *);
  274 (* T_while *);
  275 (* T_id *);
  276 (* T_int_const *);
  277 (* T_char_const *);
  278 (* T_string_literal *);
  279 (* T_eq *);
  280 (* T_lparen *);
  281 (* T_rparen *);
  282 (* T_plus *);
  283 (* T_minus *);
  284 (* T_times *);
  285 (* T_less *);
  286 (* T_more *);
  287 (* T_lbrack *);
  288 (* T_rbrack *);
  289 (* T_lbrace *);
  290 (* T_rbrace *);
  291 (* T_hash *);
  292 (* T_comma *);
  293 (* T_semicolon *);
  294 (* T_colon *);
  295 (* T_leq *);
  296 (* T_geq *);
  297 (* T_prod *);
    0|]

let yytransl_block = [|
    0|]

let yylhs = "\255\255\
\001\000\002\000\004\000\004\000\003\000\003\000\008\000\008\000\
\007\000\007\000\010\000\010\000\012\000\012\000\013\000\013\000\
\009\000\009\000\011\000\011\000\014\000\006\000\006\000\006\000\
\015\000\016\000\017\000\017\000\017\000\017\000\017\000\017\000\
\017\000\017\000\017\000\005\000\022\000\022\000\020\000\020\000\
\023\000\023\000\018\000\018\000\018\000\019\000\019\000\019\000\
\019\000\019\000\019\000\019\000\019\000\019\000\019\000\019\000\
\019\000\021\000\021\000\021\000\021\000\021\000\021\000\021\000\
\021\000\021\000\021\000\000\000"

let yylen = "\002\000\
\002\000\003\000\000\000\002\000\008\000\006\000\000\000\003\000\
\005\000\004\000\000\000\003\000\001\000\001\000\000\000\004\000\
\001\000\001\000\004\000\002\000\002\000\001\000\001\000\001\000\
\002\000\006\000\001\000\004\000\001\000\002\000\004\000\006\000\
\004\000\002\000\003\000\003\000\000\000\002\000\003\000\005\000\
\000\000\003\000\001\000\001\000\004\000\001\000\001\000\001\000\
\003\000\001\000\002\000\002\000\003\000\003\000\003\000\003\000\
\003\000\003\000\002\000\003\000\003\000\003\000\003\000\003\000\
\003\000\003\000\003\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\068\000\000\000\000\000\000\000\001\000\
\000\000\022\000\000\000\000\000\000\000\023\000\024\000\000\000\
\000\000\025\000\000\000\002\000\004\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\044\000\
\027\000\029\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\046\000\047\000\
\000\000\000\000\000\000\000\000\000\000\050\000\000\000\000\000\
\034\000\000\000\000\000\000\000\038\000\000\000\000\000\030\000\
\036\000\000\000\000\000\014\000\013\000\018\000\006\000\017\000\
\000\000\000\000\012\000\000\000\000\000\059\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\035\000\000\000\039\000\000\000\000\000\000\000\000\000\
\010\000\000\000\008\000\000\000\000\000\021\000\026\000\049\000\
\058\000\056\000\057\000\000\000\000\000\000\000\055\000\000\000\
\000\000\000\000\000\000\000\000\060\000\000\000\000\000\033\000\
\000\000\000\000\045\000\028\000\009\000\000\000\020\000\005\000\
\000\000\000\000\000\000\040\000\000\000\000\000\032\000\042\000\
\019\000\016\000"

let yydgoto = "\002\000\
\004\000\010\000\011\000\012\000\034\000\013\000\025\000\043\000\
\071\000\027\000\105\000\072\000\110\000\077\000\014\000\015\000\
\035\000\052\000\053\000\054\000\055\000\038\000\130\000"

let yysindex = "\012\000\
\041\255\000\000\030\255\000\000\051\255\253\254\031\255\000\000\
\035\255\000\000\077\255\039\255\253\254\000\000\000\000\158\255\
\032\255\000\000\045\000\000\000\000\000\067\255\032\255\052\255\
\054\255\069\255\055\255\128\000\116\000\128\000\068\255\000\000\
\000\000\000\000\045\000\092\255\058\255\084\255\032\255\073\255\
\151\255\247\254\107\255\032\255\009\255\128\000\000\000\000\000\
\128\000\146\000\146\000\086\255\011\255\000\000\140\255\146\000\
\000\000\079\255\108\255\137\000\000\000\146\000\146\000\000\000\
\000\000\109\255\009\255\000\000\000\000\000\000\000\000\000\000\
\054\255\112\255\000\000\115\255\114\255\000\000\017\000\083\255\
\016\255\016\255\146\000\146\000\146\000\146\000\146\000\146\000\
\146\000\146\000\146\000\146\000\146\000\128\000\128\000\045\000\
\072\255\000\000\045\000\000\000\043\255\064\000\044\000\009\255\
\000\000\127\255\000\000\151\255\141\255\000\000\000\000\000\000\
\000\000\000\000\000\000\075\000\016\255\016\255\000\000\075\000\
\075\000\075\000\075\000\075\000\000\000\178\255\153\255\000\000\
\146\000\160\255\000\000\000\000\000\000\255\254\000\000\000\000\
\150\255\045\000\043\255\000\000\115\255\115\255\000\000\000\000\
\000\000\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\154\255\000\000\000\000\
\000\000\000\000\154\255\000\000\154\255\000\000\000\000\000\000\
\148\255\000\000\155\255\000\000\000\000\000\000\148\255\000\000\
\165\255\000\000\000\000\000\000\000\000\000\000\099\255\000\000\
\000\000\000\000\155\255\000\000\000\000\000\000\148\255\000\000\
\000\000\000\000\000\000\148\255\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\139\255\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\165\255\000\000\000\000\159\255\000\000\000\000\000\000\000\000\
\168\255\197\255\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\167\255\000\000\000\000\000\000\
\000\000\050\255\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\081\000\226\255\255\255\000\000\082\000\
\103\000\107\000\108\000\109\000\000\000\132\255\043\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\167\255\000\000\050\255\050\255\000\000\000\000\
\000\000\000\000"

let yygindex = "\000\000\
\000\000\187\000\200\000\193\000\197\000\000\000\169\000\139\000\
\106\000\244\255\111\000\219\255\157\255\000\000\000\000\000\000\
\163\255\237\255\229\255\238\255\235\255\181\000\078\000"

let yytablesize = 429
let yytable = "\036\000\
\037\000\058\000\127\000\003\000\022\000\128\000\135\000\076\000\
\059\000\023\000\040\000\068\000\001\000\009\000\083\000\036\000\
\037\000\069\000\137\000\083\000\084\000\079\000\081\000\082\000\
\078\000\084\000\066\000\080\000\097\000\106\000\141\000\075\000\
\101\000\085\000\102\000\103\000\086\000\087\000\088\000\089\000\
\090\000\145\000\146\000\088\000\143\000\091\000\083\000\003\000\
\007\000\092\000\093\000\008\000\084\000\017\000\016\000\114\000\
\115\000\116\000\117\000\118\000\119\000\120\000\121\000\122\000\
\123\000\124\000\106\000\026\000\086\000\087\000\088\000\019\000\
\125\000\126\000\015\000\083\000\036\000\037\000\129\000\036\000\
\037\000\084\000\083\000\003\000\094\000\039\000\015\000\044\000\
\084\000\041\000\042\000\060\000\045\000\009\000\064\000\095\000\
\112\000\086\000\087\000\088\000\043\000\139\000\043\000\043\000\
\086\000\087\000\088\000\113\000\043\000\094\000\067\000\043\000\
\099\000\018\000\043\000\098\000\062\000\065\000\036\000\037\000\
\095\000\043\000\062\000\043\000\043\000\043\000\043\000\043\000\
\043\000\043\000\043\000\074\000\063\000\043\000\043\000\043\000\
\061\000\043\000\043\000\043\000\048\000\094\000\048\000\048\000\
\061\000\109\000\104\000\061\000\048\000\108\000\111\000\048\000\
\095\000\068\000\048\000\096\000\061\000\134\000\138\000\069\000\
\137\000\048\000\070\000\048\000\048\000\048\000\048\000\048\000\
\048\000\051\000\048\000\022\000\051\000\048\000\048\000\048\000\
\023\000\048\000\048\000\094\000\051\000\142\000\024\000\051\000\
\140\000\011\000\003\000\005\000\037\000\007\000\051\000\041\000\
\051\000\051\000\051\000\015\000\051\000\051\000\052\000\051\000\
\006\000\052\000\051\000\051\000\051\000\021\000\051\000\051\000\
\020\000\052\000\073\000\107\000\052\000\136\000\133\000\061\000\
\144\000\000\000\000\000\052\000\000\000\052\000\052\000\052\000\
\000\000\052\000\052\000\053\000\052\000\000\000\053\000\052\000\
\052\000\052\000\000\000\052\000\052\000\000\000\053\000\000\000\
\000\000\053\000\000\000\000\000\000\000\000\000\000\000\000\000\
\053\000\000\000\053\000\053\000\053\000\000\000\053\000\053\000\
\054\000\053\000\000\000\054\000\053\000\053\000\053\000\000\000\
\053\000\053\000\000\000\054\000\000\000\000\000\054\000\000\000\
\000\000\000\000\000\000\000\000\083\000\054\000\000\000\054\000\
\054\000\054\000\084\000\054\000\054\000\000\000\054\000\000\000\
\000\000\054\000\054\000\054\000\000\000\054\000\054\000\085\000\
\000\000\112\000\086\000\087\000\088\000\089\000\090\000\083\000\
\000\000\000\000\031\000\091\000\028\000\084\000\000\000\092\000\
\093\000\031\000\000\000\029\000\031\000\031\000\030\000\031\000\
\031\000\000\000\032\000\083\000\000\000\086\000\087\000\088\000\
\000\000\084\000\000\000\031\000\031\000\019\000\083\000\031\000\
\132\000\033\000\062\000\064\000\084\000\062\000\064\000\000\000\
\000\000\086\000\087\000\088\000\000\000\062\000\064\000\131\000\
\062\000\064\000\000\000\000\000\086\000\087\000\088\000\000\000\
\065\000\062\000\064\000\065\000\063\000\066\000\067\000\063\000\
\066\000\067\000\000\000\065\000\000\000\000\000\065\000\063\000\
\066\000\067\000\063\000\066\000\067\000\000\000\000\000\065\000\
\000\000\000\000\000\000\063\000\066\000\067\000\031\000\047\000\
\048\000\032\000\046\000\056\000\000\000\050\000\051\000\000\000\
\000\000\000\000\031\000\047\000\048\000\032\000\000\000\049\000\
\057\000\050\000\051\000\031\000\047\000\048\000\032\000\000\000\
\056\000\100\000\050\000\051\000\031\000\047\000\048\000\032\000\
\000\000\056\000\000\000\050\000\051\000"

let yycheck = "\019\000\
\019\000\029\000\096\000\007\001\014\001\099\000\106\000\045\000\
\030\000\019\001\023\000\003\001\001\000\017\001\004\001\035\000\
\035\000\009\001\020\001\004\001\010\001\049\000\050\000\051\000\
\046\000\010\001\039\000\049\000\056\000\067\000\032\001\044\000\
\060\000\023\001\062\000\063\000\026\001\027\001\028\001\029\001\
\030\001\141\000\142\000\028\001\138\000\035\001\004\001\007\001\
\019\001\039\001\040\001\001\001\010\001\019\001\024\001\083\000\
\084\000\085\000\086\000\087\000\088\000\089\000\090\000\091\000\
\092\000\093\000\104\000\036\001\026\001\027\001\028\001\033\001\
\094\000\095\000\025\001\004\001\096\000\096\000\036\001\099\000\
\099\000\010\001\004\001\007\001\002\001\019\001\037\001\019\001\
\010\001\038\001\037\001\024\001\038\001\017\001\037\001\013\001\
\025\001\026\001\027\001\028\001\002\001\129\000\004\001\005\001\
\026\001\027\001\028\001\025\001\010\001\002\001\038\001\013\001\
\005\001\037\001\016\001\037\001\031\001\034\001\138\000\138\000\
\013\001\023\001\031\001\025\001\026\001\027\001\028\001\029\001\
\030\001\031\001\032\001\025\001\041\001\035\001\036\001\037\001\
\005\001\039\001\040\001\041\001\002\001\002\001\004\001\005\001\
\013\001\031\001\038\001\016\001\010\001\038\001\037\001\013\001\
\013\001\003\001\016\001\016\001\025\001\031\001\006\001\009\001\
\020\001\023\001\012\001\025\001\026\001\027\001\028\001\029\001\
\030\001\002\001\032\001\014\001\005\001\035\001\036\001\037\001\
\019\001\039\001\040\001\002\001\013\001\032\001\025\001\016\001\
\025\001\038\001\033\001\001\000\034\001\025\001\023\001\025\001\
\025\001\026\001\027\001\037\001\029\001\030\001\002\001\032\001\
\001\000\005\001\035\001\036\001\037\001\013\000\039\001\040\001\
\012\000\013\001\042\000\073\000\016\001\108\000\104\000\035\000\
\139\000\255\255\255\255\023\001\255\255\025\001\026\001\027\001\
\255\255\029\001\030\001\002\001\032\001\255\255\005\001\035\001\
\036\001\037\001\255\255\039\001\040\001\255\255\013\001\255\255\
\255\255\016\001\255\255\255\255\255\255\255\255\255\255\255\255\
\023\001\255\255\025\001\026\001\027\001\255\255\029\001\030\001\
\002\001\032\001\255\255\005\001\035\001\036\001\037\001\255\255\
\039\001\040\001\255\255\013\001\255\255\255\255\016\001\255\255\
\255\255\255\255\255\255\255\255\004\001\023\001\255\255\025\001\
\026\001\027\001\010\001\029\001\030\001\255\255\032\001\255\255\
\255\255\035\001\036\001\037\001\255\255\039\001\040\001\023\001\
\255\255\025\001\026\001\027\001\028\001\029\001\030\001\004\001\
\255\255\255\255\008\001\035\001\008\001\010\001\255\255\039\001\
\040\001\015\001\255\255\015\001\018\001\019\001\018\001\019\001\
\022\001\255\255\022\001\004\001\255\255\026\001\027\001\028\001\
\255\255\010\001\255\255\033\001\034\001\033\001\004\001\037\001\
\037\001\037\001\002\001\002\001\010\001\005\001\005\001\255\255\
\255\255\026\001\027\001\028\001\255\255\013\001\013\001\032\001\
\016\001\016\001\255\255\255\255\026\001\027\001\028\001\255\255\
\002\001\025\001\025\001\005\001\002\001\002\001\002\001\005\001\
\005\001\005\001\255\255\013\001\255\255\255\255\016\001\013\001\
\013\001\013\001\016\001\016\001\016\001\255\255\255\255\025\001\
\255\255\255\255\255\255\025\001\025\001\025\001\019\001\020\001\
\021\001\022\001\011\001\024\001\255\255\026\001\027\001\255\255\
\255\255\255\255\019\001\020\001\021\001\022\001\255\255\024\001\
\037\001\026\001\027\001\019\001\020\001\021\001\022\001\255\255\
\024\001\025\001\026\001\027\001\019\001\020\001\021\001\022\001\
\255\255\024\001\255\255\026\001\027\001"

let yynames_const = "\
  T_eof\000\
  T_and\000\
  T_char\000\
  T_div\000\
  T_do\000\
  T_else\000\
  T_fun\000\
  T_if\000\
  T_int\000\
  T_mod\000\
  T_not\000\
  T_nothing\000\
  T_or\000\
  T_ref\000\
  T_return\000\
  T_then\000\
  T_var\000\
  T_while\000\
  T_id\000\
  T_int_const\000\
  T_char_const\000\
  T_string_literal\000\
  T_eq\000\
  T_lparen\000\
  T_rparen\000\
  T_plus\000\
  T_minus\000\
  T_times\000\
  T_less\000\
  T_more\000\
  T_lbrack\000\
  T_rbrack\000\
  T_lbrace\000\
  T_rbrace\000\
  T_hash\000\
  T_comma\000\
  T_semicolon\000\
  T_colon\000\
  T_leq\000\
  T_geq\000\
  T_prod\000\
  "

let yynames_block = "\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'func_def) in
    Obj.repr(
# 55 "Parser.mly"
                        ( () )
# 356 "Parser.ml"
               : unit))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'header) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'local_def_list) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'block) in
    Obj.repr(
# 57 "Parser.mly"
                                      ( () )
# 365 "Parser.ml"
               : 'func_def))
; (fun __caml_parser_env ->
    Obj.repr(
# 59 "Parser.mly"
                              ( () )
# 371 "Parser.ml"
               : 'local_def_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'local_def) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'local_def_list) in
    Obj.repr(
# 60 "Parser.mly"
                                           ( () )
# 379 "Parser.ml"
               : 'local_def_list))
; (fun __caml_parser_env ->
    let _4 = (Parsing.peek_val __caml_parser_env 4 : 'fpar_def) in
    let _5 = (Parsing.peek_val __caml_parser_env 3 : 'semi_fpar_def_list) in
    let _8 = (Parsing.peek_val __caml_parser_env 0 : 'ret_type) in
    Obj.repr(
# 62 "Parser.mly"
                                                                                  ( () )
# 388 "Parser.ml"
               : 'header))
; (fun __caml_parser_env ->
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'ret_type) in
    Obj.repr(
# 63 "Parser.mly"
                                                        ( () )
# 395 "Parser.ml"
               : 'header))
; (fun __caml_parser_env ->
    Obj.repr(
# 65 "Parser.mly"
                                  ( () )
# 401 "Parser.ml"
               : 'semi_fpar_def_list))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'fpar_def) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'semi_fpar_def_list) in
    Obj.repr(
# 66 "Parser.mly"
                                                              ( () )
# 409 "Parser.ml"
               : 'semi_fpar_def_list))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 2 : 'comma_id_list) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'fpar_type) in
    Obj.repr(
# 68 "Parser.mly"
                                                     ( () )
# 417 "Parser.ml"
               : 'fpar_def))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'comma_id_list) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'fpar_type) in
    Obj.repr(
# 69 "Parser.mly"
                                                  ( () )
# 425 "Parser.ml"
               : 'fpar_def))
; (fun __caml_parser_env ->
    Obj.repr(
# 71 "Parser.mly"
                             ( () )
# 431 "Parser.ml"
               : 'comma_id_list))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'comma_id_list) in
    Obj.repr(
# 72 "Parser.mly"
                                            ( () )
# 438 "Parser.ml"
               : 'comma_id_list))
; (fun __caml_parser_env ->
    Obj.repr(
# 74 "Parser.mly"
                 ( () )
# 444 "Parser.ml"
               : 'data_type))
; (fun __caml_parser_env ->
    Obj.repr(
# 75 "Parser.mly"
                    ( () )
# 450 "Parser.ml"
               : 'data_type))
; (fun __caml_parser_env ->
    Obj.repr(
# 77 "Parser.mly"
                                      ( () )
# 456 "Parser.ml"
               : 'bracket_int_const_list))
; (fun __caml_parser_env ->
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'bracket_int_const_list) in
    Obj.repr(
# 78 "Parser.mly"
                                                                               ( () )
# 463 "Parser.ml"
               : 'bracket_int_const_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'data_type) in
    Obj.repr(
# 80 "Parser.mly"
                    ( () )
# 470 "Parser.ml"
               : 'ret_type))
; (fun __caml_parser_env ->
    Obj.repr(
# 81 "Parser.mly"
                      ( () )
# 476 "Parser.ml"
               : 'ret_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : 'data_type) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'bracket_int_const_list) in
    Obj.repr(
# 83 "Parser.mly"
                                                              ( () )
# 484 "Parser.ml"
               : 'fpar_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'data_type) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'bracket_int_const_list) in
    Obj.repr(
# 84 "Parser.mly"
                                              ( () )
# 492 "Parser.ml"
               : 'fpar_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'data_type) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'bracket_int_const_list) in
    Obj.repr(
# 86 "Parser.mly"
                                             ( () )
# 500 "Parser.ml"
               : 'grace_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'func_def) in
    Obj.repr(
# 88 "Parser.mly"
                    ( () )
# 507 "Parser.ml"
               : 'local_def))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'func_decl) in
    Obj.repr(
# 89 "Parser.mly"
                       ( () )
# 514 "Parser.ml"
               : 'local_def))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'var_def) in
    Obj.repr(
# 90 "Parser.mly"
                     ( () )
# 521 "Parser.ml"
               : 'local_def))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'header) in
    Obj.repr(
# 92 "Parser.mly"
                              ( () )
# 528 "Parser.ml"
               : 'func_decl))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 3 : 'comma_id_list) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : 'grace_type) in
    Obj.repr(
# 94 "Parser.mly"
                                                                 ( () )
# 536 "Parser.ml"
               : 'var_def))
; (fun __caml_parser_env ->
    Obj.repr(
# 96 "Parser.mly"
                                                   ( () )
# 542 "Parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : 'l_value) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 97 "Parser.mly"
                                                     ( () )
# 550 "Parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'block) in
    Obj.repr(
# 98 "Parser.mly"
                                           ( () )
# 557 "Parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'func_call) in
    Obj.repr(
# 99 "Parser.mly"
                                                   ( () )
# 564 "Parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'cond) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 100 "Parser.mly"
                                           ( () )
# 572 "Parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'cond) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'stmt) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 101 "Parser.mly"
                                           ( () )
# 581 "Parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'cond) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 102 "Parser.mly"
                                           ( () )
# 589 "Parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    Obj.repr(
# 103 "Parser.mly"
                                                   ( () )
# 595 "Parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 104 "Parser.mly"
                                                   ( () )
# 602 "Parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'stmt_list) in
    Obj.repr(
# 107 "Parser.mly"
                                   ( () )
# 609 "Parser.ml"
               : 'block))
; (fun __caml_parser_env ->
    Obj.repr(
# 109 "Parser.mly"
                         ( () )
# 615 "Parser.ml"
               : 'stmt_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'stmt) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'stmt_list) in
    Obj.repr(
# 110 "Parser.mly"
                            ( () )
# 623 "Parser.ml"
               : 'stmt_list))
; (fun __caml_parser_env ->
    Obj.repr(
# 112 "Parser.mly"
                                  ( () )
# 629 "Parser.ml"
               : 'func_call))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'comma_expr_list) in
    Obj.repr(
# 113 "Parser.mly"
                                                         ( () )
# 637 "Parser.ml"
               : 'func_call))
; (fun __caml_parser_env ->
    Obj.repr(
# 115 "Parser.mly"
                               ( () )
# 643 "Parser.ml"
               : 'comma_expr_list))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'comma_expr_list) in
    Obj.repr(
# 116 "Parser.mly"
                                                ( () )
# 651 "Parser.ml"
               : 'comma_expr_list))
; (fun __caml_parser_env ->
    Obj.repr(
# 118 "Parser.mly"
              ( () )
# 657 "Parser.ml"
               : 'l_value))
; (fun __caml_parser_env ->
    Obj.repr(
# 119 "Parser.mly"
                            ( () )
# 663 "Parser.ml"
               : 'l_value))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : 'l_value) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 120 "Parser.mly"
                                          ( () )
# 671 "Parser.ml"
               : 'l_value))
; (fun __caml_parser_env ->
    Obj.repr(
# 122 "Parser.mly"
                      ( () )
# 677 "Parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    Obj.repr(
# 123 "Parser.mly"
                        ( () )
# 683 "Parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'l_value) in
    Obj.repr(
# 124 "Parser.mly"
                ( () )
# 690 "Parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 125 "Parser.mly"
                                  ( () )
# 697 "Parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'func_call) in
    Obj.repr(
# 126 "Parser.mly"
                  ( () )
# 704 "Parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 127 "Parser.mly"
                    ( () )
# 711 "Parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 128 "Parser.mly"
                     ( () )
# 718 "Parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 129 "Parser.mly"
                           ( () )
# 726 "Parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 130 "Parser.mly"
                            ( () )
# 734 "Parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 131 "Parser.mly"
                            ( () )
# 742 "Parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 132 "Parser.mly"
                        ( () )
# 750 "Parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 133 "Parser.mly"
                        ( () )
# 758 "Parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'cond) in
    Obj.repr(
# 135 "Parser.mly"
                                 ( () )
# 765 "Parser.ml"
               : 'cond))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'cond) in
    Obj.repr(
# 136 "Parser.mly"
                   ( () )
# 772 "Parser.ml"
               : 'cond))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'cond) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'cond) in
    Obj.repr(
# 137 "Parser.mly"
                        ( () )
# 780 "Parser.ml"
               : 'cond))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'cond) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'cond) in
    Obj.repr(
# 138 "Parser.mly"
                       ( () )
# 788 "Parser.ml"
               : 'cond))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 139 "Parser.mly"
                          ( () )
# 796 "Parser.ml"
               : 'cond))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 140 "Parser.mly"
                            ( () )
# 804 "Parser.ml"
               : 'cond))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 141 "Parser.mly"
                            ( () )
# 812 "Parser.ml"
               : 'cond))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 142 "Parser.mly"
                            ( () )
# 820 "Parser.ml"
               : 'cond))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 143 "Parser.mly"
                          ( () )
# 828 "Parser.ml"
               : 'cond))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 144 "Parser.mly"
                          ( () )
# 836 "Parser.ml"
               : 'cond))
(* Entry program *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let program (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : unit)
