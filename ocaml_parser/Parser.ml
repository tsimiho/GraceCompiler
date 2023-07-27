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

open Parsing;;
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
\001\000\003\000\000\000\002\000\008\000\006\000\000\000\003\000\
\005\000\004\000\000\000\003\000\001\000\001\000\000\000\004\000\
\001\000\001\000\004\000\002\000\002\000\001\000\001\000\001\000\
\002\000\006\000\001\000\004\000\001\000\002\000\004\000\006\000\
\004\000\002\000\003\000\003\000\000\000\002\000\003\000\005\000\
\000\000\003\000\001\000\001\000\004\000\001\000\001\000\001\000\
\003\000\001\000\002\000\002\000\003\000\003\000\003\000\003\000\
\003\000\003\000\002\000\003\000\003\000\003\000\003\000\003\000\
\003\000\003\000\003\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\068\000\001\000\003\000\000\000\000\000\
\000\000\000\000\000\000\022\000\000\000\002\000\004\000\023\000\
\024\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\044\000\027\000\029\000\000\000\000\000\000\000\
\000\000\025\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\046\000\047\000\000\000\000\000\000\000\000\000\
\000\000\050\000\000\000\000\000\034\000\000\000\000\000\000\000\
\038\000\000\000\000\000\030\000\036\000\000\000\000\000\000\000\
\014\000\013\000\018\000\006\000\017\000\000\000\000\000\000\000\
\059\000\000\000\000\000\051\000\052\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\035\000\000\000\039\000\000\000\
\000\000\000\000\000\000\012\000\010\000\000\000\008\000\000\000\
\000\000\000\000\049\000\058\000\000\000\000\000\000\000\053\000\
\054\000\000\000\000\000\000\000\000\000\000\000\000\000\060\000\
\000\000\000\000\033\000\000\000\000\000\045\000\028\000\009\000\
\000\000\020\000\005\000\000\000\021\000\026\000\000\000\000\000\
\040\000\000\000\000\000\032\000\042\000\000\000\019\000\016\000"

let yydgoto = "\002\000\
\004\000\005\000\006\000\008\000\029\000\015\000\021\000\040\000\
\068\000\037\000\101\000\069\000\130\000\106\000\016\000\017\000\
\030\000\048\000\049\000\050\000\051\000\033\000\125\000"

let yysindex = "\010\000\
\007\255\000\000\012\255\000\000\000\000\000\000\016\255\005\255\
\078\255\029\255\072\000\000\000\017\255\000\000\000\000\000\000\
\000\000\058\255\049\255\048\255\052\255\049\255\103\000\091\000\
\103\000\067\255\000\000\000\000\000\000\072\000\074\255\069\255\
\079\255\000\000\049\255\089\255\096\255\143\255\252\254\113\255\
\105\255\103\000\000\000\000\000\103\000\040\000\040\000\114\255\
\042\000\000\000\019\255\040\000\000\000\042\255\177\255\112\000\
\000\000\040\000\040\000\000\000\000\000\110\255\049\255\004\255\
\000\000\000\000\000\000\000\000\000\000\052\255\126\255\004\255\
\000\000\015\000\065\255\000\000\000\000\040\000\040\000\040\000\
\040\000\040\000\040\000\040\000\040\000\040\000\040\000\040\000\
\103\000\103\000\072\000\008\000\000\000\072\000\000\000\047\000\
\023\255\072\255\004\255\000\000\000\000\120\255\000\000\143\255\
\134\255\132\255\000\000\000\000\045\255\045\255\084\255\000\000\
\000\000\045\255\084\255\084\255\084\255\084\255\084\255\000\000\
\175\255\179\255\000\000\040\000\163\255\000\000\000\000\000\000\
\021\255\000\000\000\000\174\255\000\000\000\000\072\000\047\000\
\000\000\159\255\134\255\000\000\000\000\134\255\000\000\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\169\255\000\000\011\255\000\000\000\000\000\000\
\000\000\000\000\166\255\000\000\172\255\166\255\000\000\000\000\
\000\000\091\255\000\000\000\000\000\000\169\255\000\000\000\000\
\000\000\000\000\166\255\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\131\255\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\166\255\000\000\
\000\000\000\000\000\000\000\000\000\000\172\255\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\183\255\
\000\000\000\000\000\000\000\000\000\000\050\255\000\000\000\000\
\181\255\000\000\000\000\000\000\170\255\209\255\137\255\000\000\
\000\000\248\255\171\255\176\255\210\255\215\255\254\255\000\000\
\124\255\070\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\183\255\
\000\000\000\000\050\255\000\000\000\000\050\255\000\000\000\000"

