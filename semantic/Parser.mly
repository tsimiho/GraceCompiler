%{
  open Symbol
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

%%

program: func_def T_eof { $1 }

func_def: header local_def_list block {  }

local_def_list: /* nothing */              { fun _ -> () }
                | local_def local_def_list { fun _ -> begin $1 (); $2 () end }

header: T_fun T_id T_lparen fpar_def semi_fpar_def_list T_rparen T_colon ret_type {  }
        | T_fun T_id T_lparen T_rparen T_colon ret_type                           {  }

  semi_fpar_def_list: /* nothing */                           { fun _ -> [] }
                    | T_semicolon fpar_def semi_fpar_def_list { fun _ -> $2 () :: $3 () }

fpar_def: T_ref T_id comma_id_list T_colon fpar_type {  }
          |  T_id comma_id_list T_colon fpar_type    {  }

comma_id_list: /* nothing */                { fun _ -> [] }
               | T_comma T_id comma_id_list { fun _ -> $2 () :: $3 () }

data_type: T_int    { TY_int }
           | T_char { TY_char }

bracket_int_const_list: /* nothing */                                          {  }
                        | T_lbrack T_int_const T_rbrack bracket_int_const_list {  }

ret_type: data_type   { $1 }
          | T_nothing { $1 }

fpar_type: data_type T_lbrack T_rbrack bracket_int_const_list {  }
           | data_type bracket_int_const_list                 {  }

grace_type: data_type bracket_int_const_list {  }

local_def: func_def    {  }
           | func_decl {  }
           | var_def   {  }

func_decl: header T_semicolon {  }

var_def: T_var T_id comma_id_list T_colon grace_type T_semicolon {  }

stmt: T_semicolon                          { fun _ -> () }
      | l_value T_prod expr T_semicolon    {  }
      | block                              { $1 }
      | func_call T_semicolon              { $1 }
      | T_if cond T_then stmt              { fun _ -> if $2 () <> 0 then $4 () }
      | T_if cond T_then stmt T_else stmt  { fun _ -> if $2 () <> 0 then $4 () else $6 () }
      | T_while cond T_do stmt             { fun _ -> while $2 () do $4 () done }
      | T_return T_semicolon               {  }
      | T_return expr T_semicolon          {  }


block: T_lbrace stmt_list T_rbrace { fun _ -> $2 () }

stmt_list: /* nothing */    { fun _ -> () }
           | stmt stmt_list { fun _ -> begin $1 (); $2 () end }

func_call: T_id T_lparen T_rparen                        {  }
           | T_id T_lparen expr comma_expr_list T_rparen {  }

comma_expr_list: /* nothing */                  { fun _ -> [] }
                 | T_comma expr comma_expr_list { fun _ -> $2 () :: $3 () }

l_value: T_id                             {  }
         | T_string_literal               {  }
         | l_value T_lbrack expr T_rbrack {  }

expr: T_int_const               { fun _ -> $1 }
      | T_char_const            { fun _ -> $1 }
      | l_value                 { fun _ -> $1 () }
      | T_lparen expr T_rparen  { $2 }
      | func_call               { fun _ -> $1 () }
      | T_plus expr             { fun _ -> + $1 () }
      | T_minus expr            { fun _ -> - $1 () }
      | expr T_plus expr        { fun _ -> $1 () + $2 () }
      | expr T_minus expr       { fun _ -> $1 () - $2 () }
      | expr T_times expr       { fun _ -> $1 () * $2 () }
      | expr T_div expr         { fun _ -> $1 () / $2 () }
      | expr T_mod expr         { fun _ -> $1 () mod $2 () }

cond: T_lparen cond T_rparen    { $2 }
      | T_not cond              { fun _ -> not $2 }
      | cond T_and cond         { fun _ -> $1 () && $3 () }
      | cond T_or cond          { fun _ -> $1 () || $3 () }
      | expr T_eq expr          { fun _ -> $1 () = $3 () }
      | expr T_hash expr        { fun _ -> $1 () <> $3 () }
      | expr T_less expr        { fun _ -> $1 () < $3 () }
      | expr T_more expr        { fun _ -> $1 () > $3 () }
      | expr T_leq expr         { fun _ -> $1 () <= $3 () }
      | expr T_geq expr         { fun _ -> $1 () >= $3 () }
