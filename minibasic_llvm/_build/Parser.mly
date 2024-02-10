%{
open Ast
%}

%token T_print
%token T_let
%token T_for
%token T_do
%token T_begin
%token T_end
%token T_if
%token T_then

%token<int> T_const
%token<char> T_var

%token T_eq
%token T_rparen
%token T_lparen
%token T_plus
%token T_minus
%token T_times

%token T_eof

%left T_plus T_minus
%left T_times

%start program
%type <Ast.ast_stmt list> program
%type <ast_stmt list> stmt_list
%type <ast_stmt> stmt
%type <ast_expr> expr

%%

program   : stmt_list T_eof { $1 }

stmt_list : /* nothing */ { [] }
          | stmt stmt_list { $1 :: $2 }

stmt      : T_print expr { S_print $2 }
          | T_let T_var T_eq expr { S_let ($2, $4) }
  	  | T_for expr T_do stmt { S_for ($2, $4) }
	  | T_begin stmt_list T_end { S_block $2 }
	  | T_if expr T_then stmt { S_if ($2, $4) }

expr      : T_const { E_const $1 }
          | T_var { E_var $1 }
	  | T_lparen expr T_rparen { $2 }
	  | expr T_plus expr { E_op ($1, O_plus, $3) }
	  | expr T_minus expr { E_op ($1, O_minus, $3) }
	  | expr T_times expr { E_op ($1, O_times, $3) }

