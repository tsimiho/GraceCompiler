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
    let _1 = (Parsing.peek_val __caml_parser_env 1 : unit -> local_def_type) in
    Obj.repr(
# 102 "bin/Parser.mly"
                        ( fun _ -> initSymbolTable 1000;
                                   codegen _1 false
                        )
# 380 "bin/Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> string * param list * typ) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : unit -> local_def_type list) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> (unit -> unit) list) in
    Obj.repr(
# 106 "bin/Parser.mly"
                                      ( fun _ -> let (func_name, params, return_type) = _1 () in
                                                 let local_defs = _2 () in
                                                 let body = _3 () in
                                                 FuncDef (func_name, params, return_type, local_defs, body)
                                      )
# 393 "bin/Parser.ml"
               : unit -> local_def_type))
; (fun __caml_parser_env ->
    Obj.repr(
# 112 "bin/Parser.mly"
                                         ( fun _ -> [] )
# 399 "bin/Parser.ml"
               : unit -> local_def_type list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : unit -> local_def_type) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit -> local_def_type list) in
    Obj.repr(
# 113 "bin/Parser.mly"
                                         ( fun _ -> _1 () :: _2 () )
# 407 "bin/Parser.ml"
               : unit -> local_def_type list))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 5 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 3 : unit -> param list) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : unit -> typ) in
    Obj.repr(
# 115 "bin/Parser.mly"
                                                                    ( fun _ -> let id = _2 in
                                                                               let params = _4 () in
                                                                               let return_type = _7 () in
                                                                               (id, params, return_type)
                                                                    )
# 420 "bin/Parser.ml"
               : unit -> string * param list * typ))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : unit -> typ) in
    Obj.repr(
# 120 "bin/Parser.mly"
                                                                    ( fun _ -> let id = _2 in
                                                                               let params = [] in
                                                                               let return_type = _6 () in
                                                                               (id, params, return_type)
                                                                    )
# 432 "bin/Parser.ml"
               : unit -> string * param list * typ))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit -> param) in
    Obj.repr(
# 126 "bin/Parser.mly"
                                                  ( fun _ -> [_1 ()] )
# 439 "bin/Parser.ml"
               : unit -> param list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> param) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> param list) in
    Obj.repr(
# 127 "bin/Parser.mly"
                                                  ( fun _ -> _1 () :: _3 () )
# 447 "bin/Parser.ml"
               : unit -> param list))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : unit -> string list) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : unit -> typ) in
    Obj.repr(
# 129 "bin/Parser.mly"
                                                ( fun _ -> let params = _2 () in
                                                           let param_type = _4 () in
                                                           let mode = PASS_BY_REFERENCE in
                                                           { id = params; mode = mode; param_type = param_type }
                                                )
# 459 "bin/Parser.ml"
               : unit -> param))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> string list) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> typ) in
    Obj.repr(
# 134 "bin/Parser.mly"
                                                ( fun _ -> let params = _1 () in
                                                           let param_type = _3 () in
                                                           let mode = PASS_BY_VALUE in
                                                           { id = params; mode = mode; param_type = param_type }
                                                )
# 471 "bin/Parser.ml"
               : unit -> param))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 140 "bin/Parser.mly"
                                          ( fun _ -> [_1] )
# 478 "bin/Parser.ml"
               : unit -> string list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> string list) in
    Obj.repr(
# 141 "bin/Parser.mly"
                                          ( fun _ -> _1 :: _3 () )
# 486 "bin/Parser.ml"
               : unit -> string list))
