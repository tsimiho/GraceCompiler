%{
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


%}

%token T_eof
%token T_and
%token T_char
%token T_div
%token T_do
%token T_else
%token T_fun
%token T_if
%token T_int
%token T_mod
%token T_not
%token T_nothing
%token T_or
%token T_ref
%token T_return
%token T_then
%token T_var
%token T_while
%token<string> T_id
%token<int> T_int_const
%token<char> T_char_const
%token<string> T_string_literal
%token T_eq
%token T_lparen
%token T_rparen
%token T_plus
%token T_minus
%token T_times
%token T_less
%token T_more
%token T_lbrack
%token T_rbrack
%token T_lbrace
%token T_rbrace
%token T_hash
%token T_comma
%token T_semicolon
%token T_colon
%token T_leq
%token T_geq
%token T_prod

%left T_or
%left T_and
%nonassoc T_not
%nonassoc T_eq T_hash T_less T_more T_geq T_leq
%left T_plus T_minus
%left T_times T_div T_mod

%start program
%type <unit -> unit> program
%type <unit -> unit> func_def
%type <unit -> unit> local_def_list
%type <unit -> Identifier.id * param list * typ> header
%type <unit -> param list> semi_fpar_def_list
%type <unit -> param> fpar_def
%type <unit -> Identifier.id list> comma_id_list
%type <unit -> typ> data_type
%type <unit -> int list> bracket_int_const_list
%type <unit -> typ> ret_type
%type <unit -> typ> fpar_type
%type <unit -> typ> grace_type
%type <unit -> unit> local_def
%type <unit -> unit> func_decl
%type <unit -> unit> var_def
%type <unit -> unit> stmt
%type <unit -> unit> block
%type <unit -> unit> stmt_list
%type <unit -> llvalue option> func_call
%type <unit -> llvalue list> comma_expr_list
%type <unit -> (string * int list)> l_value
%type <unit -> llvalue> expr
%type <unit -> llvalue> cond


%%

program: func_def T_eof { fun _ -> codegen $1 true }

func_def: header local_def_list block { fun _ -> let (func_name, params, return_type) = $1 () in
                                                 semaFunc "name" params return_type;
                                                 $2 ();
                                                 let body = $3 () in
                                                 let param_types = List.map ( fun p -> typ_to_lltype p.param_type ) params in
                                                 (* genFuncDef "name" param_types return_type body; *)
                                                 closeScope();
                                      }

local_def_list: /* nothing */            { fun _ -> () }
              | local_def local_def_list { fun _ -> begin $1 (); $2 () end }

header: T_fun T_id T_lparen fpar_def semi_fpar_def_list T_rparen T_colon ret_type { fun _ -> let id = (id_make $2) in
                                                                                             let params = $4 () :: $5 () in
                                                                                             let return_type = $8 () in
                                                                                             (id, params, return_type)
                                                                                  }
      | T_fun T_id T_lparen T_rparen T_colon ret_type                             { fun _ -> let id = (id_make $2) in
                                                                                             let params = [] in
                                                                                             let return_type = $6 () in
                                                                                             (id, params, return_type)
                                                                                  }

semi_fpar_def_list: /* nothing */                           { fun _ -> [] }
                  | T_semicolon fpar_def semi_fpar_def_list { fun _ -> $2 () :: $3 () }

fpar_def: T_ref T_id comma_id_list T_colon fpar_type { fun _ -> let params = (id_make $2) :: $3 () in
                                                                let param_type = $5 () in
                                                                { id = params; mode = PASS_BY_REFERENCE ; param_type = param_type }
                                                     }
        | T_id comma_id_list T_colon fpar_type       { fun _ -> let params = (id_make $1) :: $2 () in
                                                                let param_type = $4 () in
                                                                { id = params; mode = PASS_BY_VALUE ; param_type = param_type }
                                                     }

comma_id_list: /* nothing */              { fun _ -> [] }
             | T_comma T_id comma_id_list { fun _ -> (id_make $2) :: $3 () }

