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
  | T_id of (string)
  | T_int_const of (int)
  | T_char_const of (char)
  | T_string_literal of (string)
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
  | T_assign

open Parsing;;
let _ = parse_error;;
# 2 "bin/Parser.mly"
  open Llvm
  open Parsing
  open Symbol
  open Types
  open Identifier
  open Error
  open Codegen

  let main = ref true

  type lvalue =
    | Var of string
    | StrLit of string

  let rec string_of_type x = match x with
      | TYPE_none -> "none"
      | TYPE_int -> "int"
      | TYPE_char -> "char"
      | TYPE_proc -> "proc"
      | TYPE_array (y, _) -> "array of " ^ (string_of_type y)

# 69 "bin/Parser.ml"
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
  297 (* T_assign *);
    0|]

let yytransl_block = [|
  275 (* T_id *);
  276 (* T_int_const *);
  277 (* T_char_const *);
  278 (* T_string_literal *);
    0|]

let yylhs = "\255\255\
\001\000\002\000\003\000\003\000\004\000\004\000\005\000\005\000\
\006\000\006\000\007\000\007\000\008\000\008\000\009\000\009\000\
\010\000\010\000\011\000\011\000\012\000\013\000\013\000\013\000\
\014\000\015\000\016\000\016\000\016\000\016\000\016\000\016\000\
\016\000\016\000\016\000\017\000\018\000\018\000\019\000\019\000\
\020\000\020\000\021\000\021\000\021\000\022\000\022\000\022\000\
\022\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
\022\000\023\000\023\000\023\000\023\000\023\000\023\000\023\000\
\023\000\023\000\023\000\000\000"

let yylen = "\002\000\
\002\000\003\000\000\000\002\000\007\000\006\000\001\000\003\000\
\004\000\003\000\001\000\003\000\001\000\001\000\000\000\004\000\
\001\000\001\000\004\000\002\000\002\000\001\000\001\000\001\000\
\002\000\005\000\001\000\004\000\001\000\002\000\004\000\006\000\
\004\000\002\000\003\000\003\000\000\000\002\000\003\000\004\000\
\001\000\003\000\001\000\001\000\004\000\001\000\001\000\001\000\
\003\000\001\000\002\000\002\000\003\000\003\000\003\000\003\000\
\003\000\003\000\002\000\003\000\003\000\003\000\003\000\003\000\
\003\000\003\000\003\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\068\000\000\000\000\000\000\000\001\000\
\000\000\022\000\000\000\000\000\000\000\023\000\024\000\000\000\
\000\000\000\000\000\000\002\000\025\000\004\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\044\000\027\000\000\000\029\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\012\000\014\000\013\000\
\000\000\000\000\000\000\046\000\047\000\000\000\000\000\000\000\
\050\000\000\000\000\000\000\000\000\000\034\000\000\000\000\000\
\000\000\038\000\036\000\030\000\000\000\000\000\000\000\018\000\
\017\000\006\000\000\000\008\000\000\000\010\000\000\000\021\000\
\026\000\059\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\035\000\000\000\039\000\
\000\000\000\000\000\000\000\000\009\000\005\000\000\000\020\000\
\000\000\049\000\058\000\056\000\057\000\000\000\000\000\000\000\
\055\000\000\000\000\000\000\000\000\000\000\000\060\000\000\000\
\000\000\033\000\040\000\000\000\045\000\028\000\000\000\000\000\
\000\000\042\000\019\000\016\000\032\000"

let yydgoto = "\002\000\
\004\000\010\000\011\000\012\000\025\000\026\000\027\000\073\000\
\080\000\074\000\078\000\050\000\013\000\014\000\015\000\036\000\
\037\000\038\000\057\000\105\000\058\000\059\000\060\000"

let yysindex = "\006\000\
\009\255\000\000\001\255\000\000\023\255\006\255\022\255\000\000\
\052\255\000\000\045\255\253\254\006\255\000\000\000\000\080\255\
\043\255\068\255\060\000\000\000\000\000\000\000\052\255\069\255\
\107\255\099\255\106\255\052\255\130\255\132\000\120\000\132\000\
\113\255\000\000\000\000\060\000\000\000\111\255\121\255\061\255\
\128\255\137\255\131\255\035\255\130\255\000\000\000\000\000\000\
\132\255\134\255\132\000\000\000\000\000\132\000\150\000\150\000\
\000\000\141\255\030\000\031\255\150\000\000\000\011\255\091\255\
\141\000\000\000\000\000\000\000\150\000\150\000\130\255\000\000\
\000\000\000\000\137\255\000\000\142\255\000\000\148\255\000\000\
\000\000\000\000\003\000\084\255\002\255\002\255\150\000\150\000\
\150\000\150\000\150\000\150\000\150\000\150\000\150\000\150\000\
\150\000\132\000\132\000\060\000\077\000\000\000\060\000\000\000\
\149\255\035\000\025\255\046\255\000\000\000\000\246\254\000\000\
\143\255\000\000\000\000\000\000\000\000\080\000\002\255\002\255\
\000\000\080\000\080\000\080\000\080\000\080\000\000\000\174\255\
\172\255\000\000\000\000\150\000\000\000\000\000\132\255\132\255\
\060\000\000\000\000\000\000\000\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\159\255\000\000\000\000\
\000\000\000\000\000\000\159\255\159\255\000\000\000\000\000\000\
\144\255\000\000\153\255\000\000\000\000\000\000\000\000\000\000\
\000\000\170\255\000\000\000\000\000\000\000\000\000\000\000\000\
\085\255\000\000\000\000\153\255\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\160\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\125\255\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\018\255\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\154\255\183\255\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\173\255\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\075\255\212\255\241\255\
\000\000\039\000\096\000\109\000\111\000\113\000\000\000\118\255\
\058\000\000\000\000\000\000\000\000\000\000\000\018\255\018\255\
\000\000\000\000\000\000\000\000\000\000"