let yygindex = "\000\000\
\000\000\208\000\213\000\000\000\216\000\000\000\188\000\159\000\
\126\000\238\255\134\000\200\255\156\255\000\000\000\000\000\000\
\168\255\245\255\234\255\246\255\240\255\206\000\106\000"

let yytablesize = 395
let yytable = "\031\000\
\032\000\054\000\122\000\041\000\133\000\123\000\065\000\102\000\
\055\000\018\000\001\000\003\000\066\000\003\000\019\000\105\000\
\062\000\003\000\031\000\032\000\089\000\010\000\074\000\076\000\
\077\000\073\000\078\000\003\000\075\000\092\000\007\000\090\000\
\079\000\096\000\091\000\097\000\098\000\011\000\143\000\009\000\
\138\000\144\000\102\000\003\000\100\000\078\000\140\000\022\000\
\081\000\082\000\083\000\079\000\139\000\034\000\126\000\109\000\
\110\000\111\000\112\000\113\000\114\000\115\000\116\000\117\000\
\118\000\119\000\089\000\081\000\082\000\083\000\081\000\082\000\
\120\000\121\000\015\000\078\000\035\000\090\000\093\000\031\000\
\032\000\079\000\031\000\032\000\036\000\038\000\015\000\078\000\
\039\000\108\000\056\000\018\000\043\000\079\000\043\000\043\000\
\019\000\081\000\082\000\083\000\043\000\136\000\020\000\043\000\
\058\000\060\000\043\000\063\000\127\000\081\000\082\000\083\000\
\061\000\043\000\059\000\043\000\043\000\043\000\043\000\043\000\
\043\000\043\000\043\000\031\000\032\000\043\000\043\000\043\000\
\061\000\043\000\043\000\043\000\048\000\064\000\048\000\048\000\
\061\000\071\000\062\000\061\000\048\000\062\000\072\000\048\000\
\058\000\065\000\048\000\099\000\061\000\062\000\129\000\066\000\
\062\000\048\000\067\000\048\000\048\000\048\000\048\000\048\000\
\048\000\062\000\048\000\104\000\132\000\048\000\048\000\048\000\
\134\000\048\000\048\000\056\000\064\000\056\000\056\000\064\000\
\089\000\065\000\089\000\056\000\065\000\094\000\056\000\064\000\
\135\000\056\000\064\000\137\000\065\000\090\000\142\000\065\000\
\056\000\138\000\056\000\064\000\007\000\056\000\056\000\056\000\
\065\000\056\000\037\000\011\000\056\000\056\000\056\000\041\000\
\056\000\056\000\057\000\063\000\057\000\057\000\063\000\012\000\
\066\000\015\000\057\000\066\000\013\000\057\000\063\000\014\000\
\057\000\063\000\070\000\066\000\103\000\131\000\066\000\057\000\
\128\000\057\000\063\000\057\000\057\000\057\000\057\000\066\000\
\057\000\141\000\000\000\057\000\057\000\057\000\000\000\057\000\
\057\000\055\000\000\000\055\000\055\000\000\000\000\000\067\000\
\000\000\055\000\067\000\000\000\055\000\000\000\000\000\055\000\
\000\000\000\000\067\000\078\000\000\000\067\000\055\000\000\000\
\055\000\079\000\078\000\055\000\055\000\055\000\067\000\055\000\
\079\000\000\000\055\000\055\000\055\000\000\000\055\000\055\000\
\107\000\081\000\082\000\083\000\000\000\080\000\000\000\107\000\
\081\000\082\000\083\000\084\000\085\000\078\000\000\000\000\000\
\000\000\086\000\078\000\079\000\000\000\087\000\088\000\000\000\
\079\000\000\000\026\000\043\000\044\000\027\000\000\000\052\000\
\080\000\046\000\047\000\081\000\082\000\083\000\084\000\085\000\
\081\000\082\000\083\000\000\000\086\000\031\000\000\000\023\000\
\087\000\088\000\124\000\000\000\031\000\000\000\024\000\031\000\
\031\000\025\000\026\000\031\000\000\000\027\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\031\000\031\000\
\011\000\000\000\031\000\000\000\028\000\026\000\043\000\044\000\
\027\000\042\000\052\000\000\000\046\000\047\000\000\000\000\000\
\000\000\026\000\043\000\044\000\027\000\000\000\045\000\053\000\
\046\000\047\000\026\000\043\000\044\000\027\000\000\000\052\000\
\095\000\046\000\047\000"