data_type: T_int  { fun _ -> TYPE_int }
         | T_char { fun _ -> TYPE_char }

bracket_int_const_list: /* nothing */                                        { fun _ -> [] }
                      | T_lbrack T_int_const T_rbrack bracket_int_const_list { fun _ -> $2 :: $4 () }

ret_type: data_type { fun _ -> $1 () }
        | T_nothing { fun _ -> TYPE_proc }

fpar_type: data_type T_lbrack T_rbrack bracket_int_const_list { fun _ -> let base_type = $1 () in
                                                                         let dimensions = max_int :: $4 () in
                                                                         match dimensions with
                                                                         | [] -> base_type
                                                                         | _ -> TYPE_array (base_type, dimensions)
                                                              }
         | data_type bracket_int_const_list                   { fun _ -> let base_type = $1 () in
                                                                         let dimensions = $2 () in
                                                                         match dimensions with
                                                                         | [] -> base_type
                                                                         | _ -> TYPE_array (base_type, dimensions)
                                                              }

grace_type: data_type bracket_int_const_list { fun _ -> let base_type = $1 () in
                                                        let dimensions = $2 () in
                                                        match dimensions with
                                                        | [] -> base_type
                                                        | _  -> TYPE_array (base_type, dimensions)
                                             }

local_def: func_def  { $1 }
         | func_decl { $1 }
         | var_def   { $1 }

func_decl: header T_semicolon { fun _ -> let (func_name, params, return_type) = $1 () in
                                         let param_types = List.map ( fun p -> typ_to_lltype p.param_type ) params in
                                         semaFunc "name" params return_type;
                                         genFuncDecl "name" param_types return_type;
                                         closeScope();
                              }

var_def: T_var T_id comma_id_list T_colon grace_type T_semicolon { fun _ -> let vars = (id_make $2) :: $3 () in
                                                                            let var_type = $5 () in
                                                                            List.iter ( fun var -> ignore(newVariable var var_type true) ) vars
                                                                 }

stmt: T_semicolon                       { fun _ -> () }
    | l_value T_prod expr T_semicolon   { fun _ -> let (id, l) = $1 () in
                                                   let value = $3 () in
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
                                        }
    | block                             { $1 }
    | func_call T_semicolon             { fun _ -> () } // TODO
    | T_if cond T_then stmt             { fun _ -> let cond_val = $2 () in
                                                   let start_bb = insertion_block builder in
                                                   let the_function = block_parent start_bb in
                                                   let then_bb = append_block context "then" the_function in
                                                   let merge_bb = append_block context "ifcont" the_function in
                                                   position_at_end then_bb builder;
                                                   $4 ();
                                                   begin match block_terminator (insertion_block builder) with
                                                   | None -> ignore(build_br merge_bb builder)
                                                   | Some _ -> ()
                                                   end;
                                                   position_at_end start_bb builder;
                                                   ignore(build_cond_br cond_val then_bb merge_bb builder);
                                                   position_at_end merge_bb builder 
                                        }
    | T_if cond T_then stmt T_else stmt { fun _ -> let cond_val = $2 () in
                                                   let start_bb = insertion_block builder in
                                                   let the_function = block_parent start_bb in
                                                   let then_bb = append_block context "then" the_function in
                                                   let merge_bb = append_block context "ifcont" the_function in
                                                   position_at_end then_bb builder;
                                                   $4 ();
                                                   begin match block_terminator (insertion_block builder) with
                                                   | None -> ignore(build_br merge_bb builder)
                                                   | Some _ -> ()
                                                   end;
                                                   let else_bb = append_block context "else" the_function in
                                                   position_at_end else_bb builder;
                                                   $6 ();
                                                   begin match block_terminator (insertion_block builder) with
                                                   | None -> ignore(build_br merge_bb builder)
                                                   | Some _ -> ()
                                                   end;
                                                   position_at_end start_bb builder;
                                                   ignore(build_cond_br cond_val then_bb else_bb builder);
                                                   position_at_end merge_bb builder 
                                        }
    | T_while cond T_do stmt            { fun _ -> let start_bb = insertion_block builder in
                                                   let the_function = block_parent start_bb in
                                                   let cond_bb = append_block context "loopcond" the_function in
                                                   let loop_bb = append_block context "loopbody" the_function in
                                                   let merge_bb = append_block context "loop_cont" the_function in
                                                   ignore(build_br cond_bb builder);
                                                   position_at_end cond_bb builder;
                                                   let cond_val = $2 () in
                                                   ignore(build_cond_br cond_val loop_bb merge_bb builder);
                                                   position_at_end loop_bb builder;
                                                   $4 ();
                                                   begin match block_terminator (insertion_block builder) with
                                                   | None -> ignore(build_br cond_bb builder)
                                                   | Some _ -> ()
                                                   end;              
                                                   position_at_end merge_bb builder
                                        }
    | T_return T_semicolon              { fun _ -> ignore(build_ret_void builder) }
    | T_return expr T_semicolon         { fun _ -> let ret_val = $2 () in
                                                   ignore(build_ret ret_val builder)
                                        }