let yygindex = "\000\000\
\000\000\199\000\188\000\201\000\159\000\000\000\119\000\230\255\
\190\255\129\000\134\000\000\000\000\000\000\000\000\000\161\255\
\196\000\175\000\237\255\084\000\238\255\227\255\233\255"

let yytablesize = 433
let yytable = "\039\000\
\040\000\063\000\049\000\003\000\129\000\087\000\001\000\130\000\
\064\000\113\000\112\000\088\000\003\000\009\000\087\000\003\000\
\039\000\040\000\077\000\007\000\088\000\135\000\009\000\008\000\
\083\000\085\000\086\000\082\000\087\000\092\000\084\000\101\000\
\098\000\021\000\088\000\106\000\090\000\091\000\092\000\107\000\
\108\000\141\000\015\000\099\000\077\000\016\000\100\000\102\000\
\023\000\087\000\090\000\091\000\092\000\017\000\015\000\088\000\
\133\000\116\000\117\000\118\000\119\000\120\000\121\000\122\000\
\123\000\124\000\125\000\126\000\139\000\140\000\017\000\090\000\
\091\000\092\000\127\000\128\000\062\000\019\000\028\000\062\000\
\039\000\040\000\134\000\039\000\040\000\098\000\043\000\062\000\
\043\000\043\000\062\000\069\000\098\000\023\000\043\000\103\000\
\099\000\043\000\017\000\062\000\043\000\070\000\106\000\099\000\
\024\000\029\000\042\000\043\000\115\000\043\000\043\000\043\000\
\043\000\043\000\043\000\043\000\043\000\039\000\040\000\043\000\
\043\000\043\000\061\000\043\000\043\000\043\000\048\000\018\000\
\048\000\048\000\061\000\043\000\047\000\061\000\048\000\044\000\
\065\000\048\000\048\000\047\000\048\000\041\000\061\000\045\000\
\067\000\048\000\046\000\048\000\072\000\048\000\048\000\048\000\
\048\000\048\000\048\000\051\000\048\000\068\000\051\000\048\000\
\048\000\048\000\079\000\048\000\048\000\071\000\051\000\113\000\
\075\000\051\000\081\000\069\000\111\000\131\000\136\000\098\000\
\051\000\137\000\051\000\051\000\051\000\011\000\051\000\051\000\
\052\000\051\000\037\000\052\000\051\000\051\000\051\000\003\000\
\051\000\051\000\007\000\052\000\015\000\041\000\052\000\005\000\
\022\000\006\000\076\000\110\000\109\000\052\000\020\000\052\000\
\052\000\052\000\066\000\052\000\052\000\053\000\052\000\138\000\
\053\000\052\000\052\000\052\000\000\000\052\000\052\000\000\000\
\053\000\000\000\000\000\053\000\000\000\000\000\000\000\000\000\
\000\000\000\000\053\000\000\000\053\000\053\000\053\000\000\000\
\053\000\053\000\054\000\053\000\000\000\054\000\053\000\053\000\
\053\000\000\000\053\000\053\000\000\000\054\000\000\000\000\000\
\054\000\000\000\000\000\000\000\000\000\000\000\087\000\054\000\
\000\000\054\000\054\000\054\000\088\000\054\000\054\000\000\000\
\054\000\000\000\000\000\054\000\054\000\054\000\000\000\054\000\
\054\000\089\000\000\000\114\000\090\000\091\000\092\000\093\000\
\094\000\087\000\000\000\000\000\000\000\095\000\087\000\088\000\
\064\000\096\000\097\000\064\000\088\000\000\000\000\000\000\000\
\000\000\000\000\000\000\064\000\089\000\000\000\064\000\090\000\
\091\000\092\000\093\000\094\000\090\000\091\000\092\000\064\000\
\095\000\031\000\000\000\030\000\096\000\097\000\132\000\000\000\
\031\000\000\000\031\000\031\000\031\000\032\000\033\000\031\000\
\087\000\034\000\000\000\087\000\000\000\000\000\088\000\000\000\
\000\000\088\000\031\000\031\000\019\000\000\000\031\000\000\000\
\035\000\065\000\000\000\000\000\065\000\114\000\090\000\091\000\
\092\000\090\000\091\000\092\000\065\000\000\000\063\000\065\000\
\066\000\063\000\067\000\066\000\000\000\067\000\000\000\000\000\
\065\000\063\000\000\000\066\000\063\000\067\000\066\000\000\000\
\067\000\000\000\000\000\000\000\000\000\063\000\000\000\066\000\
\000\000\067\000\033\000\052\000\053\000\034\000\051\000\061\000\
\000\000\055\000\056\000\000\000\000\000\000\000\033\000\052\000\
\053\000\034\000\000\000\054\000\062\000\055\000\056\000\033\000\
\052\000\053\000\034\000\000\000\061\000\104\000\055\000\056\000\
\033\000\052\000\053\000\034\000\000\000\061\000\000\000\055\000\
\056\000"

