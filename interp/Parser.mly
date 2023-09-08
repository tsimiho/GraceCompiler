%{
  open Symbol

  let param = { 
    id: string; 
    mode: pass_mode; 
    param_type: typ 
  }
 
  let registerHeader id params return_type = 
    let fun_entry = newFunction id true in
    openScope();
    match params with
    | [] -> ()
    | _  -> List.iter ( fun param ->
                          newParameter param.id param.param_type param.mode id true
                      ) params;
    fun_entry.function_result <- return_type
    closeScope();
    endFunctionHeader fun_entry return_type

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
%token T_id
%token T_int_const
%token T_char_const
%token T_string_literal
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
%type <unit -> unit> header
%type <unit -> 'a list> semi_fpar_def_list
%type <unit -> unit> fpar_def
%type <unit -> 'a list> comma_id_list
%type <unit -> typ> data_type
%type <unit -> 'a list> bracket_int_const_list
%type <unit -> typ> ret_type
%type <unit -> typ> fpar_type
%type <unit -> typ> grace_type
%type <unit> local_def
%type <unit> func_decl
%type <unit -> unit> var_def
%type <unit -> unit> stmt
%type <unit> block
%type <unit -> unit> stmt_list
%type <unit -> 'a> func_call
%type <unit -> 'a list> comma_expr_list
%type <unit -> ('a * 'b list)> lvalue
%type <unit -> 'a> expr
%type <unit -> bool> cond


%%

program: func_def T_eof { $1 }

func_def: header local_def_list block { fun _ -> begin $1 (); $2 (); $3 () end }

local_def_list: /* nothing */            { fun _ -> () }
              | local_def local_def_list { fun _ -> begin $1 (); $2 () end }

header: T_fun T_id T_lparen fpar_def semi_fpar_def_list T_rparen T_colon ret_type { fun _ -> let id = $2 in
                                                                                             let params = $4 () :: $5 () in
                                                                                             let return_type = $7 () in 
                                                                                             registerHeader id params return_type
                                                                                  }
      | T_fun T_id T_lparen T_rparen T_colon ret_type                             { fun _ -> let id = $2 in
                                                                                             let params = [] in
                                                                                             let return_type = $7 () in 
                                                                                             registerHeader id params return_type
                                                                                  } 

semi_fpar_def_list: /* nothing */                           { fun _ -> [] }
                  | T_semicolon fpar_def semi_fpar_def_list { fun _ -> $2 () :: $3 () }

fpar_def: T_ref T_id comma_id_list T_colon fpar_type { fun _ -> let params = $2 :: $3 () in
                                                                let param_type = $5 () in
                                                                List.map (fun name -> { id = name; mode = PASS_BY_REFERENCE ; param_type = param_type }) params            
                                                     }
        | T_id comma_id_list T_colon fpar_type       { fun _ -> let params = $1 :: $2 () in
                                                                let param_type = $4 () in
                                                                List.map (fun name -> { id = name; mode = PASS_BY_VALUE; param_type = param_type }) params            
                                                     }

comma_id_list: /* nothing */              { fun _ -> [] }
             | T_comma T_id comma_id_list { fun _ -> $2 :: $3 () }

data_type: T_int  { fun _ -> TYPE_int }
         | T_char { fun _ -> TYPE_char }

bracket_int_const_list: /* nothing */                                        { fun _ -> [] }
                      | T_lbrack T_int_const T_rbrack bracket_int_const_list { fun _ -> $2 :: $4 () }

ret_type: data_type { fun _ -> $1 () }
        | T_nothing { fun _ -> TYPE_none }

fpar_type: data_type T_lbrack T_rbrack bracket_int_const_list { fun _ -> let base_type = $1 () in
                                                                         let dimensions = max_int :: $4 () in
                                                                         let arr = List.fold_right (fun size acc -> TYPE_array (acc, size)) dimensions base_type in
                                                                         arr
                                                              } 
         | data_type bracket_int_const_list                   { fun _ -> let base_type = $1 () in
                                                                         let dimensions = $2 () in
                                                                         let arr = List.fold_right (fun size acc -> TYPE_array (acc, size)) dimensions base_type in
                                                                         arr
                                                              }

grace_type: data_type bracket_int_const_list { fun _ -> let base_type = $1 () in
                                                        let dimensions = $2 () in
                                                        let arr = List.fold_right (fun size acc -> TYPE_array (acc, size)) dimensions base_type in
                                                        arr
                                             }

local_def: func_def  { $1 }
         | func_decl { $1 }
         | var_def   { $1 }

func_decl: header T_semicolon { $1 }

var_def: T_var T_id comma_id_list T_colon grace_type T_semicolon { fun _ -> let vars = $2 :: $3 () in
                                                                            let var_type = $5 () in
                                                                            List.iter ( fun var -> newVariable var var_type true ) vars
                                                                 }

stmt: T_semicolon                       { fun _ -> () }
    | l_value T_prod expr T_semicolon   { fun _ -> let (id,l) = $1 () in
                                                   let val = $2 () in
                                                   assignToVariable id l val
                                        }
    | block                             { $1 }
    | func_call T_semicolon             { $1 }
    | T_if cond T_then stmt             { fun _ -> if $2 () <> 0 then $4 () }
    | T_if cond T_then stmt T_else stmt { fun _ -> if $2 () <> 0 then $4 () else $6 () }
    | T_while cond T_do stmt            { fun _ -> while $2 () do $4 () done }
    | T_return T_semicolon              {  }
    | T_return expr T_semicolon         {  }


block: T_lbrace stmt_list T_rbrace { $2 }

stmt_list: /* nothing */  { fun _ -> () }
         | stmt stmt_list { fun _ -> begin $1 (); $2 () end }

func_call: T_id T_lparen T_rparen                      {  }
         | T_id T_lparen expr comma_expr_list T_rparen {  }

comma_expr_list: /* nothing */                { fun _ -> [] }
               | T_comma expr comma_expr_list { fun _ -> $2 () :: $3 () }

l_value: T_id                           { fun _ -> ($1,[]) }
       | T_string_literal               { fun _ -> ($1,[]) }
       | l_value T_lbrack expr T_rbrack { fun _ -> let (val, l) = $1 () in
                                                   let exp = $3 () in
                                                   (val, exp :: l)
                                        }

expr: T_int_const            { fun _ -> $1 }
    | T_char_const           { fun _ -> $1 }
    | l_value                { fun _ -> $1 () }
    | T_lparen expr T_rparen { $2 }
    | func_call              { fun _ -> $1 () }
    | T_plus expr            { fun _ -> + $1 () }
    | T_minus expr           { fun _ -> - $1 () }
    | expr T_plus expr       { fun _ -> $1 () + $2 () }
    | expr T_minus expr      { fun _ -> $1 () - $2 () }
    | expr T_times expr      { fun _ -> $1 () * $2 () }
    | expr T_div expr        { fun _ -> $1 () / $2 () }
    | expr T_mod expr        { fun _ -> $1 () mod $2 () }

cond: T_lparen cond T_rparen { $2 }
    | T_not cond             { fun _ -> not $2 () }
    | cond T_and cond        { fun _ -> $1 () && $3 () }
    | cond T_or cond         { fun _ -> $1 () || $3 () }
    | expr T_eq expr         { fun _ -> $1 () = $3 () }
    | expr T_hash expr       { fun _ -> $1 () <> $3 () }
    | expr T_less expr       { fun _ -> $1 () < $3 () }
    | expr T_more expr       { fun _ -> $1 () > $3 () }
    | expr T_leq expr        { fun _ -> $1 () <= $3 () }
    | expr T_geq expr        { fun _ -> $1 () >= $3 () }
