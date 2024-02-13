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
  | T_prod

open Parsing;;
let _ = parse_error;;
# 2 "Parser.mly"
  open Llvm
  open Llvm_analysis
  open Llvm_scalar_opts
  open Llvm_ipo
  open Llvm_vectorize
  open Llvm_target
  open Llvm.PassManager
  open Parsing
  open Symbol
  open Types
  open Identifier
  open Error
  open Narray
  open Codegen

  initSymbolTable 1000;

  type param = {
    id: Identifier.id list;
    mode: pass_mode;
    param_type: typ
  }

  (* and param_mode = PASS_BY_VALUE | PASS_BY_REFERENCE *)

  (* let callFunction id args = *)
  (*   let func_entry = lookupEntry id LOOKUP_ALL_SCOPES true in *)
  (*   match func_entry.entry_info with *)
  (*   | ENTRY_function inf -> if inf.function_isForward then *)
  (*                             let rec linkParams func_params func_args = *)
  (*                               match func_params, func_args with *)
  (*                               | fp::fps, fa::fas -> () *)
  (*                               | [], [] -> inf.function_body () *)
  (*                               | _, _ -> error "Function %a is called with the worng number of parameters" pretty_id id; None *)
  (*                           else error "%a has not been implemented" pretty_id id; None *)
  (*   | _ -> error "%a is not a function" pretty_id id; None; *)


  let print_variable_value value =
    match value with
    | IntValue i -> Printf.printf "IntValue: %d\n" i
    | CharValue c -> Printf.printf "CharValue: '%c'\n" c
    | BoolValue b -> Printf.printf "BoolValue: %b\n" b
    | MultiArray arr -> Printf.printf "MultiArray"
    | Unit -> Printf.printf "Unit\n"

  let print_grace_type t =
    match t with
    | TYPE_int | TYPE_char -> Printf.printf "Not an array\n"
    | _  -> Printf.printf "array\n"

  let addLib () =
    let addFunc name args rtype =
        let func = newFunction (id_make name) true in
        openScope ();
        let addArg (arg_name, arg_type, is_ref)  =
            let mode = match is_ref with
            | true -> PASS_BY_REFERENCE
            | false -> PASS_BY_VALUE
            in ignore (newParameter (id_make arg_name) arg_type mode func true)
        in
        List.iter addArg args;
        endFunctionHeader func rtype;
        closeScope ()
    in
    addFunc "writeInteger" [("n", TYPE_int, false)] TYPE_proc;
    addFunc "writeChar" [("b", TYPE_char, false)] TYPE_proc;
    addFunc "writeString" [("n", TYPE_array (TYPE_char, [0]), true)] TYPE_proc;
    addFunc "readInteger" [] TYPE_int;
    addFunc "readChar" [] TYPE_char;
    addFunc "readString" [("n", TYPE_int, false); ("s", TYPE_array (TYPE_char, [0]), true)] TYPE_proc



  let semaFunc fname params ret_type =
    let f = newFunction (id_make fname ) true in
    openScope ();
    let set_param par =
        match par.param_type, par.mode with
        | TYPE_array _, PASS_BY_VALUE -> begin
            error "%aIn function %s: array type cannot be passed by value"
                print_position (position_point (symbol_start_pos())) fname;
                List.iter (fun id -> ignore(newParameter id par.param_type PASS_BY_REFERENCE f true)) par.id;
        end
        | _ -> List.iter (fun id -> ignore(newParameter id par.param_type PASS_BY_REFERENCE f true)) par.id;
    in
    List.iter set_param params;
    endFunctionHeader f ret_type

    (* Stack.push ret_type rstack; *)
    (* let full_name = match f.entry_info with *)
    (* | ENTRY_function f -> f.function_name *)
    (* | _ -> internal "Unreachable: entry_info of function not a function"; raise Terminate *)
    (* in (fname, full_name, params, ret_type) *)

  (* let sema_fcall fname args = *)
  (*   let func = lookupEntry (id_make fname) LOOKUP_ALL_SCOPES true in *)
  (*   let nd =  (!currentScope.sco_nesting -1) - func.entry_scope.sco_nesting in *)
  (*   match func.entry_info with *)
  (*   | ENTRY_function f -> *)
  (*       let full_name = f.function_name in *)
  (*       let rec valid_args expr_list entry_list bool_list = begin *)
  (*           match expr_list, entry_list with *)
  (*           | expr::t1, entry::t2 -> *)
  (*               let entry_type, is_byref = *)
  (*               begin match entry.entry_info with *)
  (*               | ENTRY_parameter param -> *)
  (*                       if (param.parameter_mode = PASS_BY_REFERENCE) then *)
  (*                           begin match expr.kind with *)
  (*                           | Lval _ -> () *)
  (*                           | _ ->  error "%aIn function call %s: only an l-value can be passed by ref" *)
  (*                           print_position (position_point (symbol_start_pos())) fname *)
  (*                           end; *)
  (*                       param.parameter_type, (param.parameter_mode = PASS_BY_REFERENCE ) *)
  (*               | _ -> internal "Unreachable :entrty of parameter_list not a paramter"; TYPE_none, false *)
  (*               end in *)
  (*               if not (equalType expr.etype entry_type) *)
  (*               then begin *)
  (*                   error "%aIn function call %s, expected parameter of type %s, got %s" *)
  (*                   print_position (position_point (symbol_start_pos())) *)
  (*                   fname (string_of_type entry_type) (string_of_type expr.etype); *)
  (*               end; *)
  (*               valid_args t1 t2 (is_byref::bool_list) *)
  (*           | [], [] -> *)
  (*             newFuncCallRec (fname, full_name, List.combine args (List.rev bool_list), nd, f.function_result) *)
  (*           | _, _ -> *)
  (*               error "%aIn function call %s, wrong number of parameters" *)
  (*               print_position (position_point (symbol_start_pos())) fname; *)
  (*               newFuncCallRec (fname, full_name, List.combine args *)
  (*               (List.rev bool_list), *)
  (*                               nd, f.function_result) *)
  (*       end in *)
  (*       valid_args args f.function_paramlist [] *)
  (*   | _ -> fatal "%aIdentifier %s is not a function" *)
  (*          print_position (position_point (symbol_start_pos())) fname; *)
  (*          raise Terminate *)
  (**)