let yycheck = "\019\000\
\019\000\031\000\029\000\007\001\100\000\004\001\001\000\103\000\
\032\000\020\001\077\000\010\001\007\001\017\001\004\001\007\001\
\036\000\036\000\045\000\019\001\010\001\032\001\017\001\001\001\
\054\000\055\000\056\000\051\000\004\001\028\001\054\000\061\000\
\002\001\037\001\010\001\065\000\026\001\027\001\028\001\069\000\
\070\000\137\000\025\001\013\001\071\000\024\001\016\001\037\001\
\014\001\004\001\026\001\027\001\028\001\019\001\037\001\010\001\
\032\001\087\000\088\000\089\000\090\000\091\000\092\000\093\000\
\094\000\095\000\096\000\097\000\135\000\136\000\019\001\026\001\
\027\001\028\001\098\000\099\000\002\001\033\001\036\001\005\001\
\100\000\100\000\037\001\103\000\103\000\002\001\002\001\013\001\
\004\001\005\001\016\001\031\001\002\001\014\001\010\001\005\001\
\013\001\013\001\019\001\025\001\016\001\041\001\132\000\013\001\
\025\001\038\001\038\001\023\001\025\001\025\001\026\001\027\001\
\028\001\029\001\030\001\031\001\032\001\137\000\137\000\035\001\
\036\001\037\001\005\001\039\001\040\001\041\001\002\001\009\000\
\004\001\005\001\013\001\025\001\003\001\016\001\010\001\037\001\
\024\001\013\001\009\001\003\001\016\001\023\000\025\001\038\001\
\034\001\009\001\028\000\023\001\012\001\025\001\026\001\027\001\
\028\001\029\001\030\001\002\001\032\001\037\001\005\001\035\001\
\036\001\037\001\031\001\039\001\040\001\038\001\013\001\020\001\
\038\001\016\001\037\001\031\001\031\001\025\001\032\001\002\001\
\023\001\006\001\025\001\026\001\027\001\038\001\029\001\030\001\
\002\001\032\001\034\001\005\001\035\001\036\001\037\001\033\001\
\039\001\040\001\025\001\013\001\037\001\025\001\016\001\001\000\
\013\000\001\000\044\000\075\000\071\000\023\001\011\000\025\001\
\026\001\027\001\036\000\029\001\030\001\002\001\032\001\132\000\
\005\001\035\001\036\001\037\001\255\255\039\001\040\001\255\255\
\013\001\255\255\255\255\016\001\255\255\255\255\255\255\255\255\
\255\255\255\255\023\001\255\255\025\001\026\001\027\001\255\255\
\029\001\030\001\002\001\032\001\255\255\005\001\035\001\036\001\
\037\001\255\255\039\001\040\001\255\255\013\001\255\255\255\255\
\016\001\255\255\255\255\255\255\255\255\255\255\004\001\023\001\
\255\255\025\001\026\001\027\001\010\001\029\001\030\001\255\255\
\032\001\255\255\255\255\035\001\036\001\037\001\255\255\039\001\
\040\001\023\001\255\255\025\001\026\001\027\001\028\001\029\001\
\030\001\004\001\255\255\255\255\255\255\035\001\004\001\010\001\
\002\001\039\001\040\001\005\001\010\001\255\255\255\255\255\255\
\255\255\255\255\255\255\013\001\023\001\255\255\016\001\026\001\
\027\001\028\001\029\001\030\001\026\001\027\001\028\001\025\001\
\035\001\008\001\255\255\008\001\039\001\040\001\036\001\255\255\
\015\001\255\255\015\001\018\001\019\001\018\001\019\001\022\001\
\004\001\022\001\255\255\004\001\255\255\255\255\010\001\255\255\
\255\255\010\001\033\001\034\001\033\001\255\255\037\001\255\255\
\037\001\002\001\255\255\255\255\005\001\025\001\026\001\027\001\
\028\001\026\001\027\001\028\001\013\001\255\255\002\001\016\001\
\002\001\005\001\002\001\005\001\255\255\005\001\255\255\255\255\
\025\001\013\001\255\255\013\001\016\001\013\001\016\001\255\255\
\016\001\255\255\255\255\255\255\255\255\025\001\255\255\025\001\
\255\255\025\001\019\001\020\001\021\001\022\001\011\001\024\001\
\255\255\026\001\027\001\255\255\255\255\255\255\019\001\020\001\
\021\001\022\001\255\255\024\001\037\001\026\001\027\001\019\001\
\020\001\021\001\022\001\255\255\024\001\025\001\026\001\027\001\
\019\001\020\001\021\001\022\001\255\255\024\001\255\255\026\001\
\027\001"

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
  T_assign\000\
  "