; (fun __caml_parser_env ->
    Obj.repr(
# 143 "bin/Parser.mly"
                  ( fun _ -> TYPE_int )
# 492 "bin/Parser.ml"
               : unit -> typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 144 "bin/Parser.mly"
                  ( fun _ -> TYPE_char )
# 498 "bin/Parser.ml"
               : unit -> typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 146 "bin/Parser.mly"
                                                     ( fun _ -> [] )
# 504 "bin/Parser.ml"
               : unit -> int list))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : int) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : unit -> int list) in
    Obj.repr(
# 147 "bin/Parser.mly"
                                                     ( fun _ -> _2 :: _4 () )
# 512 "bin/Parser.ml"
               : unit -> int list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit -> typ) in
    Obj.repr(
# 149 "bin/Parser.mly"
                    ( fun _ -> _1 () )
# 519 "bin/Parser.ml"
               : unit -> typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 150 "bin/Parser.mly"
                    ( fun _ -> TYPE_proc )
# 525 "bin/Parser.ml"
               : unit -> typ))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : unit -> typ) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : unit -> int list) in
    Obj.repr(
# 152 "bin/Parser.mly"
                                                  ( fun _ -> let base_type = _1 () in
                                                             let dimensions = -1 :: _4 () in
                                                             match dimensions with
                                                             | [] -> base_type
                                                             | _ -> TYPE_array (base_type, dimensions)
                                                  )
# 538 "bin/Parser.ml"
               : unit -> typ))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : unit -> typ) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit -> int list) in
    Obj.repr(
# 158 "bin/Parser.mly"
                                                  ( fun _ -> let base_type = _1 () in
                                                             let dimensions = _2 () in
                                                             match dimensions with
                                                             | [] -> base_type
                                                             | _ -> TYPE_array (base_type, dimensions)
                                                  )
# 551 "bin/Parser.ml"
               : unit -> typ))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : unit -> typ) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit -> int list) in
    Obj.repr(
# 165 "bin/Parser.mly"
                                 ( fun _ -> let base_type = _1 () in
                                            let dimensions = _2 () in
                                            match dimensions with
                                            | [] -> base_type
                                            | _  -> TYPE_array (base_type, dimensions)
                                  )
# 564 "bin/Parser.ml"
               : unit -> typ))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit -> local_def_type) in
    Obj.repr(
# 172 "bin/Parser.mly"
                     ( _1 )
# 571 "bin/Parser.ml"
               : unit -> local_def_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit -> local_def_type) in
    Obj.repr(
# 173 "bin/Parser.mly"
                     ( _1 )
# 578 "bin/Parser.ml"
               : unit -> local_def_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit -> local_def_type) in
    Obj.repr(
# 174 "bin/Parser.mly"
                     ( _1 )
# 585 "bin/Parser.ml"
               : unit -> local_def_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : unit -> string * param list * typ) in
    Obj.repr(
# 176 "bin/Parser.mly"
                              ( fun _ -> let (func_name, params, return_type) = _1 () in
                                         FuncDecl (func_name, params, return_type)
                              )
# 594 "bin/Parser.ml"
               : unit -> local_def_type))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : unit -> string list) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : unit -> typ) in
    Obj.repr(
# 180 "bin/Parser.mly"
                                                            ( fun _ -> let vars = _2 () in
                                                                       let var_type = _4 () in
                                                                       VarDef (vars, var_type)
                                                            )
# 605 "bin/Parser.ml"
               : unit -> local_def_type))