# 187 "Parser.ml"
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
  297 (* T_prod *);
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
\000\000\000\000\002\000\025\000\004\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\044\000\
\027\000\000\000\029\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\046\000\047\000\
\000\000\000\000\000\000\050\000\000\000\000\000\000\000\000\000\
\034\000\000\000\000\000\000\000\038\000\036\000\030\000\000\000\
\000\000\000\000\000\000\014\000\013\000\018\000\017\000\006\000\
\000\000\000\000\012\000\000\000\000\000\059\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\035\000\000\000\039\000\000\000\000\000\000\000\000\000\
\000\000\010\000\008\000\000\000\000\000\021\000\026\000\049\000\
\058\000\056\000\057\000\000\000\000\000\000\000\055\000\000\000\
\000\000\000\000\000\000\000\000\060\000\000\000\000\000\033\000\
\000\000\000\000\045\000\028\000\009\000\000\000\020\000\005\000\
\000\000\000\000\000\000\040\000\000\000\000\000\032\000\042\000\
\019\000\016\000"

let yydgoto = "\002\000\
\004\000\010\000\011\000\012\000\043\000\025\000\027\000\071\000\
\110\000\072\000\106\000\077\000\013\000\014\000\015\000\034\000\
\035\000\036\000\052\000\130\000\053\000\054\000\055\000"

let yysindex = "\009\000\
\027\255\000\000\030\255\000\000\054\255\132\255\051\255\000\000\
\061\255\000\000\065\255\254\254\132\255\000\000\000\000\116\255\
\070\255\068\255\000\000\000\000\000\000\088\255\070\255\071\255\
\074\255\114\255\100\255\129\000\117\000\129\000\118\255\000\000\
\000\000\068\255\000\000\111\255\109\255\103\255\070\255\113\255\
\009\255\000\255\122\255\070\255\045\255\129\000\000\000\000\000\
\129\000\147\000\147\000\000\000\129\255\032\000\034\255\147\000\
\000\000\016\255\171\255\138\000\000\000\000\000\000\000\147\000\
\147\000\130\255\045\255\000\000\000\000\000\000\000\000\000\000\
\074\255\133\255\000\000\134\255\137\255\000\000\005\000\123\255\
\003\255\003\255\147\000\147\000\147\000\147\000\147\000\147\000\
\147\000\147\000\147\000\147\000\147\000\129\000\129\000\068\255\
\081\000\000\000\068\255\000\000\037\000\073\000\067\255\045\255\
\139\255\000\000\000\000\009\255\157\255\000\000\000\000\000\000\
\000\000\000\000\000\000\042\255\003\255\003\255\000\000\042\255\
\042\255\042\255\042\255\042\255\000\000\173\255\172\255\000\000\
\147\000\169\255\000\000\000\000\000\000\019\255\000\000\000\000\
\148\255\068\255\037\000\000\000\134\255\134\255\000\000\000\000\
\000\000\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\166\255\000\000\000\000\
\000\000\000\000\000\000\166\255\166\255\000\000\000\000\000\000\
\164\255\170\255\000\000\000\000\000\000\000\000\164\255\000\000\
\178\255\000\000\000\000\000\000\000\000\000\000\087\255\000\000\
\000\000\170\255\000\000\000\000\000\000\000\000\164\255\000\000\
\000\000\000\000\000\000\164\255\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\127\255\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\178\255\000\000\000\000\168\255\000\000\000\000\000\000\000\000\
\156\255\185\255\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\181\255\000\000\000\000\000\000\
\047\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\083\255\214\255\243\255\000\000\041\000\
\079\000\108\000\109\000\110\000\000\000\184\255\060\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\181\255\000\000\047\255\047\255\000\000\000\000\
\000\000\000\000"