let yynames_block = "\
  T_id\000\
  T_int_const\000\
  T_char_const\000\
  T_string_literal\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : unit -> unit) in
    Obj.repr(
# 102 "bin/Parser.mly"
                        ( fun _ -> initSymbolTable 1000;
                                   codegen _1 false
                        )
# 380 "bin/Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> string * param list * typ) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : unit -> local_def list) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> (unit -> unit) list) in
    Obj.repr(
# 106 "bin/Parser.mly"
                                      ( fun _ -> let (func_name, params, return_type) = _1 () in
                                                 let local_defs = _2 () in
                                                 let body = _3 () in
                                                 let is_main = !main in
                                                 if is_main then main := false;
                                                 genFuncDef func_name params return_type local_defs body is_main;
                                                 closeScope ()
                                      )
# 396 "bin/Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    Obj.repr(
# 115 "bin/Parser.mly"
                                         ( fun _ -> [] )
# 402 "bin/Parser.ml"
               : unit -> local_def list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : local_def) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit -> local_def list) in
    Obj.repr(
# 116 "bin/Parser.mly"
                                         ( fun _ -> _1 :: _2 () )
# 410 "bin/Parser.ml"
               : unit -> local_def list))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 5 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 3 : unit -> param list) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : unit -> typ) in
    Obj.repr(
# 118 "bin/Parser.mly"
                                                                    ( fun _ -> let id = _2 in
                                                                               let params = _4 () in
                                                                               let return_type = _7 () in
                                                                               (id, params, return_type)
                                                                    )
# 423 "bin/Parser.ml"
               : unit -> string * param list * typ))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : unit -> typ) in
    Obj.repr(
# 123 "bin/Parser.mly"
                                                                    ( fun _ -> let id = _2 in
                                                                               let params = [] in
                                                                               let return_type = _6 () in
                                                                               (id, params, return_type)
                                                                    )
# 435 "bin/Parser.ml"
               : unit -> string * param list * typ))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit -> param) in
    Obj.repr(
# 129 "bin/Parser.mly"
                                                  ( fun _ -> [_1 ()] )
# 442 "bin/Parser.ml"
               : unit -> param list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> param) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> param list) in
    Obj.repr(
# 130 "bin/Parser.mly"
                                                  ( fun _ -> _1 () :: _3 () )
# 450 "bin/Parser.ml"
               : unit -> param list))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : unit -> string list) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : unit -> typ) in
    Obj.repr(
# 132 "bin/Parser.mly"
                                                ( fun _ -> let params = _2 () in
                                                           let param_type = _4 () in
                                                           let mode = PASS_BY_REFERENCE in
                                                           { id = params; mode = mode; param_type = param_type }
                                                )
# 462 "bin/Parser.ml"
               : unit -> param))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> string list) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> typ) in
    Obj.repr(
# 137 "bin/Parser.mly"
                                                ( fun _ -> let params = _1 () in
                                                           let param_type = _3 () in
                                                           let mode = PASS_BY_VALUE in
                                                           { id = params; mode = mode; param_type = param_type }
                                                )
# 474 "bin/Parser.ml"
               : unit -> param))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 143 "bin/Parser.mly"
                                          ( fun _ -> [_1] )
# 481 "bin/Parser.ml"
               : unit -> string list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> string list) in
    Obj.repr(
# 144 "bin/Parser.mly"
                                          ( fun _ -> _1 :: _3 () )
# 489 "bin/Parser.ml"
               : unit -> string list))
