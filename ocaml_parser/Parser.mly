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
%left T_times T_div T_mod
%left T_plus T_minus


%start program
%type <unit> program

%%

program: func_def T_eof { () }

func_def: header local_def_list block { () }

local_def_list: /* nothing */ { () }
                | local_def local_def_list { () }

header: T_fun T_id T_lparen fpar_def semi_fpar_def_list T_rparen T_colon ret_type { () }
        | T_fun T_id T_lparen T_rparen T_colon ret_type { () }

semi_fpar_def_list: /* nothing */ { () }
                    | T_semicolon fpar_def semi_fpar_def_list { () }

fpar_def: T_ref T_id comma_id_list T_colon fpar_type { () }
          |  T_id comma_id_list T_colon fpar_type { () }

comma_id_list: /* nothing */ { () }
               | T_comma T_id comma_id_list { () }

data_type: T_int { () }
           | T_char { () }

bracket_int_const_list: /* nothing */ { () }
                        | T_lbrack T_int_const T_rbrack bracket_int_const_list { () }

ret_type: data_type { () }
          | T_nothing { () }

fpar_type: data_type T_lbrack T_rbrack bracket_int_const_list { () }
           | data_type bracket_int_const_list { () }

grace_type: data_type bracket_int_const_list { () }

local_def: func_def { () }
           | func_decl { () }
           | var_def { () }

func_decl: header T_semicolon { () }

var_def: T_var T_id comma_id_list T_colon grace_type T_semicolon { () }

stmt: T_semicolon                                  { () }
      | l_value T_prod expr T_semicolon              { () }
      | block                              { () }
      | func_call T_semicolon                      { () }
      | T_if cond T_then stmt              { () }
      | T_if cond T_then stmt T_else stmt  { () }
      | T_while cond T_do stmt             { () }
      | T_return T_semicolon                       { () }
      | T_return expr T_semicolon                  { () }


block: T_lbrace stmt_list T_rbrace { () }

stmt_list: /* nothing */ { () }
           | stmt stmt_list { () }

func_call: T_id T_lparen T_rparen { () }
           | T_id T_lparen expr comma_expr_list T_rparen { () }

comma_expr_list: /* nothing */ { () }
                 | T_comma expr comma_expr_list { () }

l_value: T_id { () }
         | T_string_literal { () }
         | l_value T_lbrack expr T_rbrack { () }

expr: T_int_const     { () }
      | T_char_const    { () }
      | l_value { () }
      | T_lparen expr T_rparen    { () }
      | func_call { () }
      | T_plus expr { () }
      | T_minus expr { () }
      | expr T_plus expr   { () }
      | expr T_minus expr   { () }
      | expr T_times expr   { () }
      | expr T_div expr { () }
      | expr T_mod expr { () }

cond: T_lparen cond T_rparen     { () }
      | T_not cond { () }
      | cond T_and cond { () }
      | cond T_or cond { () }
      | expr T_eq expr    { () }
      | expr T_hash expr    { () }
      | expr T_less expr    { () }
      | expr T_more expr    { () }
      | expr T_leq expr   { () }
      | expr T_geq expr   { () }