let yygindex = "\000\000\
\000\000\206\000\200\000\217\000\150\000\184\000\244\255\219\255\
\155\255\120\000\125\000\000\000\000\000\000\000\000\000\163\255\
\220\000\198\000\238\255\094\000\239\255\229\255\235\255"

let yytablesize = 430
let yytable = "\037\000\
\038\000\058\000\127\000\135\000\003\000\128\000\083\000\076\000\
\059\000\001\000\040\000\068\000\084\000\022\000\009\000\037\000\
\038\000\069\000\023\000\083\000\070\000\079\000\081\000\082\000\
\078\000\084\000\066\000\080\000\097\000\105\000\088\000\075\000\
\101\000\003\000\020\000\094\000\102\000\103\000\137\000\145\000\
\146\000\086\000\087\000\088\000\143\000\083\000\095\000\068\000\
\007\000\096\000\141\000\084\000\098\000\069\000\008\000\114\000\
\115\000\116\000\117\000\118\000\119\000\120\000\121\000\122\000\
\123\000\124\000\105\000\086\000\087\000\088\000\083\000\015\000\
\125\000\126\000\016\000\028\000\084\000\037\000\038\000\017\000\
\037\000\038\000\029\000\015\000\062\000\030\000\031\000\062\000\
\043\000\032\000\043\000\043\000\086\000\087\000\088\000\062\000\
\043\000\018\000\062\000\043\000\018\000\139\000\043\000\132\000\
\033\000\026\000\039\000\062\000\041\000\043\000\042\000\043\000\
\043\000\043\000\043\000\043\000\043\000\043\000\043\000\037\000\
\038\000\043\000\043\000\043\000\094\000\043\000\043\000\043\000\
\048\000\022\000\048\000\048\000\044\000\064\000\023\000\095\000\
\048\000\045\000\003\000\048\000\024\000\060\000\048\000\065\000\
\062\000\063\000\074\000\113\000\009\000\048\000\067\000\048\000\
\048\000\048\000\048\000\048\000\048\000\051\000\048\000\064\000\
\051\000\048\000\048\000\048\000\109\000\048\000\048\000\104\000\
\051\000\134\000\108\000\051\000\094\000\111\000\094\000\099\000\
\137\000\138\000\051\000\142\000\051\000\051\000\051\000\095\000\
\051\000\051\000\052\000\051\000\061\000\052\000\051\000\051\000\
\051\000\140\000\051\000\051\000\061\000\052\000\003\000\061\000\
\052\000\011\000\007\000\037\000\015\000\041\000\005\000\052\000\
\061\000\052\000\052\000\052\000\021\000\052\000\052\000\053\000\
\052\000\006\000\053\000\052\000\052\000\052\000\107\000\052\000\
\052\000\073\000\053\000\136\000\133\000\053\000\019\000\061\000\
\144\000\000\000\000\000\000\000\053\000\000\000\053\000\053\000\
\053\000\000\000\053\000\053\000\054\000\053\000\000\000\054\000\
\053\000\053\000\053\000\000\000\053\000\053\000\000\000\054\000\
\000\000\000\000\054\000\000\000\000\000\000\000\000\000\000\000\
\083\000\054\000\000\000\054\000\054\000\054\000\084\000\054\000\
\054\000\000\000\054\000\000\000\000\000\054\000\054\000\054\000\
\000\000\054\000\054\000\085\000\000\000\112\000\086\000\087\000\
\088\000\089\000\090\000\083\000\000\000\000\000\000\000\091\000\
\083\000\084\000\064\000\092\000\093\000\064\000\084\000\000\000\
\000\000\000\000\000\000\000\000\000\000\064\000\085\000\000\000\
\064\000\086\000\087\000\088\000\089\000\090\000\086\000\087\000\
\088\000\064\000\091\000\031\000\000\000\000\000\092\000\093\000\
\129\000\000\000\031\000\000\000\083\000\031\000\031\000\000\000\
\065\000\031\000\084\000\065\000\083\000\000\000\000\000\000\000\
\000\000\000\000\084\000\065\000\031\000\031\000\065\000\000\000\
\031\000\000\000\086\000\087\000\088\000\000\000\000\000\065\000\
\131\000\112\000\086\000\087\000\088\000\063\000\066\000\067\000\
\063\000\066\000\067\000\000\000\000\000\000\000\000\000\000\000\
\063\000\066\000\067\000\063\000\066\000\067\000\000\000\000\000\
\000\000\000\000\000\000\000\000\063\000\066\000\067\000\031\000\
\047\000\048\000\032\000\046\000\056\000\000\000\050\000\051\000\
\000\000\000\000\000\000\031\000\047\000\048\000\032\000\000\000\
\049\000\057\000\050\000\051\000\031\000\047\000\048\000\032\000\
\000\000\056\000\100\000\050\000\051\000\031\000\047\000\048\000\
\032\000\000\000\056\000\000\000\050\000\051\000"