; (fun __caml_parser_env ->
    Obj.repr(
# 185 "bin/Parser.mly"
                                        ( fun _ -> () )
# 611 "bin/Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : unit -> (lvalue * expr_type list)) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : unit -> expr_type) in
    Obj.repr(
# 186 "bin/Parser.mly"
                                        ( fun _ -> let (lval, indices) = _1 () in
                                                   let value_expr = _3 () in
                                                   let idx = List.map (fun e -> match e with
                                                     | Expr (exp, exp_type) -> exp
                                                     | LValue (v, vt, i)    -> let ll, _ = genVarRead v i "val" in ll
                                                     | Str _         -> error "String cannot be an index"; raise Terminate
                                                   ) indices in
                                                   match lval with
                                                   | Var var_name -> genVarWrite var_name idx value_expr
                                                   | StrLit _ -> error "String literals cannot be assigned to"; raise Terminate
                                        )
# 629 "bin/Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit -> (unit -> unit) list) in
    Obj.repr(
# 197 "bin/Parser.mly"
                                        ( fun _ -> let l = _1 () in
                                                   List.iter (fun s -> s ()) l
                                        )
# 638 "bin/Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : unit -> string * expr_type list) in
    Obj.repr(
# 200 "bin/Parser.mly"
                                        ( fun _ -> let (func_name, args) = _1 () in
                                                   ignore(genFuncCall func_name args)
                                        )
# 647 "bin/Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : unit -> llvalue) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : unit -> unit) in
    Obj.repr(
# 203 "bin/Parser.mly"
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
# 669 "bin/Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : unit -> llvalue) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : unit -> unit) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : unit -> unit) in
    Obj.repr(
# 218 "bin/Parser.mly"
                                        ( fun _ -> let cond_val = _2 () in
                                                   let start_bb = insertion_block builder in
                                                   let the_function = block_parent start_bb in
                                                   let then_bb = append_block context "then" the_function in
                                                   let merge_bb = append_block context "ifcont" the_function in
                                                   position_at_end then_bb builder;
                                                   _4 ();
                                                   let then_returns = check_return_flag () in
                                                   reset_return_flag ();
                                                   begin match block_terminator (insertion_block builder) with
                                                   | None   -> ignore(build_br merge_bb builder)
                                                   | Some _ -> ()
                                                   end;
                                                   let else_bb = append_block context "else" the_function in
                                                   position_at_end else_bb builder;
                                                   _6 ();
                                                   let else_returns = check_return_flag () in
                                                   reset_return_flag ();
                                                   if then_returns && else_returns then
                                                     set_return_flag ();
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
                                        ( fun _ -> let function_return_type = match !current_function with
                                                   | Some f -> (match f.entry_info with
                                                     | ENTRY_function info -> info.function_result
                                                     | _ -> error "Expected a function entry"; raise Terminate)
                                                   | None -> error "Return statement not within a function"; raise Terminate in
                                                   if function_return_type <> TYPE_proc then
                                                     error "Return type mismatch: expected %s but got void" (string_of_type function_return_type);
                                                   set_return_flag ();
                                                   ignore(build_ret_void builder)
                                        )
# 744 "bin/Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : unit -> expr_type) in
    Obj.repr(
# 273 "bin/Parser.mly"
                                        ( fun _ -> let expr_val, expr_type = match _2 () with
                                                   | Expr (exp, exp_type) -> (exp, exp_type)
                                                   | LValue (v, vt, i)    -> genVarRead v i "val"
                                                   | Str str              -> (error "Functions cannot return a string"; raise Terminate) in
                                                   let function_return_type = match !current_function with
                                                   | Some f -> (match f.entry_info with
                                                     | ENTRY_function info -> info.function_result
                                                     | _ -> error "Expected a function entry"; raise Terminate)
                                                   | None -> error "Return statement not within a function"; raise Terminate in
                                                   if expr_type <> function_return_type then
                                                     (error "Return type mismatch: expected %s but got %s"
                                                     (string_of_type function_return_type) (string_of_type expr_type);
                                                     raise Terminate)
                                                   else
                                                   set_return_flag ();
                                                   ignore(build_ret expr_val builder)
                                        )
# 767 "bin/Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : unit -> (unit -> unit) list) in
    Obj.repr(
# 292 "bin/Parser.mly"
                                   ( _2 )
# 774 "bin/Parser.ml"
               : unit -> (unit -> unit) list))
; (fun __caml_parser_env ->
    Obj.repr(
# 294 "bin/Parser.mly"
                          ( fun _ -> [] )
# 780 "bin/Parser.ml"
               : unit -> (unit -> unit) list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : unit -> unit) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit -> (unit -> unit) list) in
    Obj.repr(
# 295 "bin/Parser.mly"
                          ( fun _ -> _1 :: _2 () )
# 788 "bin/Parser.ml"
               : unit -> (unit -> unit) list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    Obj.repr(
# 297 "bin/Parser.mly"
                                                  ( fun _ -> let func_name = _1 in
                                                             (func_name, [])
                                                  )
# 797 "bin/Parser.ml"
               : unit -> string * expr_type list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : unit -> expr_type list) in
    Obj.repr(
# 300 "bin/Parser.mly"
                                                  ( fun _ -> let func_name = _1 in
                                                             let args = _3 () in
                                                             (func_name, args)
                                                  )
# 808 "bin/Parser.ml"
               : unit -> string * expr_type list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit -> expr_type) in
    Obj.repr(
# 306 "bin/Parser.mly"
                                              ( fun _ -> [_1 ()] )
# 815 "bin/Parser.ml"
               : unit -> expr_type list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> expr_type) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> expr_type list) in
    Obj.repr(
# 307 "bin/Parser.mly"
                                              ( fun _ -> _1 () :: _3 () )
# 823 "bin/Parser.ml"
               : unit -> expr_type list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 309 "bin/Parser.mly"
                                        ( fun _ -> (Var _1, []) )
# 830 "bin/Parser.ml"
               : unit -> (lvalue * expr_type list)))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 310 "bin/Parser.mly"
                                        ( fun _ -> (StrLit _1, []) )
# 837 "bin/Parser.ml"
               : unit -> (lvalue * expr_type list)))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : unit -> (lvalue * expr_type list)) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : unit -> expr_type) in
    Obj.repr(
# 311 "bin/Parser.mly"
                                        ( fun _ -> let (id, l) = _1 () in
                                                   let e = l @ [_3 ()] in
                                                   (id, e)
                                        )
# 848 "bin/Parser.ml"
               : unit -> (lvalue * expr_type list)))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 317 "bin/Parser.mly"
                             ( fun _ -> Expr ((const_int int_type _1), TYPE_int) )
# 855 "bin/Parser.ml"
               : unit -> expr_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : char) in
    Obj.repr(
# 318 "bin/Parser.mly"
                             ( fun _ -> Expr ((const_int char_type (Char.code _1)), TYPE_char) )
# 862 "bin/Parser.ml"
               : unit -> expr_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit -> (lvalue * expr_type list)) in
    Obj.repr(
# 319 "bin/Parser.mly"
                             ( fun _ -> let (lval, indices) = _1 () in
                                        let idx = List.map (fun e -> match e with
                                          | Expr (exp, exp_type)   -> exp
                                          | LValue (v, lv_type, i) -> let ll, _ = genVarRead v i "val" in ll
                                          | Str _                  -> error "string cannot be an index"; raise Terminate
                                        ) indices in
                                        match lval with
                                        | Var var_name -> (let var_entry = lookupEntry (id_make var_name) LOOKUP_ALL_SCOPES true in
                                                          let var_type = match var_entry.entry_info with
                                                          | ENTRY_variable info  -> info.variable_type
                                                          | ENTRY_parameter info -> info.parameter_type
                                                          | _ -> error "%s is not a variable" var_name; raise Terminate in
                                                          let t = match var_type with
                                                          | TYPE_array (t, _) -> t
                                                          | t                 -> t in
                                                          LValue (var_name, t, idx))
                                        | StrLit str -> if indices = [] then Str str else
                                                         (error "string literals cannot be indexed"; raise Terminate)
                             )
# 887 "bin/Parser.ml"
               : unit -> expr_type))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : unit -> expr_type) in
    Obj.repr(
# 338 "bin/Parser.mly"
                             ( _2 )
# 894 "bin/Parser.ml"
               : unit -> expr_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit -> string * expr_type list) in
    Obj.repr(
# 339 "bin/Parser.mly"
                             ( fun _ -> let (func_name, args) = _1 () in
                                        let t = if List.mem func_name libs then (lib_ret_type func_name)
                                        else begin
                                          let e = lookupEntry (id_make func_name) LOOKUP_ALL_SCOPES true in
                                          match e.entry_info with
                                          | ENTRY_function info -> info.function_result
                                          | _ -> (error "%s is not a function" func_name; raise Terminate) end in
                                        Expr ((genFuncCall func_name args), t)
                             )
# 909 "bin/Parser.ml"
               : unit -> expr_type))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit -> expr_type) in
    Obj.repr(
# 348 "bin/Parser.mly"
                             ( fun _ -> _2 () )
# 916 "bin/Parser.ml"
               : unit -> expr_type))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit -> expr_type) in
    Obj.repr(
# 349 "bin/Parser.mly"
                             ( fun _ -> let e, t = match _2 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | Str _                -> error "Cannot aquire negative of string"; raise Terminate in
                                        Expr ((build_neg e "negtmp" builder), t)
                             )
# 928 "bin/Parser.ml"
               : unit -> expr_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> expr_type) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> expr_type) in
    Obj.repr(
# 355 "bin/Parser.mly"
                             ( fun _ -> let lhs, lhs_type = match _1 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _                    -> error "Cannot add to string"; raise Terminate in
                                        let rhs, rhs_type = match _3 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot multiply with string"; raise Terminate in
                                        if semaBinOp lhs lhs_type rhs rhs_type "'+'" then
                                          Expr ((build_add lhs rhs "addtmp" builder), lhs_type)
                                        else raise Terminate
                             )
# 947 "bin/Parser.ml"
               : unit -> expr_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> expr_type) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> expr_type) in
    Obj.repr(
# 367 "bin/Parser.mly"
                             ( fun _ -> let lhs, lhs_type = match _1 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot subtract to/from string"; raise Terminate in
                                        let rhs, rhs_type = match _3 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot multiply with string"; raise Terminate in
                                        if semaBinOp lhs lhs_type rhs rhs_type "'-'" then
                                          Expr ((build_sub lhs rhs "subtmp" builder), lhs_type)
                                        else raise Terminate
                             )
# 966 "bin/Parser.ml"
               : unit -> expr_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> expr_type) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> expr_type) in
    Obj.repr(
# 379 "bin/Parser.mly"
                             ( fun _ -> let lhs, lhs_type = match _1 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot multiply with string"; raise Terminate in
                                        let rhs, rhs_type = match _3 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot multiply with string"; raise Terminate in
                                        if semaBinOp lhs lhs_type rhs rhs_type "'*'" then
                                          Expr ((build_mul lhs rhs "multmp" builder), lhs_type)
                                        else raise Terminate
                             )
# 985 "bin/Parser.ml"
               : unit -> expr_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> expr_type) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> expr_type) in
    Obj.repr(
# 391 "bin/Parser.mly"
                             ( fun _ -> let lhs, lhs_type = match _1 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot divide string"; raise Terminate in
                                        let rhs, rhs_type = match _3 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot multiply with string"; raise Terminate in
                                        if semaBinOp lhs lhs_type rhs rhs_type "'div'" then
                                          Expr ((build_sdiv lhs rhs "divtmp" builder), lhs_type)
                                        else raise Terminate
                             )
# 1004 "bin/Parser.ml"
               : unit -> expr_type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> expr_type) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> expr_type) in
    Obj.repr(
# 403 "bin/Parser.mly"
                             ( fun _ -> let lhs, lhs_type = match _1 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot divide string"; raise Terminate in
                                        let rhs, rhs_type = match _3 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot multiply with string"; raise Terminate in
                                        if semaBinOp lhs lhs_type rhs rhs_type "'mod'" then
                                          Expr ((build_srem lhs rhs "modtmp" builder), lhs_type)
                                        else raise Terminate
                             )
# 1023 "bin/Parser.ml"
               : unit -> expr_type))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : unit -> llvalue) in
    Obj.repr(
# 416 "bin/Parser.mly"
                             ( _2 )
# 1030 "bin/Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit -> llvalue) in
    Obj.repr(
# 417 "bin/Parser.mly"
                             ( fun _ -> let cond_val = _2 () in
                                        let false_val = const_int (i1_type context) 0 in
                                        build_icmp Icmp.Ne cond_val false_val "nottmp" builder
                             )
# 1040 "bin/Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> llvalue) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> llvalue) in
    Obj.repr(
# 421 "bin/Parser.mly"
                             ( fun _ -> let lhs = _1 () in
                                        let rhs = _3 () in
                                        if semaCond lhs && semaCond rhs then
                                          let start_bb = insertion_block builder in
                                          let the_function = block_parent start_bb in
                                          let eval_sec_bb = append_block context "second-cond" the_function in
                                          let merge_bb = append_block context "merge" the_function in
                                          ignore(build_cond_br lhs eval_sec_bb merge_bb builder);
                                          position_at_end eval_sec_bb builder;
                                          let new_eval_bb = insertion_block builder in
                                          ignore(build_br merge_bb builder);
                                          position_at_end merge_bb builder;
                                          build_phi [(lhs, start_bb); (rhs, new_eval_bb)] "and_phi" builder
                                        else raise Terminate
                             )
# 1062 "bin/Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> llvalue) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> llvalue) in
    Obj.repr(
# 436 "bin/Parser.mly"
                             ( fun _ -> let lhs = _1 () in
                                        let rhs = _3 () in
                                        if semaCond lhs && semaCond rhs then
                                          let start_bb = insertion_block builder in
                                          let the_function = block_parent start_bb in
                                          let eval_sec_bb = append_block context "second-cond" the_function in
                                          let merge_bb = append_block context "merge" the_function in
                                          ignore(build_cond_br lhs merge_bb eval_sec_bb builder);
                                          position_at_end eval_sec_bb builder;
                                          let new_eval_bb = insertion_block builder in
                                          ignore(build_br merge_bb builder);
                                          position_at_end merge_bb builder;
                                          build_phi [(lhs, start_bb); (rhs, new_eval_bb)] "or_phi" builder
                                        else raise Terminate
                             )
# 1084 "bin/Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> expr_type) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> expr_type) in
    Obj.repr(
# 451 "bin/Parser.mly"
                             ( fun _ -> let lhs, lhs_type = match _1 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot compare with string"; raise Terminate in
                                        let rhs, rhs_type = match _3 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot compare with string"; raise Terminate in
                                        if semaComp lhs rhs then
                                          build_icmp Icmp.Eq lhs rhs "eqtmp" builder
                                        else raise Terminate
                             )
# 1103 "bin/Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> expr_type) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> expr_type) in
    Obj.repr(
# 463 "bin/Parser.mly"
                             ( fun _ -> let lhs, lhs_type = match _1 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot compare with string"; raise Terminate  in
                                        let rhs, rhs_type = match _3 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot compare with string"; raise Terminate in
                                        if semaComp lhs rhs then
                                          build_icmp Icmp.Ne lhs rhs "eqtmp" builder
                                        else raise Terminate
                             )
# 1122 "bin/Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> expr_type) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> expr_type) in
    Obj.repr(
# 475 "bin/Parser.mly"
                             ( fun _ -> let lhs, lhs_type = match _1 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot compare with string"; raise Terminate  in
                                        let rhs, rhs_type = match _3 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot compare with string"; raise Terminate in
                                        if semaComp lhs rhs then
                                          build_icmp Icmp.Slt lhs rhs "lesstmp" builder
                                        else raise Terminate
                             )
# 1141 "bin/Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> expr_type) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> expr_type) in
    Obj.repr(
# 487 "bin/Parser.mly"
                             ( fun _ -> let lhs, lhs_type = match _1 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot compare with string"; raise Terminate  in
                                        let rhs, rhs_type = match _3 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot compare with string"; raise Terminate in
                                        if semaComp lhs rhs then
                                          build_icmp Icmp.Sgt lhs rhs "greatertmp" builder
                                        else raise Terminate
                             )
# 1160 "bin/Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> expr_type) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> expr_type) in
    Obj.repr(
# 499 "bin/Parser.mly"
                             ( fun _ -> let lhs, lhs_type = match _1 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot compare with string"; raise Terminate  in
                                        let rhs, rhs_type = match _3 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot compare with string"; raise Terminate in
                                        if semaComp lhs rhs then
                                          build_icmp Icmp.Sle lhs rhs "leqtmp" builder
                                        else raise Terminate
                             )
# 1179 "bin/Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> expr_type) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> expr_type) in
    Obj.repr(
# 511 "bin/Parser.mly"
                             ( fun _ -> let lhs, lhs_type = match _1 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot compare with string"; raise Terminate  in
                                        let rhs, rhs_type = match _3 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot compare with string"; raise Terminate in
                                        if semaComp lhs rhs then
                                          build_icmp Icmp.Sge lhs rhs "geqtmp" builder
                                        else raise Terminate
                             )
# 1198 "bin/Parser.ml"
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