; (fun __caml_parser_env ->
    Obj.repr(
# 146 "bin/Parser.mly"
                  ( fun _ -> TYPE_int )
# 495 "bin/Parser.ml"
               : unit -> typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 147 "bin/Parser.mly"
                  ( fun _ -> TYPE_char )
# 501 "bin/Parser.ml"
               : unit -> typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 149 "bin/Parser.mly"
                                                     ( fun _ -> [] )
# 507 "bin/Parser.ml"
               : unit -> int list))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : int) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : unit -> int list) in
    Obj.repr(
# 150 "bin/Parser.mly"
                                                     ( fun _ -> _2 :: _4 () )
# 515 "bin/Parser.ml"
               : unit -> int list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit -> typ) in
    Obj.repr(
# 152 "bin/Parser.mly"
                    ( fun _ -> _1 () )
# 522 "bin/Parser.ml"
               : unit -> typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 153 "bin/Parser.mly"
                    ( fun _ -> TYPE_proc )
# 528 "bin/Parser.ml"
               : unit -> typ))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : unit -> typ) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : unit -> int list) in
    Obj.repr(
# 155 "bin/Parser.mly"
                                                  ( fun _ -> let base_type = _1 () in
                                                             let dimensions = 100 :: _4 () in
                                                             match dimensions with
                                                             | [] -> base_type
                                                             | _ -> TYPE_array (base_type, dimensions)
                                                  )
# 541 "bin/Parser.ml"
               : unit -> typ))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : unit -> typ) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit -> int list) in
    Obj.repr(
# 161 "bin/Parser.mly"
                                                  ( fun _ -> let base_type = _1 () in
                                                             let dimensions = _2 () in
                                                             match dimensions with
                                                             | [] -> base_type
                                                             | _ -> TYPE_array (base_type, dimensions)
                                                  )
# 554 "bin/Parser.ml"
               : unit -> typ))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : unit -> typ) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit -> int list) in
    Obj.repr(
# 168 "bin/Parser.mly"
                                 ( fun _ -> let base_type = _1 () in
                                            let dimensions = _2 () in
                                            match dimensions with
                                            | [] -> base_type
                                            | _  -> TYPE_array (base_type, dimensions)
                                  )
# 567 "bin/Parser.ml"
               : unit -> typ))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit -> unit) in
    Obj.repr(
# 175 "bin/Parser.mly"
                     ( FuncDef _1 )
# 574 "bin/Parser.ml"
               : local_def))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit -> unit) in
    Obj.repr(
# 176 "bin/Parser.mly"
                     ( FuncDecl _1 )
# 581 "bin/Parser.ml"
               : local_def))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit -> unit) in
    Obj.repr(
# 177 "bin/Parser.mly"
                     ( VarDef _1 )
# 588 "bin/Parser.ml"
               : local_def))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : unit -> string * param list * typ) in
    Obj.repr(
# 179 "bin/Parser.mly"
                              ( fun _ -> let (func_name, params, return_type) = _1 () in
                                         genFuncDecl func_name params return_type;
                                         closeScope();
                              )
# 598 "bin/Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : unit -> string list) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : unit -> typ) in
    Obj.repr(
# 184 "bin/Parser.mly"
                                                            ( fun _ -> let vars = _2 () in
                                                                       let var_type = _4 () in
                                                                       List.iter ( fun var ->
                                                                         let ptr = genVarDef var var_type in
                                                                         ignore(newVariable (id_make var) var_type ptr true);
                                                                       ) vars
                                                                 )
# 612 "bin/Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    Obj.repr(
# 192 "bin/Parser.mly"
                                        ( fun _ -> () )
# 618 "bin/Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : unit -> (lvalue * expr_type list)) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : unit -> expr_type) in
    Obj.repr(
# 193 "bin/Parser.mly"
                                        ( fun _ -> let (lval, indices) = _1 () in
                                                   let value_expr = _3 () in
                                                   let idx = List.map (fun e -> match e with
                                                     | Expr exp -> exp
                                                     | Str _ -> error "string cannot be an index"; raise Terminate
                                                   ) indices in
                                                   match lval with
                                                   | Var var_name -> genVarWrite var_name idx value_expr
                                                   | StrLit _ -> failwith "String literals cannot be assigned to"
                                        )
# 635 "bin/Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit -> (unit -> unit) list) in
    Obj.repr(
# 203 "bin/Parser.mly"
                                        ( fun _ -> let l = _1 () in
                                                   List.iter (fun s -> s ()) l
                                        )
# 644 "bin/Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : unit -> string * expr_type list) in
    Obj.repr(
# 206 "bin/Parser.mly"
                                        ( fun _ -> let (func_name, args) = _1 () in
                                                   ignore(genFuncCall func_name args)
                                        )
# 653 "bin/Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : unit -> llvalue) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : unit -> unit) in
    Obj.repr(
# 209 "bin/Parser.mly"
                                        ( fun _ -> let cond_val = _2 () in
                                                   let start_bb = insertion_block builder in
                                                   let the_function = block_parent start_bb in
                                                   let then_bb = append_block context "then" the_function in
                                                   let merge_bb = append_block context "ifcont" the_function in
                                                   position_at_end then_bb builder;
                                                   _4 ();
                                                   begin match block_terminator (insertion_block builder) with
                                                   | None   -> ignore(build_br merge_bb builder)
                                                   | Some _ -> ()
                                                   end;
                                                   position_at_end start_bb builder;
                                                   ignore(build_cond_br cond_val then_bb merge_bb builder);
                                                   position_at_end merge_bb builder
                                        )
# 675 "bin/Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : unit -> llvalue) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : unit -> unit) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : unit -> unit) in
    Obj.repr(
# 224 "bin/Parser.mly"
                                        ( fun _ -> let cond_val = _2 () in
                                                   let start_bb = insertion_block builder in
                                                   let the_function = block_parent start_bb in
                                                   let then_bb = append_block context "then" the_function in
                                                   let merge_bb = append_block context "ifcont" the_function in
                                                   position_at_end then_bb builder;
                                                   _4 ();
                                                   begin match block_terminator (insertion_block builder) with
                                                   | None   -> ignore(build_br merge_bb builder)
                                                   | Some _ -> ()
                                                   end;
                                                   let else_bb = append_block context "else" the_function in
                                                   position_at_end else_bb builder;
                                                   _6 ();
                                                   begin match block_terminator (insertion_block builder) with
                                                   | None   -> ignore(build_br merge_bb builder)
                                                   | Some _ -> ()
                                                   end;
                                                   position_at_end start_bb builder;
                                                   ignore(build_cond_br cond_val then_bb else_bb builder);
                                                   position_at_end merge_bb builder
                                        )
# 705 "bin/Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : unit -> llvalue) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : unit -> unit) in
    Obj.repr(
# 246 "bin/Parser.mly"
                                        ( fun _ -> let start_bb = insertion_block builder in
                                                   let the_function = block_parent start_bb in
                                                   let cond_bb = append_block context "loopcond" the_function in
                                                   let loop_bb = append_block context "loopbody" the_function in
                                                   let merge_bb = append_block context "loop_cont" the_function in
                                                   ignore(build_br cond_bb builder);
                                                   position_at_end cond_bb builder;
                                                   let cond_val = _2 () in
                                                   ignore(build_cond_br cond_val loop_bb merge_bb builder);
                                                   position_at_end loop_bb builder;
                                                   _4 ();
                                                   begin match block_terminator (insertion_block builder) with
                                                   | None -> ignore(build_br cond_bb builder)
                                                   | Some _ -> ()
                                                   end;
                                                   position_at_end merge_bb builder
                                        )
# 729 "bin/Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    Obj.repr(
# 263 "bin/Parser.mly"
                                        ( fun _ -> ignore(build_ret_void builder) )
# 735 "bin/Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : unit -> expr_type) in
    Obj.repr(
# 264 "bin/Parser.mly"
                                        ( fun _ -> let expr_val = match _2 () with
                                                     | Expr e -> e
                                                     | Str str -> build_global_stringptr (str ^ "\000") "mystr" builder in
                                                   ignore(build_ret expr_val builder)
                                        )
# 746 "bin/Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : unit -> (unit -> unit) list) in
    Obj.repr(
# 271 "bin/Parser.mly"
                                   ( _2 )
# 753 "bin/Parser.ml"
               : unit -> (unit -> unit) list))
; (fun __caml_parser_env ->
    Obj.repr(
# 273 "bin/Parser.mly"
                          ( fun _ -> [] )
# 759 "bin/Parser.ml"
               : unit -> (unit -> unit) list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : unit -> unit) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit -> (unit -> unit) list) in
    Obj.repr(
# 274 "bin/Parser.mly"
                          ( fun _ -> _1 :: _2 () )
# 767 "bin/Parser.ml"
               : unit -> (unit -> unit) list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    Obj.repr(
# 276 "bin/Parser.mly"
                                                  ( fun _ -> let func_name = _1 in
                                                             (func_name, [])
                                                  )
# 776 "bin/Parser.ml"
               : unit -> string * expr_type list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : unit -> expr_type list) in
    Obj.repr(
# 279 "bin/Parser.mly"
                                                  ( fun _ -> let func_name = _1 in
                                                             let args = _3 () in
                                                             (func_name, args)
                                                  )
# 787 "bin/Parser.ml"
               : unit -> string * expr_type list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit -> expr_type) in
    Obj.repr(
# 285 "bin/Parser.mly"
                                              ( fun _ -> [_1 ()] )
# 794 "bin/Parser.ml"
               : unit -> expr_type list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> expr_type) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> expr_type list) in
    Obj.repr(
# 286 "bin/Parser.mly"
                                              ( fun _ -> _1 () :: _3 () )
# 802 "bin/Parser.ml"
               : unit -> expr_type list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 288 "bin/Parser.mly"
                                        ( fun _ -> (Var _1, []) )
# 809 "bin/Parser.ml"
               : unit -> (lvalue * expr_type list)))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 289 "bin/Parser.mly"
                                        ( fun _ -> (StrLit _1, []) )
# 816 "bin/Parser.ml"
               : unit -> (lvalue * expr_type list)))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : unit -> (lvalue * expr_type list)) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : unit -> expr_type) in
    Obj.repr(
# 290 "bin/Parser.mly"
                                        ( fun _ -> let (id, l) = _1 () in
                                                   let e = l @ [_3 ()] in
                                                   (id, e)
                                        )
# 827 "bin/Parser.ml"
               : unit -> (lvalue * expr_type list)))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 296 "bin/Parser.mly"
                             ( fun _ -> Expr (const_int int_type _1) )
# 834 "bin/Parser.ml"
               : unit -> expr_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : char) in
    Obj.repr(
# 297 "bin/Parser.mly"
                             ( fun _ -> Expr (const_int char_type (Char.code _1)) )
# 841 "bin/Parser.ml"
               : unit -> expr_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit -> (lvalue * expr_type list)) in
    Obj.repr(
# 298 "bin/Parser.mly"
                             ( fun _ -> let (lval, indices) = _1 () in
                                        let idx = List.map (fun e -> match e with
                                          | Expr exp -> exp
                                          | Str _ -> error "string cannot be an index"; raise Terminate
                                        ) indices in
                                        match lval with
                                        | Var var_name -> Expr (genVarRead var_name idx)
                                        | StrLit str -> if indices = [] then Str str else
                                                         (error "string literals cannot be indexed"; raise Terminate)
                             )
# 857 "bin/Parser.ml"
               : unit -> expr_type))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : unit -> expr_type) in
    Obj.repr(
# 308 "bin/Parser.mly"
                             ( _2 )
# 864 "bin/Parser.ml"
               : unit -> expr_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit -> string * expr_type list) in
    Obj.repr(
# 309 "bin/Parser.mly"
                             ( fun _ -> let (func_name, args) = _1 () in
                                        Expr (genFuncCall func_name args)
                             )
# 873 "bin/Parser.ml"
               : unit -> expr_type))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit -> expr_type) in
    Obj.repr(
# 312 "bin/Parser.mly"
                             ( fun _ -> _2 () )
# 880 "bin/Parser.ml"
               : unit -> expr_type))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit -> expr_type) in
    Obj.repr(
# 313 "bin/Parser.mly"
                             ( fun _ -> let e = match _2 () with
                                        | Expr exp -> exp
                                        | Str _ -> error "Cannot aquire negative of string"; raise Terminate in
                                        Expr (build_neg e "negtmp" builder)
                             )
# 891 "bin/Parser.ml"
               : unit -> expr_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> expr_type) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> expr_type) in
    Obj.repr(
# 318 "bin/Parser.mly"
                             ( fun _ -> let (lhs, rhs) = match (_1 (), _3 ()) with
                                        | (Expr exp1, Expr exp3) -> (exp1, exp3)
                                        | (_, _) -> error "Cannot add to string"; raise Terminate in
                                        Expr (build_add lhs rhs "addtmp" builder)
                             )
# 903 "bin/Parser.ml"
               : unit -> expr_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> expr_type) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> expr_type) in
    Obj.repr(
# 323 "bin/Parser.mly"
                             ( fun _ -> let (lhs, rhs) = match (_1 (), _3 ()) with
                                        | (Expr exp1, Expr exp3) -> (exp1, exp3)
                                        | (_, _) -> error "Cannot subtrackt to/from string"; raise Terminate in
                                        Expr (build_sub lhs rhs "subtmp" builder)
                             )
# 915 "bin/Parser.ml"
               : unit -> expr_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> expr_type) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> expr_type) in
    Obj.repr(
# 328 "bin/Parser.mly"
                             ( fun _ -> let (lhs, rhs) = match (_1 (), _3 ()) with
                                        | (Expr exp1, Expr exp3) -> (exp1, exp3)
                                        | (_, _) -> error "Cannot multiply with string"; raise Terminate in
                                        Expr (build_mul lhs rhs "multmp" builder)
                             )
# 927 "bin/Parser.ml"
               : unit -> expr_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> expr_type) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> expr_type) in
    Obj.repr(
# 333 "bin/Parser.mly"
                             ( fun _ -> let (lhs, rhs) = match (_1 (), _3 ()) with
                                        | (Expr exp1, Expr exp3) -> (exp1, exp3)
                                        | (_, _) -> error "Cannot divide string"; raise Terminate in
                                        Expr (build_sdiv lhs rhs "divtmp" builder)
                             )
# 939 "bin/Parser.ml"
               : unit -> expr_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> expr_type) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> expr_type) in
    Obj.repr(
# 338 "bin/Parser.mly"
                             ( fun _ -> let (lhs, rhs) = match (_1 (), _3 ()) with
                                        | (Expr exp1, Expr exp3) -> (exp1, exp3)
                                        | (_, _) -> error "Cannot divide string"; raise Terminate in
                                        Expr (build_srem lhs rhs "modtmp" builder)
                             )
# 951 "bin/Parser.ml"
               : unit -> expr_type))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : unit -> llvalue) in
    Obj.repr(
# 344 "bin/Parser.mly"
                             ( _2 )
# 958 "bin/Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit -> llvalue) in
    Obj.repr(
# 345 "bin/Parser.mly"
                             ( fun _ -> let cond_val = _2 () in
                                        let false_val = const_int (i1_type context) 0 in
                                        build_icmp Icmp.Ne cond_val false_val "nottmp" builder
                             )
# 968 "bin/Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> llvalue) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> llvalue) in
    Obj.repr(
# 349 "bin/Parser.mly"
                             ( fun _ -> let cond1 = _1 () in
                                        let start_bb = insertion_block builder in
                                        let the_function = block_parent start_bb in
                                        let eval_sec_bb = append_block context "second-cond" the_function in
                                        let merge_bb = append_block context "merge" the_function in
                                        ignore(build_cond_br cond1 eval_sec_bb merge_bb builder);
                                        position_at_end eval_sec_bb builder;
                                        let cond2 = _3 () in
                                        let new_eval_bb = insertion_block builder in
                                        ignore(build_br merge_bb builder);
                                        position_at_end merge_bb builder;
                                        let op = const_int bool_type 1
                                        in build_phi [(op, start_bb);(cond2, new_eval_bb)] "and_phi" builder
                             )
# 989 "bin/Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> llvalue) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> llvalue) in
    Obj.repr(
# 363 "bin/Parser.mly"
                             ( fun _ -> let cond1 = _1 () in
                                        let start_bb = insertion_block builder in
                                        let the_function = block_parent start_bb in
                                        let eval_sec_bb = append_block context "second-cond" the_function in
                                        let merge_bb = append_block context "merge" the_function in
                                        ignore(build_cond_br cond1 merge_bb eval_sec_bb builder);
                                        position_at_end eval_sec_bb builder;
                                        let cond2 = _3 () in
                                        let new_eval_bb = insertion_block builder in
                                        ignore(build_br merge_bb builder);
                                        position_at_end merge_bb builder;
                                        let op = const_int bool_type 0
                                        in build_phi [(op, start_bb);(cond2, new_eval_bb)] "or_phi" builder
                             )
# 1010 "bin/Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> expr_type) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> expr_type) in
    Obj.repr(
# 377 "bin/Parser.mly"
                             ( fun _ -> let (lhs, rhs) = match (_1 (), _3 ()) with
                                        | (Expr exp1, Expr exp3) -> (exp1, exp3)
                                        | (_, _) -> error "Cannot compare with string"; raise Terminate in
                                        build_icmp Icmp.Eq lhs rhs "eqtmp" builder
                             )
# 1022 "bin/Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> expr_type) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> expr_type) in
    Obj.repr(
# 382 "bin/Parser.mly"
                             ( fun _ -> let (lhs, rhs) = match (_1 (), _3 ()) with
                                        | (Expr exp1, Expr exp3) -> (exp1, exp3)
                                        | (_, _) -> error "Cannot compare with string"; raise Terminate in
                                        build_icmp Icmp.Ne lhs rhs "eqtmp" builder
                             )
# 1034 "bin/Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> expr_type) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> expr_type) in
    Obj.repr(
# 387 "bin/Parser.mly"
                             ( fun _ -> let (lhs, rhs) = match (_1 (), _3 ()) with
                                        | (Expr exp1, Expr exp3) -> (exp1, exp3)
                                        | (_, _) -> error "Cannot compare with string"; raise Terminate in
                                        build_icmp Icmp.Slt lhs rhs "lesstmp" builder
                             )
# 1046 "bin/Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> expr_type) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> expr_type) in
    Obj.repr(
# 392 "bin/Parser.mly"
                             ( fun _ -> let (lhs, rhs) = match (_1 (), _3 ()) with
                                        | (Expr exp1, Expr exp3) -> (exp1, exp3)
                                        | (_, _) -> error "Cannot compare with string"; raise Terminate in
                                        build_icmp Icmp.Sgt lhs rhs "greatertmp" builder
                             )
# 1058 "bin/Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> expr_type) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> expr_type) in
    Obj.repr(
# 397 "bin/Parser.mly"
                             ( fun _ -> let (lhs, rhs) = match (_1 (), _3 ()) with
                                        | (Expr exp1, Expr exp3) -> (exp1, exp3)
                                        | (_, _) -> error "Cannot compare with string"; raise Terminate in
                                        build_icmp Icmp.Sle lhs rhs "leqtmp" builder
                             )
# 1070 "bin/Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> expr_type) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> expr_type) in
    Obj.repr(
# 402 "bin/Parser.mly"
                             ( fun _ -> let (lhs, rhs) = match (_1 (), _3 ()) with
                                        | (Expr exp1, Expr exp3) -> (exp1, exp3)
                                        | (_, _) -> error "Cannot compare with string"; raise Terminate in
                                        build_icmp Icmp.Sge lhs rhs "geqtmp" builder
                             )
# 1082 "bin/Parser.ml"
               : unit -> llvalue))
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
   (Parsing.yyparse yytables 1 lexfun lexbuf : unit -> unit)