let yycheck = "\018\000\
\018\000\029\000\096\000\105\000\007\001\099\000\004\001\045\000\
\030\000\001\000\023\000\003\001\010\001\014\001\017\001\034\000\
\034\000\009\001\019\001\004\001\012\001\049\000\050\000\051\000\
\046\000\010\001\039\000\049\000\056\000\067\000\028\001\044\000\
\060\000\007\001\037\001\002\001\064\000\065\000\020\001\141\000\
\142\000\026\001\027\001\028\001\138\000\004\001\013\001\003\001\
\019\001\016\001\032\001\010\001\037\001\009\001\001\001\083\000\
\084\000\085\000\086\000\087\000\088\000\089\000\090\000\091\000\
\092\000\093\000\104\000\026\001\027\001\028\001\004\001\025\001\
\094\000\095\000\024\001\008\001\010\001\096\000\096\000\019\001\
\099\000\099\000\015\001\037\001\002\001\018\001\019\001\005\001\
\002\001\022\001\004\001\005\001\026\001\027\001\028\001\013\001\
\010\001\033\001\016\001\013\001\033\001\129\000\016\001\037\001\
\037\001\036\001\019\001\025\001\038\001\023\001\037\001\025\001\
\026\001\027\001\028\001\029\001\030\001\031\001\032\001\138\000\
\138\000\035\001\036\001\037\001\002\001\039\001\040\001\041\001\
\002\001\014\001\004\001\005\001\019\001\031\001\019\001\013\001\
\010\001\038\001\007\001\013\001\025\001\024\001\016\001\041\001\
\034\001\037\001\025\001\025\001\017\001\023\001\038\001\025\001\
\026\001\027\001\028\001\029\001\030\001\002\001\032\001\031\001\
\005\001\035\001\036\001\037\001\031\001\039\001\040\001\038\001\
\013\001\031\001\038\001\016\001\002\001\037\001\002\001\005\001\
\020\001\006\001\023\001\032\001\025\001\026\001\027\001\013\001\
\029\001\030\001\002\001\032\001\005\001\005\001\035\001\036\001\
\037\001\025\001\039\001\040\001\013\001\013\001\033\001\016\001\
\016\001\038\001\025\001\034\001\037\001\025\001\001\000\023\001\
\025\001\025\001\026\001\027\001\013\000\029\001\030\001\002\001\
\032\001\001\000\005\001\035\001\036\001\037\001\073\000\039\001\
\040\001\042\000\013\001\108\000\104\000\016\001\011\000\034\000\
\139\000\255\255\255\255\255\255\023\001\255\255\025\001\026\001\
\027\001\255\255\029\001\030\001\002\001\032\001\255\255\005\001\
\035\001\036\001\037\001\255\255\039\001\040\001\255\255\013\001\
\255\255\255\255\016\001\255\255\255\255\255\255\255\255\255\255\
\004\001\023\001\255\255\025\001\026\001\027\001\010\001\029\001\
\030\001\255\255\032\001\255\255\255\255\035\001\036\001\037\001\
\255\255\039\001\040\001\023\001\255\255\025\001\026\001\027\001\
\028\001\029\001\030\001\004\001\255\255\255\255\255\255\035\001\
\004\001\010\001\002\001\039\001\040\001\005\001\010\001\255\255\
\255\255\255\255\255\255\255\255\255\255\013\001\023\001\255\255\
\016\001\026\001\027\001\028\001\029\001\030\001\026\001\027\001\
\028\001\025\001\035\001\008\001\255\255\255\255\039\001\040\001\
\036\001\255\255\015\001\255\255\004\001\018\001\019\001\255\255\
\002\001\022\001\010\001\005\001\004\001\255\255\255\255\255\255\
\255\255\255\255\010\001\013\001\033\001\034\001\016\001\255\255\
\037\001\255\255\026\001\027\001\028\001\255\255\255\255\025\001\
\032\001\025\001\026\001\027\001\028\001\002\001\002\001\002\001\
\005\001\005\001\005\001\255\255\255\255\255\255\255\255\255\255\
\013\001\013\001\013\001\016\001\016\001\016\001\255\255\255\255\
\255\255\255\255\255\255\255\255\025\001\025\001\025\001\019\001\
\020\001\021\001\022\001\011\001\024\001\255\255\026\001\027\001\
\255\255\255\255\255\255\019\001\020\001\021\001\022\001\255\255\
\024\001\037\001\026\001\027\001\019\001\020\001\021\001\022\001\
\255\255\024\001\025\001\026\001\027\001\019\001\020\001\021\001\
\022\001\255\255\024\001\255\255\026\001\027\001"

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
  T_prod\000\
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
# 220 "Parser.mly"
                        ( fun _ -> codegen _1 true )