let yycheck = "\011\000\
\011\000\024\000\091\000\022\000\105\000\094\000\003\001\064\000\
\025\000\014\001\001\000\007\001\009\001\007\001\019\001\072\000\
\035\000\007\001\030\000\030\000\002\001\017\001\045\000\046\000\
\047\000\042\000\004\001\017\001\045\000\052\000\019\001\013\001\
\010\001\056\000\016\001\058\000\059\000\033\001\139\000\024\001\
\020\001\142\000\099\000\033\001\063\000\004\001\135\000\019\001\
\026\001\027\001\028\001\010\001\032\001\037\001\032\001\078\000\
\079\000\080\000\081\000\082\000\083\000\084\000\085\000\086\000\
\087\000\088\000\002\001\026\001\027\001\028\001\026\001\027\001\
\089\000\090\000\025\001\004\001\019\001\013\001\037\001\091\000\
\091\000\010\001\094\000\094\000\036\001\038\001\037\001\004\001\
\037\001\025\001\024\001\014\001\002\001\010\001\004\001\005\001\
\019\001\026\001\027\001\028\001\010\001\124\000\025\001\013\001\
\031\001\037\001\016\001\019\001\037\001\026\001\027\001\028\001\
\034\001\023\001\041\001\025\001\026\001\027\001\028\001\029\001\
\030\001\031\001\032\001\135\000\135\000\035\001\036\001\037\001\
\005\001\039\001\040\001\041\001\002\001\038\001\004\001\005\001\
\013\001\025\001\002\001\016\001\010\001\005\001\038\001\013\001\
\031\001\003\001\016\001\038\001\025\001\013\001\031\001\009\001\
\016\001\023\001\012\001\025\001\026\001\027\001\028\001\029\001\
\030\001\025\001\032\001\038\001\031\001\035\001\036\001\037\001\
\037\001\039\001\040\001\002\001\002\001\004\001\005\001\005\001\
\002\001\002\001\002\001\010\001\005\001\005\001\013\001\013\001\
\006\001\016\001\016\001\025\001\013\001\013\001\032\001\016\001\
\023\001\020\001\025\001\025\001\025\001\028\001\029\001\030\001\
\025\001\032\001\034\001\038\001\035\001\036\001\037\001\025\001\
\039\001\040\001\002\001\002\001\004\001\005\001\005\001\008\000\
\002\001\037\001\010\001\005\001\008\000\013\001\013\001\008\000\
\016\001\016\001\039\000\013\001\070\000\104\000\016\001\023\001\
\099\000\025\001\025\001\030\000\028\001\029\001\030\001\025\001\
\032\001\136\000\255\255\035\001\036\001\037\001\255\255\039\001\
\040\001\002\001\255\255\004\001\005\001\255\255\255\255\002\001\
\255\255\010\001\005\001\255\255\013\001\255\255\255\255\016\001\
\255\255\255\255\013\001\004\001\255\255\016\001\023\001\255\255\
\025\001\010\001\004\001\028\001\029\001\030\001\025\001\032\001\
\010\001\255\255\035\001\036\001\037\001\255\255\039\001\040\001\
\025\001\026\001\027\001\028\001\255\255\023\001\255\255\025\001\
\026\001\027\001\028\001\029\001\030\001\004\001\255\255\255\255\
\255\255\035\001\004\001\010\001\255\255\039\001\040\001\255\255\
\010\001\255\255\019\001\020\001\021\001\022\001\255\255\024\001\
\023\001\026\001\027\001\026\001\027\001\028\001\029\001\030\001\
\026\001\027\001\028\001\255\255\035\001\008\001\255\255\008\001\
\039\001\040\001\036\001\255\255\015\001\255\255\015\001\018\001\
\019\001\018\001\019\001\022\001\255\255\022\001\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\033\001\034\001\
\033\001\255\255\037\001\255\255\037\001\019\001\020\001\021\001\
\022\001\011\001\024\001\255\255\026\001\027\001\255\255\255\255\
\255\255\019\001\020\001\021\001\022\001\255\255\024\001\037\001\
\026\001\027\001\019\001\020\001\021\001\022\001\255\255\024\001\
\025\001\026\001\027\001"

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
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'func_def) in
    Obj.repr(
# 55 "Parser.mly"
                  ( () )
# 345 "Parser.ml"
               : unit))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'header) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'local_def_list) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'block) in
    Obj.repr(
# 57 "Parser.mly"
                                      ( () )
# 354 "Parser.ml"
               : 'func_def))
; (fun __caml_parser_env ->
    Obj.repr(
# 59 "Parser.mly"
                              ( () )
# 360 "Parser.ml"
               : 'local_def_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'local_def_list) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'local_def) in
    Obj.repr(
# 60 "Parser.mly"
                                           ( () )
# 368 "Parser.ml"
               : 'local_def_list))
; (fun __caml_parser_env ->
    let _4 = (Parsing.peek_val __caml_parser_env 4 : 'fpar_def) in
    let _5 = (Parsing.peek_val __caml_parser_env 3 : 'semi_fpar_def_list) in
    let _8 = (Parsing.peek_val __caml_parser_env 0 : 'ret_type) in
    Obj.repr(
# 62 "Parser.mly"
                                                                                  ( () )
# 377 "Parser.ml"
               : 'header))
; (fun __caml_parser_env ->
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'ret_type) in
    Obj.repr(
# 63 "Parser.mly"
                                                        ( () )
# 384 "Parser.ml"
               : 'header))
; (fun __caml_parser_env ->
    Obj.repr(
# 65 "Parser.mly"
                                  ( () )
# 390 "Parser.ml"
               : 'semi_fpar_def_list))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'fpar_def) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'semi_fpar_def_list) in
    Obj.repr(
# 66 "Parser.mly"
                                                              ( () )
# 398 "Parser.ml"
               : 'semi_fpar_def_list))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 2 : 'comma_id_list) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'fpar_type) in
    Obj.repr(
# 68 "Parser.mly"
                                                     ( () )
# 406 "Parser.ml"
               : 'fpar_def))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'comma_id_list) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'fpar_type) in
    Obj.repr(
# 69 "Parser.mly"
                                                  ( () )
# 414 "Parser.ml"
               : 'fpar_def))
; (fun __caml_parser_env ->
    Obj.repr(
# 71 "Parser.mly"
                             ( () )
# 420 "Parser.ml"
               : 'comma_id_list))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'comma_id_list) in
    Obj.repr(
# 72 "Parser.mly"
                                            ( () )
# 427 "Parser.ml"
               : 'comma_id_list))
; (fun __caml_parser_env ->
    Obj.repr(
# 74 "Parser.mly"
                 ( () )
# 433 "Parser.ml"
               : 'data_type))
; (fun __caml_parser_env ->
    Obj.repr(
# 75 "Parser.mly"
                    ( () )
# 439 "Parser.ml"
               : 'data_type))
; (fun __caml_parser_env ->
    Obj.repr(
# 77 "Parser.mly"
                                      ( () )
# 445 "Parser.ml"
               : 'bracket_int_const_list))
; (fun __caml_parser_env ->
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'bracket_int_const_list) in
    Obj.repr(
# 78 "Parser.mly"
                                                                               ( () )
# 452 "Parser.ml"
               : 'bracket_int_const_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'data_type) in
    Obj.repr(
# 80 "Parser.mly"
                    ( () )
# 459 "Parser.ml"
               : 'ret_type))
; (fun __caml_parser_env ->
    Obj.repr(
# 81 "Parser.mly"
                      ( () )
# 465 "Parser.ml"
               : 'ret_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : 'data_type) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'bracket_int_const_list) in
    Obj.repr(
# 83 "Parser.mly"
                                                              ( () )
# 473 "Parser.ml"
               : 'fpar_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'data_type) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'bracket_int_const_list) in
    Obj.repr(
# 84 "Parser.mly"
                                              ( () )
# 481 "Parser.ml"
               : 'fpar_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'data_type) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'bracket_int_const_list) in
    Obj.repr(
# 86 "Parser.mly"
                                             ( () )
# 489 "Parser.ml"
               : 'grace_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'func_def) in
    Obj.repr(
# 88 "Parser.mly"
                    ( () )
# 496 "Parser.ml"
               : 'local_def))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'func_decl) in
    Obj.repr(
# 89 "Parser.mly"
                       ( () )
# 503 "Parser.ml"
               : 'local_def))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'var_def) in
    Obj.repr(
# 90 "Parser.mly"
                     ( () )
# 510 "Parser.ml"
               : 'local_def))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'header) in
    Obj.repr(
# 92 "Parser.mly"
                              ( () )
# 517 "Parser.ml"
               : 'func_decl))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 3 : 'comma_id_list) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : 'grace_type) in
    Obj.repr(
# 94 "Parser.mly"
                                                                 ( () )
# 525 "Parser.ml"
               : 'var_def))
; (fun __caml_parser_env ->
    Obj.repr(
# 96 "Parser.mly"
                                                   ( () )
# 531 "Parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : 'l_value) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 97 "Parser.mly"
                                                     ( () )
# 539 "Parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'block) in
    Obj.repr(
# 98 "Parser.mly"
                                           ( () )
# 546 "Parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'func_call) in
    Obj.repr(
# 99 "Parser.mly"
                                                   ( () )
# 553 "Parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'cond) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 100 "Parser.mly"
                                           ( () )
# 561 "Parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'cond) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'stmt) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 101 "Parser.mly"
                                           ( () )
# 570 "Parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'cond) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 102 "Parser.mly"
                                           ( () )
# 578 "Parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    Obj.repr(
# 103 "Parser.mly"
                                                   ( () )
# 584 "Parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 104 "Parser.mly"
                                                   ( () )
# 591 "Parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'stmt_list) in
    Obj.repr(
# 107 "Parser.mly"
                                   ( () )
# 598 "Parser.ml"
               : 'block))
; (fun __caml_parser_env ->
    Obj.repr(
# 109 "Parser.mly"
                         ( () )
# 604 "Parser.ml"
               : 'stmt_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'stmt) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'stmt_list) in
    Obj.repr(
# 110 "Parser.mly"
                            ( () )
# 612 "Parser.ml"
               : 'stmt_list))
; (fun __caml_parser_env ->
    Obj.repr(
# 112 "Parser.mly"
                                  ( () )
# 618 "Parser.ml"
               : 'func_call))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'comma_expr_list) in
    Obj.repr(
# 113 "Parser.mly"
                                                         ( () )
# 626 "Parser.ml"
               : 'func_call))
; (fun __caml_parser_env ->
    Obj.repr(
# 115 "Parser.mly"
                               ( () )
# 632 "Parser.ml"
               : 'comma_expr_list))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'comma_expr_list) in
    Obj.repr(
# 116 "Parser.mly"
                                                ( () )
# 640 "Parser.ml"
               : 'comma_expr_list))
; (fun __caml_parser_env ->
    Obj.repr(
# 118 "Parser.mly"
              ( () )
# 646 "Parser.ml"
               : 'l_value))
; (fun __caml_parser_env ->
    Obj.repr(
# 119 "Parser.mly"
                            ( () )
# 652 "Parser.ml"
               : 'l_value))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : 'l_value) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 120 "Parser.mly"
                                          ( () )
# 660 "Parser.ml"
               : 'l_value))
; (fun __caml_parser_env ->
    Obj.repr(
# 122 "Parser.mly"
                      ( () )
# 666 "Parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    Obj.repr(
# 123 "Parser.mly"
                        ( () )
# 672 "Parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'l_value) in
    Obj.repr(
# 124 "Parser.mly"
              ( () )
# 679 "Parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 125 "Parser.mly"
                                  ( () )
# 686 "Parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'func_call) in
    Obj.repr(
# 126 "Parser.mly"
                  ( () )
# 693 "Parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 127 "Parser.mly"
                    ( () )
# 700 "Parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 128 "Parser.mly"
                     ( () )
# 707 "Parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 129 "Parser.mly"
                           ( () )
# 715 "Parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 130 "Parser.mly"
                            ( () )
# 723 "Parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 131 "Parser.mly"
                            ( () )
# 731 "Parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 132 "Parser.mly"
                        ( () )
# 739 "Parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 133 "Parser.mly"
                        ( () )
# 747 "Parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'cond) in
    Obj.repr(
# 135 "Parser.mly"
                                 ( () )
# 754 "Parser.ml"
               : 'cond))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'cond) in
    Obj.repr(
# 136 "Parser.mly"
                   ( () )
# 761 "Parser.ml"
               : 'cond))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'cond) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'cond) in
    Obj.repr(
# 137 "Parser.mly"
                        ( () )
# 769 "Parser.ml"
               : 'cond))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'cond) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'cond) in
    Obj.repr(
# 138 "Parser.mly"
                       ( () )
# 777 "Parser.ml"
               : 'cond))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 139 "Parser.mly"
                          ( () )
# 785 "Parser.ml"
               : 'cond))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 140 "Parser.mly"
                            ( () )
# 793 "Parser.ml"
               : 'cond))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 141 "Parser.mly"
                            ( () )
# 801 "Parser.ml"
               : 'cond))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 142 "Parser.mly"
                            ( () )
# 809 "Parser.ml"
               : 'cond))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 143 "Parser.mly"
                          ( () )
# 817 "Parser.ml"
               : 'cond))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 144 "Parser.mly"
                          ( () )
# 825 "Parser.ml"
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
