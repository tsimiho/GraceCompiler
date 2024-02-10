%{
  open Symbol
  open Types
  open Identifier
  open Error
  open Narray

  initSymbolTable 1000;

  type param = { 
    id: Identifier.id list; 
    mode: pass_mode; 
    param_type: typ 
  }

  and param_mode = PASS_BY_VALUE | PASS_BY_REFERENCE

  let registerHeader id params return_type = 
    let fun_entry = newFunction id true in
    (* openScope(); *)
    List.iter ( fun p -> 
                  List.iter ( fun single_id -> 
                                ignore (newParameter single_id p.param_type p.mode fun_entry true) 
                            ) p.id
              ) params;
    match fun_entry.entry_info with
    | ENTRY_function func_info ->
        func_info.function_result <- return_type;
    | _ -> error "Expected a function entry %a" pretty_id id;
    endFunctionHeader fun_entry return_type

  let callFunction id args =
    let func_entry = lookupEntry id LOOKUP_ALL_SCOPES true in
    match func_entry.entry_info with
    | ENTRY_function inf -> if inf.function_isForward then
                              let rec linkParams func_params func_args = 
                                match func_params, func_args with
                                | fp::fps, fa::fas -> if fp.
                                | [], [] -> inf.function_body () 
                                | _, _ -> error "Function %a is called with the worng number of parameters" pretty_id id; None
                            else error "%a has not been implemented" pretty_id id; None
    | _ -> error "%a is not a function" pretty_id id; None


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
%type <unit -> Identifier.id option> func_def
%type <unit -> unit> local_def_list
%type <unit -> Identifier.id option> header
%type <unit -> param list> semi_fpar_def_list
%type <unit -> param> fpar_def
%type <unit -> Identifier.id list> comma_id_list
%type <unit -> typ> data_type
%type <unit -> int list> bracket_int_const_list
%type <unit -> typ> ret_type
%type <unit -> typ> fpar_type
%type <unit -> typ> grace_type
%type <unit -> Identifier.id option> local_def
%type <unit -> Identifier.id option> func_decl
%type <unit -> Identifier.id option> var_def
%type <unit -> variable_value option> stmt
%type <unit -> variable_value option> block
%type <unit -> variable_value option> stmt_list
%type <unit -> variable_value option> func_call
%type <unit -> variable_value list> comma_expr_list
%type <unit -> (string * int list)> l_value
%type <unit -> variable_value> expr
%type <unit -> bool> cond


%%

program: func_def T_eof { fun _ -> match $1 () with
                                   | Some id -> ignore(callFunction id [])
                                   | _ -> error "not a function"
                        }

func_def: header local_def_list block { fun _ -> begin 
                                          match $1 () with
                                          | Some func_name -> 
                                              $2 ();
                                              let func_body = $3 in
                                              let func_entry = lookupEntry func_name LOOKUP_ALL_SCOPES true in
                                              (match func_entry.entry_info with
                                              | ENTRY_function func_info -> func_info.function_body <- func_body; Some func_name
                                              | _ -> Some func_name)
                                          | None -> error "not a function"; None
                                        end
                                      }

local_def_list: /* nothing */            { fun _ -> () }
              | local_def local_def_list { fun _ -> begin ignore($1 ()); $2 () end }

header: T_fun T_id T_lparen fpar_def semi_fpar_def_list T_rparen T_colon ret_type { fun _ -> let id = (id_make $2) in
                                                                                             let params = $4 () :: $5 () in
                                                                                             let return_type = $8 () in 
                                                                                             registerHeader id params return_type;
                                                                                             Some id
                                                                                  }
      | T_fun T_id T_lparen T_rparen T_colon ret_type                             { fun _ -> let id = (id_make $2) in
                                                                                             let params = [] in
                                                                                             let return_type = $6 () in 
                                                                                             registerHeader id params return_type;
                                                                                             Some id
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
                                                        | _ -> TYPE_array (base_type, dimensions)
                                             }

local_def: func_def  { $1 }
         | func_decl { $1 }
         | var_def   { $1 }

func_decl: header T_semicolon { $1 }

var_def: T_var T_id comma_id_list T_colon grace_type T_semicolon { fun _ -> let vars = (id_make $2) :: $3 () in
                                                                            let var_type = $5 () in
                                                                            print_grace_type var_type;
                                                                            List.iter ( fun var -> ignore(newVariable var var_type true) ) vars; None
                                                                 }

stmt: T_semicolon                       { fun _ -> None }
    | l_value T_prod expr T_semicolon   { fun _ -> let (id,l) = $1 () in
                                                   let value = $3 () in
                                                   assignToVariable (id_make id) value;
                                                   None
                                        }
    | block                             { $1 }
    | func_call T_semicolon             { $1 }
    | T_if cond T_then stmt             { fun _ -> if $2 () then $4 () else None }
    | T_if cond T_then stmt T_else stmt { fun _ -> if $2 () then $4 () else $6 () }
    | T_while cond T_do stmt            { fun _ -> while $2 () do ignore($4 ()) done; None }
    | T_return T_semicolon              { fun _ -> None }
    | T_return expr T_semicolon         { fun _ -> Some($2 ()) }


block: T_lbrace stmt_list T_rbrace { $2 }

stmt_list: /* nothing */  { fun _ -> None }
         | stmt stmt_list { fun _ -> let result = $1 () in
                                     match result with
                                     | Some _ as returnValue -> returnValue
                                     | None -> $2 ()
      }

func_call: T_id T_lparen T_rparen                      { fun _ -> let func_name = $1 in
                                                                  match func_name with 
                                                                  | "writeInteger" -> print_string "WriteInteger"; None
                                                                  | "writeChar"    -> print_string "WriteChar"; None
                                                                  | "writeString"  -> print_string "WriteString"; None
                                                                  | "readInteger"  -> print_string "ReadInteger"; None
                                                                  | "readChar"     -> print_string "ReadChar"; None
                                                                  | "readString"   -> print_string "ReadString"; None
                                                                  | _ -> let func_entry = lookupEntry (id_make func_name) LOOKUP_ALL_SCOPES true in
                                                                         (match func_entry.entry_info with
                                                                         | ENTRY_function func_info ->
                                                                           if List.length func_info.function_paramlist = 0 then
                                                                             callFunction (id_make func_name) []
                                                                           else (error "Incorrect number of arguments for function %a" pretty_id (id_make func_name); None)
                                                                         | _ -> (error "%a is not a function" pretty_id (id_make func_name); None))
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
                                                                  | _ -> let func_entry = lookupEntry (id_make func_name) LOOKUP_ALL_SCOPES true in
                                                                         (match func_entry.entry_info with
                                                                         | ENTRY_function func_info ->
                                                                           if List.length func_info.function_paramlist = List.length args then
                                                                           callFunction (id_make func_name) args
                                                                         else
                                                                           (error "Incorrect number of arguments for function %a" pretty_id (id_make func_name); None)
                                                                         | _ -> (error "%a is not a function" pretty_id (id_make func_name); None))
                                                       }


comma_expr_list: /* nothing */                { fun _ -> [] }
               | T_comma expr comma_expr_list { fun _ -> $2 () :: $3 () }

l_value: T_id                           { fun _ -> ($1,[]) }
       | T_string_literal               { fun _ -> ($1,[]) }
       | l_value T_lbrack expr T_rbrack { fun _ -> let (value, l) = $1 () in
                                                   match $3 () with 
                                                   | IntValue exp -> (value, exp :: l)
                                                   | _ -> error "not an integer"; (value, [])
                                        }


expr: T_int_const            { fun _ -> IntValue $1 }
    | T_char_const           { fun _ -> CharValue $1 }
    | l_value                { fun _ -> let (value , l) = $1 () in
                                        MultiArray (createArray l)
                             }
    | T_lparen expr T_rparen { $2 }
    | func_call              { fun _ -> match $1 () with
                                        | Some value -> value
                                        | None -> Unit
                             }
    | T_plus expr            { fun _ -> match $2 () with 
                                        | IntValue num -> IntValue num
                                        | _ -> error "not an integer; +"; Unit
                             }
    | T_minus expr           { fun _ -> match $2 () with 
                                        | IntValue num -> IntValue (- num)
                                        | _ -> error "not an integer; -"; Unit
                             }    
    | expr T_plus expr       { fun _ -> match ($1 (), $3 ()) with
                                        | (IntValue a, IntValue b) -> IntValue (a + b)
                                        | _ -> error "not an integer; plus"; Unit
                             }
    | expr T_minus expr      { fun _ -> let val1 = $1 () in
                                        let val2 = $3 () in
                                        print_variable_value val1;
                                        print_variable_value val2;
                                        match (val1, val2) with
                                        | (IntValue a, IntValue b) -> IntValue (a - b)
                                        | (c, d) -> error "not an integer; minus"; Unit
                             }
    | expr T_times expr      { fun _ -> match ($1 (), $3 ()) with
                                        | (IntValue a, IntValue b) -> IntValue (a * b)
                                        | _ -> error "not an integer; times"; Unit
                             }
    | expr T_div expr        { fun _ -> match ($1 (), $3 ()) with
                                        | (IntValue a, IntValue b) -> IntValue (a / b)
                                        | _ -> error "not an integer; div"; Unit
                             }
    | expr T_mod expr        { fun _ -> match ($1 (), $3 ()) with
                                        | (IntValue a, IntValue b) -> IntValue (a mod b)
                                        | _ -> error "not an integer; mod"; Unit
                             }
 
cond: T_lparen cond T_rparen { $2 }
    | T_not cond             { fun _ -> not ($2 ()) }
    | cond T_and cond        { fun _ -> $1 () && $3 () }
    | cond T_or cond         { fun _ -> $1 () || $3 () }
    | expr T_eq expr         { fun _ -> $1 () = $3 () }
    | expr T_hash expr       { fun _ -> $1 () <> $3 () }
    | expr T_less expr       { fun _ -> $1 () < $3 () }
    | expr T_more expr       { fun _ -> $1 () > $3 () }
    | expr T_leq expr        { fun _ -> $1 () <= $3 () }
    | expr T_geq expr        { fun _ -> $1 () >= $3 () }