# 497 "Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> Identifier.id * param list * typ) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : unit -> unit) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> unit) in
    Obj.repr(
# 222 "Parser.mly"
                                      ( fun _ -> let (func_name, params, return_type) = _1 () in
                                                 semaFunc "name" params return_type;
                                                 _2 ();
                                                 let body = _3 () in
                                                 let param_types = List.map ( fun p -> typ_to_lltype p.param_type ) params in
                                                 (* genFuncDef "name" param_types return_type body; *)
                                                 closeScope();
                                      )
# 513 "Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    Obj.repr(
# 231 "Parser.mly"
                                         ( fun _ -> () )
# 519 "Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : unit -> unit) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit -> unit) in
    Obj.repr(
# 232 "Parser.mly"
                                         ( fun _ -> begin _1 (); _2 () end )
# 527 "Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 6 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 4 : unit -> param) in
    let _5 = (Parsing.peek_val __caml_parser_env 3 : unit -> param list) in
    let _8 = (Parsing.peek_val __caml_parser_env 0 : unit -> typ) in
    Obj.repr(
# 234 "Parser.mly"
                                                                                  ( fun _ -> let id = (id_make _2) in
                                                                                             let params = _4 () :: _5 () in
                                                                                             let return_type = _8 () in
                                                                                             (id, params, return_type)
                                                                                  )
# 541 "Parser.ml"
               : unit -> Identifier.id * param list * typ))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : unit -> typ) in
    Obj.repr(
# 239 "Parser.mly"
                                                                                  ( fun _ -> let id = (id_make _2) in
                                                                                             let params = [] in
                                                                                             let return_type = _6 () in
                                                                                             (id, params, return_type)
                                                                                  )
# 553 "Parser.ml"
               : unit -> Identifier.id * param list * typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 245 "Parser.mly"
                                                            ( fun _ -> [] )
# 559 "Parser.ml"
               : unit -> param list))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : unit -> param) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> param list) in
    Obj.repr(
# 246 "Parser.mly"
                                                            ( fun _ -> _2 () :: _3 () )
# 567 "Parser.ml"
               : unit -> param list))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 2 : unit -> Identifier.id list) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : unit -> typ) in
    Obj.repr(
# 248 "Parser.mly"
                                                     ( fun _ -> let params = (id_make _2) :: _3 () in
                                                                let param_type = _5 () in
                                                                { id = params; mode = PASS_BY_REFERENCE ; param_type = param_type }
                                                     )
# 579 "Parser.ml"
               : unit -> param))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _2 = (Parsing.peek_val __caml_parser_env 2 : unit -> Identifier.id list) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : unit -> typ) in
    Obj.repr(
# 252 "Parser.mly"
                                                     ( fun _ -> let params = (id_make _1) :: _2 () in
                                                                let param_type = _4 () in
                                                                { id = params; mode = PASS_BY_VALUE ; param_type = param_type }
                                                     )
# 591 "Parser.ml"
               : unit -> param))
; (fun __caml_parser_env ->
    Obj.repr(
# 257 "Parser.mly"
                                          ( fun _ -> [] )
# 597 "Parser.ml"
               : unit -> Identifier.id list))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> Identifier.id list) in
    Obj.repr(
# 258 "Parser.mly"
                                          ( fun _ -> (id_make _2) :: _3 () )
# 605 "Parser.ml"
               : unit -> Identifier.id list))
; (fun __caml_parser_env ->
    Obj.repr(
# 260 "Parser.mly"
                  ( fun _ -> TYPE_int )
# 611 "Parser.ml"
               : unit -> typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 261 "Parser.mly"
                  ( fun _ -> TYPE_char )
# 617 "Parser.ml"
               : unit -> typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 263 "Parser.mly"
                                                                             ( fun _ -> [] )
# 623 "Parser.ml"
               : unit -> int list))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : int) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : unit -> int list) in
    Obj.repr(
# 264 "Parser.mly"
                                                                             ( fun _ -> _2 :: _4 () )
# 631 "Parser.ml"
               : unit -> int list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit -> typ) in
    Obj.repr(
# 266 "Parser.mly"
                    ( fun _ -> _1 () )
# 638 "Parser.ml"
               : unit -> typ))
