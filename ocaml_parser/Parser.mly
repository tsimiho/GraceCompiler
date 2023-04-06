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
%token T_const
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

%left T_plus T_minus
%left T_times

%start program
%type <unit> program
%type <unit> stmt_list
%type <unit> stmt
%type <unit> expr

%%

program: stmt_list T_eof { () }

stmt_list: /* nothing */ { () }
          | stmt stmt_list { () }

stmt: T_print expr { () }
      | T_let T_var T_eq expr { () }
  	  | T_for expr T_do stmt { () }
	  | T_begin stmt_list T_end { () }
	  | T_if expr T_then stmt { () }

expr: T_const { () }
      | T_var { () }
	  | T_lparen expr T_rparen { () }
	  | expr T_plus expr { () }
	  | expr T_minus expr { () }
	  | expr T_times expr { () }