block: T_lbrace stmt_list T_rbrace { $2 }

stmt_list: /* nothing */  { fun _ -> () }
         | stmt stmt_list { fun _ -> begin $1 (); $2 () end }

func_call: T_id T_lparen T_rparen                      { fun _ -> let func_name = $1 in
                                                                  match func_name with
                                                                  | "writeInteger" -> print_string "WriteInteger"; None
                                                                  | "writeChar"    -> print_string "WriteChar"; None 
                                                                  | "writeString"  -> print_string "WriteString"; None 
                                                                  | "readInteger"  -> print_string "ReadInteger"; None 
                                                                  | "readChar"     -> print_string "ReadChar"; None 
                                                                  | "readString"   -> print_string "ReadString"; None 
                                                                  | _ -> None (* TODO *)
                                                       }
         | T_id T_lparen expr comma_expr_list T_rparen { fun _ -> let func_name = $1 in
                                                                  let args = $3 () :: $4 () in
                                                                  match func_name with
                                                                  | "writeInteger" -> print_string "WriteInteger"; None 
                                                                  | "writeChar"    -> print_string "WriteChar"; None 
                                                                  | "writeString"  -> print_string "WriteString"; None 
                                                                  | "readInteger"  -> print_string "ReadInteger"; None 
                                                                  | "readChar"     -> print_string "ReadChar"; None 
                                                                  | "readString"   -> print_string "ReadString"; None 
                                                                  | _ -> None (* TODO *)
                                                       }


comma_expr_list: /* nothing */                { fun _ -> [] }
               | T_comma expr comma_expr_list { fun _ -> $2 () :: $3 () }

l_value: T_id                           { fun _ -> ($1, []) }
       | T_string_literal               { fun _ -> ($1, []) }
       | l_value T_lbrack expr T_rbrack { fun _ -> let (id, l) = $1 () in 
                                                   let e = $3 () in 
                                                   let val_e = type_of e in 
                                                   if is_type_int val_e then (id, 0::l)
                                                   else (fatal "Index expression must be an integer"; (id, []))
                                        }