; (fun __caml_parser_env ->
    Obj.repr(
# 267 "Parser.mly"
                    ( fun _ -> TYPE_proc )
# 644 "Parser.ml"
               : unit -> typ))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : unit -> typ) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : unit -> int list) in
    Obj.repr(
# 269 "Parser.mly"
                                                              ( fun _ -> let base_type = _1 () in
                                                                         let dimensions = max_int :: _4 () in
                                                                         match dimensions with
                                                                         | [] -> base_type
                                                                         | _ -> TYPE_array (base_type, dimensions)
                                                              )
# 657 "Parser.ml"
               : unit -> typ))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : unit -> typ) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit -> int list) in
    Obj.repr(
# 275 "Parser.mly"
                                                              ( fun _ -> let base_type = _1 () in
                                                                         let dimensions = _2 () in
                                                                         match dimensions with
                                                                         | [] -> base_type
                                                                         | _ -> TYPE_array (base_type, dimensions)
                                                              )
# 670 "Parser.ml"
               : unit -> typ))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : unit -> typ) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit -> int list) in
    Obj.repr(
# 282 "Parser.mly"
                                             ( fun _ -> let base_type = _1 () in
                                                        let dimensions = _2 () in
                                                        match dimensions with
                                                        | [] -> base_type
                                                        | _  -> TYPE_array (base_type, dimensions)
                                             )
# 683 "Parser.ml"
               : unit -> typ))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit -> unit) in
    Obj.repr(
# 289 "Parser.mly"
                     ( _1 )
# 690 "Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit -> unit) in
    Obj.repr(
# 290 "Parser.mly"
                     ( _1 )
# 697 "Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit -> unit) in
    Obj.repr(
# 291 "Parser.mly"
                     ( _1 )
# 704 "Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : unit -> Identifier.id * param list * typ) in
    Obj.repr(
# 293 "Parser.mly"
                              ( fun _ -> let (func_name, params, return_type) = _1 () in
                                         let param_types = List.map ( fun p -> typ_to_lltype p.param_type ) params in
                                         semaFunc "name" params return_type;
                                         genFuncDecl "name" param_types return_type;
                                         closeScope();
                              )
# 716 "Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : unit -> Identifier.id list) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : unit -> typ) in
    Obj.repr(
# 300 "Parser.mly"
                                                                 ( fun _ -> let vars = (id_make _2) :: _3 () in
                                                                            let var_type = _5 () in
                                                                            List.iter ( fun var -> ignore(newVariable var var_type true) ) vars
                                                                 )
# 728 "Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    Obj.repr(
# 305 "Parser.mly"
                                        ( fun _ -> () )
# 734 "Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : unit -> (string * int list)) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : unit -> llvalue) in
    Obj.repr(
# 306 "Parser.mly"
                                        ( fun _ -> let (id, l) = _1 () in
                                                   let value = _3 () in
                                                   let e = lookupEntry (id_make id) LOOKUP_CURRENT_SCOPE true in
                                                   match e.entry_info with 
                                                   | ENTRY_variable v -> (match l with
                                                                         | [] -> ( match v.variable_type with
                                                                                   | TYPE_int -> 
                                                                                                 error "%a is of type int" pretty_id (id_make id)       
                                                                                   | TYPE_char -> 
                                                                                                 error "%a is of type char" pretty_id (id_make id)                                                                                    | _ -> error "%a is an array" pretty_id (id_make id)  )
                                                                         | _  -> ( match v.variable_type with
                                                                                   | TYPE_array (t, d) -> () (* check dimensions of value and  *)
                                                                                   | _ -> error "%a is not an array" pretty_id  (id_make id)                                                                                  )
                                                                         )
                                                   | _ -> error "%a is not a variable" pretty_id (id_make id)
                                        )
# 757 "Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit -> unit) in
    Obj.repr(
# 322 "Parser.mly"
                                        ( _1 )
# 764 "Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : unit -> llvalue option) in
    Obj.repr(
# 323 "Parser.mly"
                                        ( fun _ -> () )
# 771 "Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : unit -> llvalue) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : unit -> unit) in
    Obj.repr(
# 324 "Parser.mly"
                                        ( fun _ -> let cond_val = _2 () in
                                                   let start_bb = insertion_block builder in
                                                   let the_function = block_parent start_bb in
                                                   let then_bb = append_block context "then" the_function in
                                                   let merge_bb = append_block context "ifcont" the_function in
                                                   position_at_end then_bb builder;
                                                   _4 ();
                                                   begin match block_terminator (insertion_block builder) with
                                                   | None -> ignore(build_br merge_bb builder)
                                                   | Some _ -> ()
                                                   end;
                                                   position_at_end start_bb builder;
                                                   ignore(build_cond_br cond_val then_bb merge_bb builder);
                                                   position_at_end merge_bb builder 
                                        )
# 793 "Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : unit -> llvalue) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : unit -> unit) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : unit -> unit) in
    Obj.repr(
# 339 "Parser.mly"
                                        ( fun _ -> let cond_val = _2 () in
                                                   let start_bb = insertion_block builder in
                                                   let the_function = block_parent start_bb in
                                                   let then_bb = append_block context "then" the_function in
                                                   let merge_bb = append_block context "ifcont" the_function in
                                                   position_at_end then_bb builder;
                                                   _4 ();
                                                   begin match block_terminator (insertion_block builder) with
                                                   | None -> ignore(build_br merge_bb builder)
                                                   | Some _ -> ()
                                                   end;
                                                   let else_bb = append_block context "else" the_function in
                                                   position_at_end else_bb builder;
                                                   _6 ();
                                                   begin match block_terminator (insertion_block builder) with
                                                   | None -> ignore(build_br merge_bb builder)
                                                   | Some _ -> ()
                                                   end;
                                                   position_at_end start_bb builder;
                                                   ignore(build_cond_br cond_val then_bb else_bb builder);
                                                   position_at_end merge_bb builder 
                                        )
# 823 "Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : unit -> llvalue) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : unit -> unit) in
    Obj.repr(
# 361 "Parser.mly"
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
# 847 "Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    Obj.repr(
# 378 "Parser.mly"
                                        ( fun _ -> ignore(build_ret_void builder) )
# 853 "Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : unit -> llvalue) in
    Obj.repr(
# 379 "Parser.mly"
                                        ( fun _ -> let ret_val = _2 () in
                                                   ignore(build_ret ret_val builder)
                                        )
# 862 "Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : unit -> unit) in
    Obj.repr(
# 384 "Parser.mly"
                                   ( _2 )
# 869 "Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    Obj.repr(
# 386 "Parser.mly"
                          ( fun _ -> () )
# 875 "Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : unit -> unit) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit -> unit) in
    Obj.repr(
# 387 "Parser.mly"
                          ( fun _ -> begin _1 (); _2 () end )
# 883 "Parser.ml"
               : unit -> unit))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    Obj.repr(
# 389 "Parser.mly"
                                                       ( fun _ -> let func_name = _1 in
                                                                  match func_name with
                                                                  | "writeInteger" -> print_string "WriteInteger"; None
                                                                  | "writeChar"    -> print_string "WriteChar"; None 
                                                                  | "writeString"  -> print_string "WriteString"; None 
                                                                  | "readInteger"  -> print_string "ReadInteger"; None 
                                                                  | "readChar"     -> print_string "ReadChar"; None 
                                                                  | "readString"   -> print_string "ReadString"; None 
                                                                  | _ -> None (* TODO *)
                                                       )
# 899 "Parser.ml"
               : unit -> llvalue option))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 2 : unit -> llvalue) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : unit -> llvalue list) in
    Obj.repr(
# 399 "Parser.mly"
                                                       ( fun _ -> let func_name = _1 in
                                                                  let args = _3 () :: _4 () in
                                                                  match func_name with
                                                                  | "writeInteger" -> print_string "WriteInteger"; None 
                                                                  | "writeChar"    -> print_string "WriteChar"; None 
                                                                  | "writeString"  -> print_string "WriteString"; None 
                                                                  | "readInteger"  -> print_string "ReadInteger"; None 
                                                                  | "readChar"     -> print_string "ReadChar"; None 
                                                                  | "readString"   -> print_string "ReadString"; None 
                                                                  | _ -> None (* TODO *)
                                                       )
# 918 "Parser.ml"
               : unit -> llvalue option))
; (fun __caml_parser_env ->
    Obj.repr(
# 412 "Parser.mly"
                                              ( fun _ -> [] )
# 924 "Parser.ml"
               : unit -> llvalue list))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : unit -> llvalue) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> llvalue list) in
    Obj.repr(
# 413 "Parser.mly"
                                              ( fun _ -> _2 () :: _3 () )
# 932 "Parser.ml"
               : unit -> llvalue list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 415 "Parser.mly"
                                        ( fun _ -> (_1, []) )
# 939 "Parser.ml"
               : unit -> (string * int list)))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 416 "Parser.mly"
                                        ( fun _ -> (_1, []) )
# 946 "Parser.ml"
               : unit -> (string * int list)))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : unit -> (string * int list)) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : unit -> llvalue) in
    Obj.repr(
# 417 "Parser.mly"
                                        ( fun _ -> let (id, l) = _1 () in 
                                                   let e = _3 () in 
                                                   let val_e = type_of e in 
                                                   if is_type_int val_e then (id, 0::l)
                                                   else (fatal "Index expression must be an integer"; (id, []))
                                        )
# 959 "Parser.ml"
               : unit -> (string * int list)))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 425 "Parser.mly"
                             ( fun _ -> const_int int_type _1 )
