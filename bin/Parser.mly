%{
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
%token T_assign

%left T_or
%left T_and
%nonassoc T_not
%nonassoc T_eq T_hash T_less T_more T_geq T_leq
%left T_plus T_minus
%left T_times T_div T_mod

%start program
%type <unit -> unit> program
%type <unit -> local_def_type> func_def
%type <unit -> local_def_type list> local_def_list
%type <unit -> string * param list * typ> header
%type <unit -> param list> fpar_def_list
%type <unit -> param> fpar_def
%type <unit -> string list> comma_id_list
%type <unit -> typ> data_type
%type <unit -> int list> array_dims
%type <unit -> typ> ret_type
%type <unit -> typ> fpar_type
%type <unit -> typ> grace_type
%type <unit -> local_def_type> local_def
%type <unit -> local_def_type> func_decl
%type <unit -> local_def_type> var_def
%type <unit -> unit> stmt
%type <unit -> (unit -> unit) list> block
%type <unit -> (unit -> unit) list> stmt_list
%type <unit -> string * expr_type list> func_call
%type <unit -> expr_type list> comma_expr_list
%type <unit -> (lvalue * expr_type list)> l_value
%type <unit -> expr_type> expr
%type <unit -> llvalue> cond


%%

program: func_def T_eof { fun _ -> initSymbolTable 1000;
                                   codegen $1 false
                        }

func_def: header local_def_list block { fun _ -> let (func_name, params, return_type) = $1 () in
                                                 let local_defs = $2 () in
                                                 let body = $3 () in
                                                 FuncDef (func_name, params, return_type, local_defs, body)
                                      }

local_def_list: /* nothing */            { fun _ -> [] }
              | local_def local_def_list { fun _ -> $1 () :: $2 () }

header: T_fun T_id T_lparen fpar_def_list T_rparen T_colon ret_type { fun _ -> let id = $2 in
                                                                               let params = $4 () in
                                                                               let return_type = $7 () in
                                                                               (id, params, return_type)
                                                                    }
      | T_fun T_id T_lparen T_rparen T_colon ret_type               { fun _ -> let id = $2 in
                                                                               let params = [] in
                                                                               let return_type = $6 () in
                                                                               (id, params, return_type)
                                                                    }

fpar_def_list: fpar_def                           { fun _ -> [$1 ()] }
             | fpar_def T_semicolon fpar_def_list { fun _ -> $1 () :: $3 () }

fpar_def: T_ref comma_id_list T_colon fpar_type { fun _ -> let params = $2 () in
                                                           let param_type = $4 () in
                                                           let mode = PASS_BY_REFERENCE in
                                                           { id = params; mode = mode; param_type = param_type }
                                                }
        | comma_id_list T_colon fpar_type       { fun _ -> let params = $1 () in
                                                           let param_type = $3 () in
                                                           let mode = PASS_BY_VALUE in
                                                           { id = params; mode = mode; param_type = param_type }
                                                }

comma_id_list: T_id                       { fun _ -> [$1] }
             | T_id T_comma comma_id_list { fun _ -> $1 :: $3 () }

data_type: T_int  { fun _ -> TYPE_int }
         | T_char { fun _ -> TYPE_char }

array_dims: /* nothing */                            { fun _ -> [] }
          | T_lbrack T_int_const T_rbrack array_dims { fun _ -> $2 :: $4 () }

ret_type: data_type { fun _ -> $1 () }
        | T_nothing { fun _ -> TYPE_proc }

fpar_type: data_type T_lbrack T_rbrack array_dims { fun _ -> let base_type = $1 () in
                                                             let dimensions = -1 :: $4 () in
                                                             match dimensions with
                                                             | [] -> base_type
                                                             | _ -> TYPE_array (base_type, dimensions)
                                                  }
         | data_type array_dims                   { fun _ -> let base_type = $1 () in
                                                             let dimensions = $2 () in
                                                             match dimensions with
                                                             | [] -> base_type
                                                             | _ -> TYPE_array (base_type, dimensions)
                                                  }

grace_type: data_type array_dims { fun _ -> let base_type = $1 () in
                                            let dimensions = $2 () in
                                            match dimensions with
                                            | [] -> base_type
                                            | _  -> TYPE_array (base_type, dimensions)
                                  }

local_def: func_def  { $1 }
         | func_decl { $1 }
         | var_def   { $1 }

func_decl: header T_semicolon { fun _ -> let (func_name, params, return_type) = $1 () in
                                         FuncDecl (func_name, params, return_type)
                              }

var_def: T_var comma_id_list T_colon grace_type T_semicolon { fun _ -> let vars = $2 () in
                                                                       let var_type = $4 () in
                                                                       VarDef (vars, var_type)
                                                            }

stmt: T_semicolon                       { fun _ -> () }
    | l_value T_assign expr T_semicolon { fun _ -> let (lval, indices) = $1 () in
                                                   let value_expr = $3 () in
                                                   let idx = List.map (fun e -> match e with
                                                     | Expr (exp, exp_type) -> exp
                                                     | LValue (v, vt, i)    -> let ll, _ = genVarRead v i "val" in ll
                                                     | Str _         -> error "String cannot be an index"; raise Terminate
                                                   ) indices in
                                                   match lval with
                                                   | Var var_name -> genVarWrite var_name idx value_expr
                                                   | StrLit _ -> error "String literals cannot be assigned to"; raise Terminate
                                        }
    | block                             { fun _ -> let l = $1 () in
                                                   List.iter (fun s -> s ()) l
                                        }
    | func_call T_semicolon             { fun _ -> let (func_name, args) = $1 () in
                                                   ignore(genFuncCall func_name args)
                                        }
    | T_if cond T_then stmt             { fun _ -> let cond_val = $2 () in
                                                   let start_bb = insertion_block builder in
                                                   let the_function = block_parent start_bb in
                                                   let then_bb = append_block context "then" the_function in
                                                   let merge_bb = append_block context "ifcont" the_function in
                                                   position_at_end then_bb builder;
                                                   $4 ();
                                                   begin match block_terminator (insertion_block builder) with
                                                   | None   -> ignore(build_br merge_bb builder)
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
                                                   let then_returns = check_return_flag () in
                                                   reset_return_flag ();
                                                   begin match block_terminator (insertion_block builder) with
                                                   | None   -> ignore(build_br merge_bb builder)
                                                   | Some _ -> ()
                                                   end;
                                                   let else_bb = append_block context "else" the_function in
                                                   position_at_end else_bb builder;
                                                   $6 ();
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
    | T_return T_semicolon              { fun _ -> let function_return_type = match !current_function with
                                                   | Some f -> (match f.entry_info with
                                                     | ENTRY_function info -> info.function_result
                                                     | _ -> error "Expected a function entry"; raise Terminate)
                                                   | None -> error "Return statement not within a function"; raise Terminate in
                                                   if function_return_type <> TYPE_proc then
                                                     error "Return type mismatch: expected %s but got void" (string_of_type function_return_type);
                                                   set_return_flag ();
                                                   ignore(build_ret_void builder)
                                        }
    | T_return expr T_semicolon         { fun _ -> let expr_val, expr_type = match $2 () with
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
                                        }


block: T_lbrace stmt_list T_rbrace { $2 }

stmt_list: /* nothing */  { fun _ -> [] }
         | stmt stmt_list { fun _ -> $1 :: $2 () }

func_call: T_id T_lparen T_rparen                 { fun _ -> let func_name = $1 in
                                                             (func_name, [])
                                                  }
         | T_id T_lparen comma_expr_list T_rparen { fun _ -> let func_name = $1 in
                                                             let args = $3 () in
                                                             (func_name, args)
                                                  }


comma_expr_list: expr                         { fun _ -> [$1 ()] }
               | expr T_comma comma_expr_list { fun _ -> $1 () :: $3 () }

l_value: T_id                           { fun _ -> (Var $1, []) }
       | T_string_literal               { fun _ -> (StrLit $1, []) }
       | l_value T_lbrack expr T_rbrack { fun _ -> let (id, l) = $1 () in
                                                   let e = l @ [$3 ()] in
                                                   (id, e)
                                        }


expr: T_int_const            { fun _ -> Expr ((const_int int_type $1), TYPE_int) }
    | T_char_const           { fun _ -> Expr ((const_int char_type (Char.code $1)), TYPE_char) }
    | l_value                { fun _ -> let (lval, indices) = $1 () in
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
                             }
    | T_lparen expr T_rparen { $2 }
    | func_call              { fun _ -> let (func_name, args) = $1 () in
                                        let t = if List.mem func_name libs then (lib_ret_type func_name)
                                        else begin
                                          let e = lookupEntry (id_make func_name) LOOKUP_ALL_SCOPES true in
                                          match e.entry_info with
                                          | ENTRY_function info -> info.function_result
                                          | _ -> (error "%s is not a function" func_name; raise Terminate) end in
                                        Expr ((genFuncCall func_name args), t)
                             }
    | T_plus expr            { fun _ -> $2 () }
    | T_minus expr           { fun _ -> let e, t = match $2 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | Str _                -> error "Cannot aquire negative of string"; raise Terminate in
                                        Expr ((build_neg e "negtmp" builder), t)
                             }
    | expr T_plus expr       { fun _ -> let lhs, lhs_type = match $1 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _                    -> error "Cannot add to string"; raise Terminate in
                                        let rhs, rhs_type = match $3 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot multiply with string"; raise Terminate in
                                        if semaBinOp lhs lhs_type rhs rhs_type "'+'" then
                                          Expr ((build_add lhs rhs "addtmp" builder), lhs_type)
                                        else raise Terminate
                             }
    | expr T_minus expr      { fun _ -> let lhs, lhs_type = match $1 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot subtract to/from string"; raise Terminate in
                                        let rhs, rhs_type = match $3 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot multiply with string"; raise Terminate in
                                        if semaBinOp lhs lhs_type rhs rhs_type "'-'" then
                                          Expr ((build_sub lhs rhs "subtmp" builder), lhs_type)
                                        else raise Terminate
                             }
    | expr T_times expr      { fun _ -> let lhs, lhs_type = match $1 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot multiply with string"; raise Terminate in
                                        let rhs, rhs_type = match $3 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot multiply with string"; raise Terminate in
                                        if semaBinOp lhs lhs_type rhs rhs_type "'*'" then
                                          Expr ((build_mul lhs rhs "multmp" builder), lhs_type)
                                        else raise Terminate
                             }
    | expr T_div expr        { fun _ -> let lhs, lhs_type = match $1 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot divide string"; raise Terminate in
                                        let rhs, rhs_type = match $3 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot multiply with string"; raise Terminate in
                                        if semaBinOp lhs lhs_type rhs rhs_type "'div'" then
                                          Expr ((build_sdiv lhs rhs "divtmp" builder), lhs_type)
                                        else raise Terminate
                             }
    | expr T_mod expr        { fun _ -> let lhs, lhs_type = match $1 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot divide string"; raise Terminate in
                                        let rhs, rhs_type = match $3 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot multiply with string"; raise Terminate in
                                        if semaBinOp lhs lhs_type rhs rhs_type "'mod'" then
                                          Expr ((build_srem lhs rhs "modtmp" builder), lhs_type)
                                        else raise Terminate
                             }

cond: T_lparen cond T_rparen { $2 }
    | T_not cond             { fun _ -> let cond_val = $2 () in
                                        let false_val = const_int (i1_type context) 0 in
                                        build_icmp Icmp.Ne cond_val false_val "nottmp" builder
                             }
    | cond T_and cond        { fun _ -> let lhs = $1 () in
                                        let rhs = $3 () in
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
                             }
    | cond T_or cond         { fun _ -> let lhs = $1 () in
                                        let rhs = $3 () in
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
                             }
    | expr T_eq expr         { fun _ -> let lhs, lhs_type = match $1 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot compare with string"; raise Terminate in
                                        let rhs, rhs_type = match $3 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot compare with string"; raise Terminate in
                                        if semaComp lhs rhs then
                                          build_icmp Icmp.Eq lhs rhs "eqtmp" builder
                                        else raise Terminate
                             }
    | expr T_hash expr       { fun _ -> let lhs, lhs_type = match $1 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot compare with string"; raise Terminate  in
                                        let rhs, rhs_type = match $3 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot compare with string"; raise Terminate in
                                        if semaComp lhs rhs then
                                          build_icmp Icmp.Ne lhs rhs "eqtmp" builder
                                        else raise Terminate
                             }
    | expr T_less expr       { fun _ -> let lhs, lhs_type = match $1 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot compare with string"; raise Terminate  in
                                        let rhs, rhs_type = match $3 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot compare with string"; raise Terminate in
                                        if semaComp lhs rhs then
                                          build_icmp Icmp.Slt lhs rhs "lesstmp" builder
                                        else raise Terminate
                             }
    | expr T_more expr       { fun _ -> let lhs, lhs_type = match $1 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot compare with string"; raise Terminate  in
                                        let rhs, rhs_type = match $3 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot compare with string"; raise Terminate in
                                        if semaComp lhs rhs then
                                          build_icmp Icmp.Sgt lhs rhs "greatertmp" builder
                                        else raise Terminate
                             }
    | expr T_leq expr        { fun _ -> let lhs, lhs_type = match $1 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot compare with string"; raise Terminate  in
                                        let rhs, rhs_type = match $3 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot compare with string"; raise Terminate in
                                        if semaComp lhs rhs then
                                          build_icmp Icmp.Sle lhs rhs "leqtmp" builder
                                        else raise Terminate
                             }
    | expr T_geq expr        { fun _ -> let lhs, lhs_type = match $1 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot compare with string"; raise Terminate  in
                                        let rhs, rhs_type = match $3 () with
                                        | Expr (exp, exp_type) -> (exp, exp_type)
                                        | LValue (v, vt, i)    -> genVarRead v i "val"
                                        | _             -> error "Cannot compare with string"; raise Terminate in
                                        if semaComp lhs rhs then
                                          build_icmp Icmp.Sge lhs rhs "geqtmp" builder
                                        else raise Terminate
                             }