expr: T_int_const            { fun _ -> const_int int_type $1 }
    | T_char_const           { fun _ -> const_int byte_type (Char.code $1) }
    | l_value                { fun _ ->  let (id, indices) = $1 () in
                                         let var_address = const_int (i32_type context) 0 in
                                         let value = load_variable_value var_address builder in
                                         value 
                             }
    | T_lparen expr T_rparen { $2 }
    | func_call              { fun _ -> match $1 () with
                                        | Some r -> r
                                        | _ -> const_int int_type 0 (* TODO *)
                             } // TODO
    | T_plus expr            { fun _ -> $2 () }
    | T_minus expr           { fun _ -> let e = $2 () in
                                        build_neg e "negtmp" builder 
                             }
    | expr T_plus expr       { fun _ -> let lhs = $1 () in
                                        let rhs = $3 () in
                                        build_add lhs rhs "addtmp" builder
                             }
    | expr T_minus expr      { fun _ -> let lhs = $1 () in
                                        let rhs = $3 () in
                                        build_sub lhs rhs "subtmp" builder
                             }
    | expr T_times expr      { fun _ -> let lhs = $1 () in
                                        let rhs = $3 () in
                                        build_mul lhs rhs "multmp" builder
                             }
    | expr T_div expr        { fun _ -> let lhs = $1 () in
                                        let rhs = $3 () in
                                        build_sdiv lhs rhs "divtmp" builder
                             }
    | expr T_mod expr        { fun _ -> let lhs = $1 () in
                                        let rhs = $3 () in
                                        build_srem lhs rhs "modtmp" builder
                             }

cond: T_lparen cond T_rparen { $2 }
    | T_not cond             { fun _ -> let cond_val = $2 () in
                                        let false_val = const_int (i1_type context) 0 in
                                        build_icmp Icmp.Ne cond_val false_val "nottmp" builder
                             }
    | cond T_and cond        { fun _ -> let cond1 = $1 () in
                                        let start_bb = insertion_block builder in
                                        let the_function = block_parent start_bb in
                                        let eval_sec_bb = append_block context "second-cond" the_function in
                                        let merge_bb = append_block context "merge" the_function in
                                        ignore(build_cond_br cond1 eval_sec_bb merge_bb builder);
                                        position_at_end eval_sec_bb builder;
                                        let cond2 = $3 () in
                                        let new_eval_bb = insertion_block builder in
                                        ignore(build_br merge_bb builder);
                                        position_at_end merge_bb builder;
                                        let op = const_int bool_type 1
                                        in build_phi [(op, start_bb);(cond2, new_eval_bb)] "and_phi" builder
                             }
    | cond T_or cond         { fun _ -> let cond1 = $1 () in
                                        let start_bb = insertion_block builder in
                                        let the_function = block_parent start_bb in
                                        let eval_sec_bb = append_block context "second-cond" the_function in
                                        let merge_bb = append_block context "merge" the_function in
                                        ignore(build_cond_br cond1 merge_bb eval_sec_bb builder);
                                        position_at_end eval_sec_bb builder;
                                        let cond2 = $3 () in
                                        let new_eval_bb = insertion_block builder in
                                        ignore(build_br merge_bb builder);
                                        position_at_end merge_bb builder;
                                        let op = const_int bool_type 0
                                        in build_phi [(op, start_bb);(cond2, new_eval_bb)] "or_phi" builder
                             }
    | expr T_eq expr         { fun _ -> let lhs = $1 () in
                                        let rhs = $3 () in
                                        build_icmp Icmp.Eq lhs rhs "eqtmp" builder
                             }
    | expr T_hash expr       { fun _ -> let lhs = $1 () in
                                        let rhs = $3 () in
                                        build_icmp Icmp.Ne lhs rhs "eqtmp" builder
                             }
    | expr T_less expr       { fun _ -> let lhs = $1 () in
                                        let rhs = $3 () in
                                        build_icmp Icmp.Slt lhs rhs "lesstmp" builder
                             }
    | expr T_more expr       { fun _ -> let lhs = $1 () in
                                        let rhs = $3 () in
                                        build_icmp Icmp.Sgt lhs rhs "greatertmp" builder
                             } 
    | expr T_leq expr        { fun _ -> let lhs = $1 () in
                                        let rhs = $3 () in
                                        build_icmp Icmp.Sle lhs rhs "leqtmp" builder
                             } 
    | expr T_geq expr        { fun _ -> let lhs = $1 () in
                                        let rhs = $3 () in
                                        build_icmp Icmp.Sge lhs rhs "geqtmp" builder
                             } 