# 966 "Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : char) in
    Obj.repr(
# 426 "Parser.mly"
                             ( fun _ -> const_int byte_type (Char.code _1) )
# 973 "Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit -> (string * int list)) in
    Obj.repr(
# 427 "Parser.mly"
                             ( fun _ ->  let (id, indices) = _1 () in
                                         let var_address = const_int (i32_type context) 0 in
                                         let value = load_variable_value var_address builder in
                                         value 
                             )
# 984 "Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : unit -> llvalue) in
    Obj.repr(
# 432 "Parser.mly"
                             ( _2 )
# 991 "Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit -> llvalue option) in
    Obj.repr(
# 433 "Parser.mly"
                             ( fun _ -> match _1 () with
                                        | Some r -> r
                                        | _ -> const_int int_type 0 (* TODO *)
                             )
# 1001 "Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit -> llvalue) in
    Obj.repr(
# 437 "Parser.mly"
                             ( fun _ -> _2 () )
# 1008 "Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit -> llvalue) in
    Obj.repr(
# 438 "Parser.mly"
                             ( fun _ -> let e = _2 () in
                                        build_neg e "negtmp" builder 
                             )
# 1017 "Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> llvalue) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> llvalue) in
    Obj.repr(
# 441 "Parser.mly"
                             ( fun _ -> let lhs = _1 () in
                                        let rhs = _3 () in
                                        build_add lhs rhs "addtmp" builder
                             )
# 1028 "Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> llvalue) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> llvalue) in
    Obj.repr(
# 445 "Parser.mly"
                             ( fun _ -> let lhs = _1 () in
                                        let rhs = _3 () in
                                        build_sub lhs rhs "subtmp" builder
                             )
# 1039 "Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> llvalue) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> llvalue) in
    Obj.repr(
# 449 "Parser.mly"
                             ( fun _ -> let lhs = _1 () in
                                        let rhs = _3 () in
                                        build_mul lhs rhs "multmp" builder
                             )
# 1050 "Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> llvalue) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> llvalue) in
    Obj.repr(
# 453 "Parser.mly"
                             ( fun _ -> let lhs = _1 () in
                                        let rhs = _3 () in
                                        build_sdiv lhs rhs "divtmp" builder
                             )
# 1061 "Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> llvalue) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> llvalue) in
    Obj.repr(
# 457 "Parser.mly"
                             ( fun _ -> let lhs = _1 () in
                                        let rhs = _3 () in
                                        build_srem lhs rhs "modtmp" builder
                             )
# 1072 "Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : unit -> llvalue) in
    Obj.repr(
# 462 "Parser.mly"
                             ( _2 )
# 1079 "Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit -> llvalue) in
    Obj.repr(
# 463 "Parser.mly"
                             ( fun _ -> let cond_val = _2 () in
                                        let false_val = const_int (i1_type context) 0 in
                                        build_icmp Icmp.Ne cond_val false_val "nottmp" builder
                             )
# 1089 "Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> llvalue) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> llvalue) in
    Obj.repr(
# 467 "Parser.mly"
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
# 1110 "Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> llvalue) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> llvalue) in
    Obj.repr(
# 481 "Parser.mly"
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
# 1131 "Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> llvalue) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> llvalue) in
    Obj.repr(
# 495 "Parser.mly"
                             ( fun _ -> let lhs = _1 () in
                                        let rhs = _3 () in
                                        build_icmp Icmp.Eq lhs rhs "eqtmp" builder
                             )
# 1142 "Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> llvalue) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> llvalue) in
    Obj.repr(
# 499 "Parser.mly"
                             ( fun _ -> let lhs = _1 () in
                                        let rhs = _3 () in
                                        build_icmp Icmp.Ne lhs rhs "eqtmp" builder
                             )
# 1153 "Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> llvalue) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> llvalue) in
    Obj.repr(
# 503 "Parser.mly"
                             ( fun _ -> let lhs = _1 () in
                                        let rhs = _3 () in
                                        build_icmp Icmp.Slt lhs rhs "lesstmp" builder
                             )
# 1164 "Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> llvalue) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> llvalue) in
    Obj.repr(
# 507 "Parser.mly"
                             ( fun _ -> let lhs = _1 () in
                                        let rhs = _3 () in
                                        build_icmp Icmp.Sgt lhs rhs "greatertmp" builder
                             )
# 1175 "Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> llvalue) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> llvalue) in
    Obj.repr(
# 511 "Parser.mly"
                             ( fun _ -> let lhs = _1 () in
                                        let rhs = _3 () in
                                        build_icmp Icmp.Sle lhs rhs "leqtmp" builder
                             )
# 1186 "Parser.ml"
               : unit -> llvalue))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : unit -> llvalue) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : unit -> llvalue) in
    Obj.repr(
# 515 "Parser.mly"
                             ( fun _ -> let lhs = _1 () in
                                        let rhs = _3 () in
                                        build_icmp Icmp.Sge lhs rhs "geqtmp" builder
                             )
# 1197 "Parser.ml"
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
