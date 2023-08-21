%{

open Printf
open Types
open Identifier
open Symbol
open Semantic 
open Error
open Parsing
open Output
open QuadTypes
open Quads
open Lexing

let printTup (a,b) = print_string a; print_string " "; List.iter (printf "%d ") b

let rec printList = function 
  | [] -> ()
  | [(a,b)] -> printTup (a,b)
  | (a::b) -> printTup a ;  printList b;;

(*function to create table type*)

let rec table_type var_type = function 
  | [] -> var_type
  | (a::b) -> let x = table_type var_type b in TYPE_array(x,a)

(* Simple Function to get Expression Position *)
let get_binop_pos () = (rhs_start_pos 1, rhs_start_pos 3)

(*function to register a variable*)
let registerVar var_type place (a,b,c) = match c with
                                         | Expr(e) -> 
                                         begin
                                            match e.place with
                                                    
                                                | Quad_none -> ignore(newVariable (id_make a) (table_type var_type b) true); return_null_stmt()
                                                | _ ->
                                                    let quad_e = Expr({code=[]; place=Quad_entry(newVariable (id_make a) (table_type var_type b) true)}) in
                                                    if (check_assign "=" quad_e c (rhs_start_pos 1)) then
                                                        (handle_assignment "=" (dereference quad_e) c place)
						    else (internal "Types not matching"; raise Terminate)
                                         end
                                         | Cond(cond) -> let quad_e = Expr({code=[]; place=Quad_entry(newVariable (id_make a) (table_type var_type b) true)})
                                            in if (check_assign "=" quad_e c  (rhs_start_pos 1)) then
                                                handle_assignment "=" (dereference quad_e) c (get_binop_pos())
                                            else (internal "Types not matching"; raise Terminate)
                        
(*function to register a const*)
let registerConst pos var_type (a,v) = let const_val = get_const_val v pos in
                                    newConst (id_make a) var_type const_val true

(*get the parameter list of a function as it is in the symbol table*)
let get_param_list a = 
	match a.entry_info with 
	| ENTRY_function inf -> (
                match inf.function_result with 
                |TYPE_proc -> inf.function_paramlist
                |_ -> List.rev (List.tl (List.rev inf.function_paramlist)) (*omit the result parameter*)
        ) 
        | _ -> internal "Ask for params in a non-function entry"; raise Terminate

(*function to register a param*)
let register_param anc (param_type, (name, mode, nlist)) = 
        let var_type = table_type param_type nlist
	in ignore(newParameter (id_make name)var_type mode anc true)

(*function to register a function/proc and its params*)
let registerFun (fun_type,fun_entry) a = ignore(List.map (register_param fun_entry) a); ignore(endFunctionHeader fun_entry fun_type); fun_entry

(*function to get entry's name*)
let get_name e = id_name e.entry_id 

(* function to handle mutliple expressions as function parameters *)
let handle_fun_mul_params e e_list = 
    let get_expr e = 
        match e with
        | Expr e -> e
        | _ -> return_null() 
    in let sexpr = match e  with
    | Expr exp -> Expr exp
    | Cond c ->
            let temp = newTemporary TYPE_bool
    in let quad_false = Quad_set(Quad_bool("false"), Quad_entry(temp))
    in let quad_true = Quad_set(Quad_bool("true"), Quad_entry(temp))
    in let new_quad = Quad_jump (ref (2)) in                           
    List.iter (fun x -> x := !x + 2) c.q_false;                     
    Expr{                                                           
        code = quad_false :: (new_quad::(quad_true :: c.c_code));
        place = Quad_entry(temp)
                                         }
    in let expr_list = List.map get_expr (sexpr::e_list) in
    expr_list

(* register all library functions *)
let registerLibraryFunctions () =
    let v = (TYPE_proc, newFunction (id_make "putchar") true) in
    (openScope();
    ignore(registerFun v [(TYPE_char, ("c1", PASS_BY_VALUE, []))]);
    closeScope());
    let v = (TYPE_proc, newFunction (id_make "puts") true) in
    (openScope();
    ignore(registerFun v [(TYPE_char, ("c2", PASS_BY_REFERENCE, [0]))]);
    closeScope());
    let v = (TYPE_proc, newFunction (id_make "WRITE_INT") true) in
    (openScope();
    ignore(registerFun v [(TYPE_int, ("n1", PASS_BY_VALUE, []));
                          (TYPE_int, ("w1", PASS_BY_VALUE, []))]);
    closeScope());
    let v = (TYPE_proc, newFunction (id_make "WRITE_BOOL") true) in
    (openScope();
    ignore(registerFun v [(TYPE_bool, ("b1", PASS_BY_VALUE, []));
                          (TYPE_int, ("w2", PASS_BY_VALUE, []))]);
    closeScope());
    let v = (TYPE_proc, newFunction (id_make "WRITE_CHAR") true) in
    (openScope();
    ignore(registerFun v [(TYPE_char, ("c3", PASS_BY_VALUE, []));
                          (TYPE_int, ("w3", PASS_BY_VALUE, []))]);
    closeScope());
    let v = (TYPE_proc, newFunction (id_make "WRITE_STRING") true) in
    (openScope();
    ignore(registerFun v [(TYPE_char, ("n2", PASS_BY_REFERENCE, [0]));
                          (TYPE_int, ("w4", PASS_BY_VALUE, []))]);
    closeScope());
    let v = (TYPE_int, newFunction (id_make "READ_INT") true) in
    (openScope();
    ignore(registerFun v []);
    closeScope());
    let v = (TYPE_bool, newFunction (id_make "READ_BOOL") true) in
    (openScope();
    ignore(registerFun v []);
    closeScope());
    let v = (TYPE_char, newFunction (id_make "get_char") true) in
    (openScope();
    ignore(registerFun v []);
    closeScope());
    let v = (TYPE_proc, newFunction (id_make "READ_STRING") true) in
    (openScope();
    ignore(registerFun v [(TYPE_int, ("w5", PASS_BY_VALUE, []));
                          (TYPE_char, ("n3", PASS_BY_REFERENCE, [0]))]);
    closeScope());
    let v = (TYPE_int, newFunction (id_make "strlen") true) in
    (openScope();
    ignore(registerFun v [(TYPE_char, ("s1", PASS_BY_REFERENCE, [0]))]);
    closeScope());
    let v = (TYPE_int, newFunction (id_make "strcmp") true) in
    (openScope();
    ignore(registerFun v [(TYPE_char, ("s2", PASS_BY_REFERENCE, [0]));
                          (TYPE_char, ("s3", PASS_BY_REFERENCE, [0]))]);
    closeScope());
    let v = (TYPE_proc, newFunction (id_make "strcpy") true) in
    (openScope();
    ignore(registerFun v [(TYPE_char, ("s4", PASS_BY_REFERENCE, [0]));
                          (TYPE_char, ("s5", PASS_BY_REFERENCE, [0]))]);
    closeScope());
    let v = (TYPE_proc, newFunction (id_make "strcat") true) in
    (openScope();
    ignore(registerFun v [(TYPE_char, ("s6", PASS_BY_REFERENCE, [0]));
                          (TYPE_char, ("s7", PASS_BY_REFERENCE, [0]))]);
    closeScope())
    
%}


%token T_and 
%token <Types.typ> T_bool 
%token T_break 
%token T_case 
%token <Types.typ> T_char 
%token T_const 
%token T_continue 
%token T_default 
%token T_do 
%token T_DOWNTO 
%token T_else 
%token T_false 
%token T_FOR 
%token T_FORM 
%token T_FUNC 
%token T_if 
%token <Types.typ> T_int 
%token T_MOD 
%token T_NEXT 
%token T_not 
%token T_or 
%token T_PROC 
%token T_PROGRAM 
%token <Types.typ> T_REAL 
%token T_return 
%token T_STEP 
%token T_switch 
%token T_TO 
%token T_true 
%token T_while 
%token <string> T_WRITE
%token <string> T_WRITELN
%token <string> T_WRITESP
%token <string> T_WRITESPLN
%token <string> T_eq
%token T_lparen 
%token T_rparen 
%token T_plus 
%token T_minus 
%token T_times 
%token T_equal 
%token T_greater 
%token T_less 
%token T_less_equal 
%token T_greater_equal 
%token T_not_equal 
%token T_mod 
%token <string> T_mod_equal 
%token <string> T_plus_equal 
%token <string> T_minus_equal 
%token <string> T_div_equal 
%token <string> T_times_equal
%token T_minus_minus 
%token T_plus_plus 
%token T_OR 
%token T_AND 
%token T_NOT 
%token T_div 
%token T_ampersand 
%token T_semicolon 
%token T_fullstop 
%token T_colon
%token T_comma
%token T_lbracket
%token T_rbracket 
%token T_lbrace
%token T_rbrace 
%token <string> T_name
%token <string> T_real_const
%token <string> T_const_char
%token <string> T_string_const
%token <string> T_int_const

%token T_eof
%left T_AND T_and T_OR T_or
%left T_equal T_not_equal T_less T_greater T_less_equal T_greater_equal

%left T_plus T_minus
%left T_times T_div T_mod T_MOD

%right T_not T_NOT

%start pmodule
%type <QuadTypes.quad_t list> pmodule
%type <QuadTypes.stmt_ret_type> declaration_list
%type <QuadTypes.stmt_ret_type> declaration
%type <unit> const_def
%type <string * QuadTypes.superexpr> const_inner_def 
%type <(string * QuadTypes.superexpr) list> const_def_list
%type <QuadTypes.stmt_ret_type> var_def
%type <(string * int list * QuadTypes.superexpr) list> var_def_list
%type <string * int list * QuadTypes.superexpr> var_init
%type <int list> var_init_bra_list
%type <QuadTypes.stmt_ret_type> routine
%type <entry> routine_header
%type <Types.typ * entry> routine_header_beg
%type <(Types.typ * (string * Symbol.pass_mode * int list)) list> routine_header_body
%type <(Types.typ * (string * Symbol.pass_mode * int list)) list> routine_header_list
%type <string * Symbol.pass_mode * int list> formal
%type <int list> formal_end
%type <QuadTypes.stmt_ret_type> program
%type <Types.typ> ptype
%type <QuadTypes.superexpr> const_expr
%type <QuadTypes.superexpr> expr
%type <QuadTypes.superexpr> l_value
%type <(QuadTypes.superexpr list) * int> expr_list
//%type <unit> unop
//%type <unit> binop
//%type <Types.typ * string * string> call 
%type <QuadTypes.superexpr> call 
%type <QuadTypes.superexpr  list> expressions
%type <QuadTypes.stmt_ret_type> block
%type <QuadTypes.stmt_ret_type> inner_block
%type <QuadTypes.stmt_ret_type> local_def
%type <QuadTypes.stmt_ret_type> stmt
%type <QuadTypes.inner_switch_ret_type> inner_switch
%type <QuadTypes.switch_exp_ret_type> switch_exp
%type <(QuadTypes.superexpr * QuadTypes.superexpr) list> pformat_list
%type <string> assign
%type <QuadTypes.superexpr*QuadTypes.superexpr*QuadTypes.superexpr*string>range
%type <QuadTypes.stmt_ret_type> clause
%type <QuadTypes.stmt_ret_type> stmt_list 
%type <string> write
%type <(QuadTypes.superexpr * QuadTypes.superexpr)> pformat
%%





pmodule : initialization declaration_list T_eof {
  if ((List.length $2.s_code) == 0) then (error "file is empty: No code to compile."; raise Terminate) else $2.s_code
}

initialization : { ignore(initSymbolTable 256);
ignore(registerLibraryFunctions())}

declaration_list : /*nothing */ { return_null_stmt() }
|declaration declaration_list { handle_stmt_merge $1 $2 }

declaration : const_def { return_null_stmt() }
	    | var_def { $1 }
	    | routine { $1 }
	    | program { $1 }

const_inner_def : T_name T_eq const_expr { ($1, $3) } 

const_def : T_const ptype const_inner_def const_def_list T_semicolon { let pos = rhs_start_pos 1 in 
                                                                        ignore(registerConst pos $2 $3); 
                                                                        ignore(List.map
                                                                        (registerConst pos $2) $4) 
                                                                      }


const_def_list : /*nothing*/ { [] }
	       | T_comma const_inner_def const_def_list { $2::$3 }

var_def : ptype var_init var_def_list T_semicolon { let stmt = registerVar $1 (get_binop_pos()) $2 in 
                                                    let list_stmt = List.map (registerVar $1 (get_binop_pos())) $3 in
                                                    let rec help_merge stmt = function 
                                                            | [] -> stmt
                                                            |a::b -> help_merge (handle_stmt_merge a stmt) b
                                                    in help_merge stmt list_stmt
                                                 }

var_def_list : /*nothing*/ { [] }
	     | T_comma var_init var_def_list { ($2::$3) }

var_init : T_name { ($1,[], Expr(return_null())) } 
	    | T_name T_eq expr {($1,[],$3)}
	    | T_name var_init_bra_list { ($1,$2, Expr(return_null())) }


var_init_bra_list : T_lbracket const_expr T_rbracket { [table_size $2 (rhs_start_pos 1)] }
                    | T_lbracket const_expr T_rbracket var_init_bra_list { (table_size $2 (rhs_start_pos 1)::$4) }

routine_header : routine_header_beg T_lparen routine_header_body T_rparen {ignore(currentFun := (snd $1); in_func := true); registerFun $1 $3 }

routine_header_body :/*nothing*/ { [] } 
		    |ptype formal routine_header_list { (($1,$2)::$3) }

routine_header_list : /*nothing*/ { [] }
		    | T_comma ptype formal routine_header_list { (($2,$3) :: $4) }

routine_header_beg : T_PROC T_name { let a = (TYPE_proc,newFunction (id_make $2) true) in ignore(openScope());a }
		   | T_FUNC ptype T_name { let a = ($2,newFunction (id_make $3) true) in ignore(openScope());a }

formal : T_name { ($1,PASS_BY_VALUE,[]) }
       | T_ampersand T_name  { ($2,PASS_BY_REFERENCE,[]) }
       | T_name T_lbracket const_expr T_rbracket formal_end {($1,PASS_BY_REFERENCE,(table_size $3 (rhs_start_pos 1)::$5)) }
       | T_name T_lbracket T_rbracket formal_end {($1,PASS_BY_REFERENCE,(0::$4)) }

formal_end : /*nothing*/ { [] }
	   | T_lbracket const_expr T_rbracket formal_end { (table_size $2 (rhs_start_pos 1)::$4) }

routine : routine_header T_semicolon closeScope { ignore(forwardFunction $1; in_func := false); return_null_stmt() }
	| routine_header block {  (*before closing scope pass to fun_entry the size of the scope*)
                                        ignore(closeFunctionScope $1.entry_info); 
                                        ignore(check_if_return $1 !did_return (rhs_start_pos 2)); 
                                        did_return := false; in_func := false;
                                        { s_code = handle_func_def $1 [] $2.s_code; q_cont = []; q_break = [] } } 

program_header : T_PROGRAM T_name T_lparen T_rparen { let fn =  newFunction (id_make "PROGRAM") true in 
                                                        ignore(openScope());
                                                        fn 
                                                    }

program : program_header block { ignore(closeFunctionScope $1.entry_info);
                                 { s_code = handle_func_def $1 [] $2.s_code; q_cont = []; q_break = [] } }

openScope : { openScope() }

closeScope : { closeScope() }

ptype : T_int  { $1 }
      | T_bool { $1 }
      | T_char { $1 }
      | T_REAL { $1 }

const_expr : expr { $1 } 


expr:  T_int_const { Expr( {code=[]; place= Quad_int ($1)}) }
    | T_real_const { Expr( {code=[]; place= Quad_real ($1)}) }
    | T_const_char { Expr( {code=[]; place= Quad_char ($1)}) }
    | T_string_const { Expr({code=[]; place = Quad_string($1)}) }
    | T_true { Cond(handle_cond_const true) }
    | T_false { Cond(handle_cond_const false) }
    | T_lparen expr T_rparen { $2 }


     | l_value { Expr(dereference $1) }
     | call { $1 }

     | T_plus expr { if (check_is_number $2 (rhs_start_pos 1)) then
                        Expr(handle_unary_expression "+" $2 (rhs_start_pos 2)) 
                     else Expr(return_null())
                    }
     | T_minus expr { if (check_is_number $2 (rhs_start_pos 1)) then
                        Expr(handle_unary_expression "-" $2 (rhs_start_pos 2))
                     else Expr(return_null())
                     }
     | T_NOT expr { if (check_is_bool $2 (rhs_start_pos 1)) then
                        Cond(handle_not $2)
                     else Expr(return_null())
                   }
     | T_not expr { if (check_is_bool $2 (rhs_start_pos 1)) then
                        Cond(handle_not $2) 
                     else Expr(return_null())
                   }
     | expr T_plus expr { let expr_typ = check_binop_types $1 $3 (rhs_start_pos 1) in
                           Expr(handle_expression "+" $1 $3 expr_typ (get_binop_pos()))
                         }
     | expr T_minus expr { let expr_typ = check_binop_types $1 $3 (rhs_start_pos 1) in
                            Expr(handle_expression "-" $1 $3 expr_typ (get_binop_pos())) 
                          }
     | expr T_times expr { let expr_typ = check_binop_types $1 $3 (rhs_start_pos 1) in
                            Expr(handle_expression "*" $1 $3 expr_typ (get_binop_pos())) 
                          }
     | expr T_div expr { let expr_typ = check_binop_types $1 $3 (rhs_start_pos 1) in
                          Expr(handle_expression "/" $1 $3 expr_typ (get_binop_pos())) 
                        }
     | expr T_mod expr { let expr_typ = check_int_binop_types $1 $3 (rhs_start_pos 1) in 
                          Expr(handle_expression "%" $1 $3 expr_typ (get_binop_pos())) 
                        }
     | expr T_MOD expr { let expr_typ = check_int_binop_types $1 $3 (rhs_start_pos 1) in 
                          Expr(handle_expression "%" $1 $3 expr_typ (get_binop_pos())) 
                        }
     | expr T_equal expr { if (check_equalities $1 $3 "==" (rhs_start_pos 1)) then
                            Cond(handle_comparison "==" $1 $3 (get_binop_pos())) 
                           else Cond(return_null_cond())
                          }
    | expr T_not_equal expr { if (check_equalities $1 $3 "!=" (rhs_start_pos 1)) then
                                Cond(handle_comparison "!=" $1 $3 (get_binop_pos())) 
                              else Cond(return_null_cond())
                             }
     | expr T_greater expr { if (check_equalities $1 $3 ">" (rhs_start_pos 1)) then 
                                Cond(handle_comparison ">"  $1 $3 (get_binop_pos())) 
                             else Cond(return_null_cond())
                            }
     | expr T_less expr { if (check_equalities $1 $3 "<" (rhs_start_pos 1)) then 
                            Cond(handle_comparison "<" $1 $3 (get_binop_pos())) 
                          else Cond(return_null_cond())
                         }
     | expr T_less_equal expr { if (check_equalities $1 $3 "<=" (rhs_start_pos 1)) then 
                                 Cond(handle_comparison "<=" $1 $3 (get_binop_pos())) 
                                else Cond(return_null_cond())
                               }
     | expr T_greater_equal expr { if (check_equalities $1 $3 ">=" (rhs_start_pos 1)) then 
                                    Cond(handle_comparison ">=" $1 $3 (get_binop_pos())) 
                                   else Cond(return_null_cond())
                                  }
     | expr T_and expr {  if (check_bool_binop_types $1 $3 (rhs_start_pos 1)) then
                            Cond(handle_and $1 $3) 
                          else Cond(return_null_cond())
                        }
     | expr T_AND expr { if (check_bool_binop_types $1 $3 (rhs_start_pos 1)) then
                            Cond(handle_and $1 $3) 
                          else Cond(return_null_cond())
                        }
     | expr T_OR expr { if (check_bool_binop_types $1 $3 (rhs_start_pos 1)) then
                            Cond(handle_or $1 $3) 
                          else Cond(return_null_cond())
                       }
     | expr T_or expr { if (check_bool_binop_types $1 $3 (rhs_start_pos 1)) then
                            Cond(handle_or $1 $3) 
                          else Cond(return_null_cond())
                       }

l_value : T_name expr_list { 
    let e = lookupEntry  (id_make $1) LOOKUP_ALL_SCOPES true  in
    let pos = (rhs_start_pos 1) in
    ignore(check_lval e pos);
    if (List.length (fst $2)) = 0 then Expr({code=[];place=(Quad_entry (e))})
    else let type_of_var = (match e.entry_info with
        | ENTRY_parameter par -> par.parameter_type
        | ENTRY_variable var -> var.variable_type
        | _ -> TYPE_none
        )
        in match type_of_var with
            | TYPE_array (typ, size) ->
                (match (List.hd (fst $2)) with
                    |Expr expr ->
                        (
                            let result_temp = newTemporary TYPE_int
                            in let final_expr = match (fst $2) with
                                | h::[] ->
                                    Expr({
                                        code = Quad_array(Quad_entry(e), expr.place, result_temp)::expr.code;
                                        place = Quad_entry(result_temp)
                                    })
                                | h::t  ->
                                    let offset_quads_expr = handle_array type_of_var (List.tl (fst $2))
                                    in let temp = newTemporary TYPE_int
                                    in let first_offset_included =
                                        {
                                            code = Quad_calc("+", expr.place, offset_quads_expr.place, Quad_entry(temp))::offset_quads_expr.code;
                                            place = Quad_entry(temp)
                                        }
                                    in ( Expr(
                                        {
                                            code = Quad_array(Quad_entry(e), Quad_entry(temp), result_temp)::(first_offset_included.code);
                                            place = Quad_entry(result_temp)
                                        }
                                    ))
                                | [] -> Expr(return_null())
                                    in final_expr
                        )
                    | Cond c -> Expr(return_null()) (*error here*)
                )
            | _ ->  (
                (error "Line:%d.%d: subscripted value is not an array"
            (pos.pos_lnum) (pos.pos_cnum - pos.pos_bol));
                  Expr({code=[];place=(Quad_entry (e))}) 
            )
}

expr_list : /*nothing*/ { ([], 0) }
	  | T_lbracket expr T_rbracket expr_list { ($2::(fst $4), (snd $4) + 1) }

call : T_name T_lparen T_rparen {  let e = lookupEntry  (id_make $1) LOOKUP_ALL_SCOPES true 
                                   in  Expr(handle_func_call e (rhs_start_pos 1) [])
                                 }
     | T_name T_lparen expr expressions T_rparen { let e = lookupEntry  (id_make $1) LOOKUP_ALL_SCOPES true 
                                                    in let get_place e = e.place
                                                    in let expr_list = handle_fun_mul_params $3 $4
                                                    in let expr_types = List.map get_type (List.map get_place expr_list) 
                                                    in if (check_function_params (get_param_list e) expr_types (rhs_start_pos 1))
                                                    then Expr(handle_func_call e (rhs_start_pos 1) expr_list)
                                                    else Expr(return_null())
                                                 }

expressions : /*nothing*/ { [] }
	    | T_comma expr expressions { 
            let sexpr = match $2 with
            | Expr exp -> Expr exp
            | Cond c -> 
                let temp = newTemporary TYPE_bool                                           
                in let quad_false = Quad_set(Quad_bool("false"), Quad_entry(temp))          
                in let quad_true = Quad_set(Quad_bool("true"), Quad_entry(temp))            
                in let new_quad = Quad_jump (ref (2)) in                                       
                List.iter (fun x -> x := !x + 2) c.q_false;                                 
                Expr{                                                                           
                    code = quad_false :: (new_quad::(quad_true :: c.c_code));               
                    place = Quad_entry(temp)                                                
                }
                in
            sexpr::$3 }

block : T_lbrace  inner_block T_rbrace { $2 }

inner_block : /*nothing*/ { return_null_stmt () }

	    | local_def inner_block { handle_stmt_merge $1 $2 }
	    | stmt inner_block {  handle_stmt_merge $1 $2 }

local_def : const_def { return_null_stmt() }
	  | var_def { $1 }

stmt : T_semicolon { return_null_stmt () }
     | l_value assign expr T_semicolon { if (check_assign $2 $1 $3 (rhs_start_pos 1)) then
                                            handle_assignment $2 (dereference $1) $3 (get_binop_pos())
                                         else return_null_stmt()
                                        }
     | l_value T_plus_plus T_semicolon{ if (check_assign "+=" $1 $1 (rhs_start_pos 1)) then
                                           handle_plus_plus $1 
                                        else return_null_stmt()
                                       }
     | l_value T_minus_minus T_semicolon { if (check_assign "-=" $1 $1 (rhs_start_pos 1)) then
                                             handle_minus_minus $1
                                           else return_null_stmt()
                                          }
     | call T_semicolon { handle_expr_to_stmt $1 }
     | T_if T_lparen expr T_rparen stmt T_else stmt { if (check_is_bool $3 (rhs_start_pos 1)) 
                                                        then handle_if_else_stmt $3 $5 $7 
                                                      else return_null_stmt() 
                                                     }
     | T_if T_lparen expr T_rparen stmt { if (check_is_bool $3 (rhs_start_pos 1)) 
                                            then handle_if_stmt $3 $5 
                                          else return_null_stmt() 
                                         }
     | T_while stoppable T_lparen expr T_rparen stmt { if (check_is_bool $4 (rhs_start_pos 1)) 
                                                        then (
                                                            in_loop := !in_loop -1;
                                                            handle_while_stmt $4 $6
                                                        ) else return_null_stmt() 
                                                      }
            | T_FOR stoppable T_lparen T_name T_comma range T_rparen stmt { in_loop := !in_loop - 1 ; 
                                                                    let e = lookupEntry (id_make $4) LOOKUP_ALL_SCOPES true in 
                                                                        handle_for_stmt (Expr({code=[];place=(Quad_entry (e))})) $6 $8 (get_binop_pos())
                                                                        }
     | T_do stoppable stmt T_while T_lparen expr T_rparen T_semicolon { if (check_is_bool $6 (rhs_start_pos 1)) 
                                                                            then ( 
                                                                                in_loop:= !in_loop - 1;
                                                                                handle_do_while_stmt $3 $6
                                                                            )
                                                                        else return_null_stmt() 
                                                                       }
     | T_switch stoppable T_lparen expr T_rparen T_lbrace inner_switch T_default T_colon clause T_rbrace { in_loop := !in_loop - 1 ; handle_switch_default $4 $7 $10}
     | T_switch stoppable T_lparen expr T_rparen T_lbrace inner_switch T_rbrace { in_loop := !in_loop - 1; handle_switch $4 $7 }
     | T_break T_semicolon { ignore(if (!in_loop <= 0) then print_error "break not in loop" (rhs_start_pos 1)); handle_break() }
     | T_continue T_semicolon { ignore(if (!in_loop <= 0) then print_error "continue not in loop" (rhs_start_pos 1)); handle_continue() }
     | T_return T_semicolon {ignore(check_return !in_func (rhs_start_pos 1) ); did_return := true ;{s_code = handle_return_proc (rhs_start_pos 1); q_cont=[]; q_break=[]} }
     | T_return expr T_semicolon {  did_return := true ;
                                    let expr = (
                                        match (condition_to_expr $2) with
                                            |Expr e -> e
                                            |_ -> error "Not an expression";raise Terminate 
                                    ) in 
                                    let ret_code = handle_return_expr expr (rhs_start_pos 1) in
                                    {s_code = ret_code ; q_cont=[]; q_break=[]}
                                }
     | openScope block closeScope { $2 }
     | write T_lparen T_rparen T_semicolon { handle_write  $1 ([]) }
     | write T_lparen pformat pformat_list T_rparen T_semicolon { handle_write  $1 ($3::$4) }

stoppable : {in_loop := !in_loop + 1}

assign : T_eq { $1 }
       | T_plus_equal { $1 }
       | T_minus_equal { $1 }
       | T_mod_equal { $1 }
       | T_div_equal { $1 }
       | T_times_equal { $1 }

range : expr T_TO expr { ($1, $3, Expr({ code=[]; place= Quad_int ("1")}), "+") }
      | expr T_TO expr T_STEP expr { ($1, $3, $5, "+") }
      | expr T_DOWNTO expr { ($1, $3, Expr({ code=[]; place= Quad_int ("1")}), "-") }
      | expr T_DOWNTO expr T_STEP expr { ($1, $3, $5, "-") }

stmt_list : /*nothing*/ { return_null_stmt() }
      | stmt_list T_break T_semicolon {
            let jump_ref = ref 1 in {s_code = (Quad_jump(jump_ref))::($1.s_code); q_cont = $1.q_cont; q_break =(jump_ref)::($1.q_break)  }}
      
      | stmt_list stmt { handle_stmt_merge $1 $2 }

clause : stmt_list T_break T_semicolon{
	    let jump_ref = ref 1 in {s_code = (Quad_jump(jump_ref))::($1.s_code); q_cont = $1.q_cont; q_break =(jump_ref)::($1.q_break)  }}
       | stmt_list T_NEXT T_semicolon {($1) }

inner_switch : /*nothing*/ { {cond_list=[]; code_list=[]; true_list=[]; false_list=[]} }
       | switch_exp clause inner_switch { handle_inner_switch $1 $2 $3 }

switch_exp : T_case const_expr T_colon  { {case_list=[get_const_val (condition_to_expr $2) (rhs_start_pos 1)]; jump_list=[ref 1]} }
       | T_case const_expr T_colon switch_exp { handle_switch_exp (get_const_val (condition_to_expr $2) (rhs_start_pos 1)) $4 }

pformat_list : /*nothing*/ { [] }
	     | T_comma pformat pformat_list { $2::$3 }

write : T_WRITE { ($1) }
      | T_WRITELN { ($1) }
      | T_WRITESP { ($1) }
      | T_WRITESPLN { ($1) }

pformat : expr { (condition_to_expr $1, Expr({ code=[]; place= Quad_int ("0")})) }
	| T_FORM T_lparen expr T_comma expr T_rparen { (condition_to_expr $3,condition_to_expr $5) }
