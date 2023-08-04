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
%token T_var
%token T_int
%token T_bool

%token<int> T_const
%token<char> T_id

%token T_eq
%token T_rparen
%token T_lparen
%token T_plus
%token T_minus
%token T_times
%token T_colon

%token T_eof

%left T_plus T_minus
%left T_times

%start program
%type <Ast.ast_block> program
%type <ast_block> block
%type <typ> type
%type <ast_decl> decl
%type <ast_decl list> decl_list
%type <ast_stmt list> stmt_list
%type <ast_stmt> stmt
%type <ast_expr> expr

%%

program   : block T_eof { $1 }

block     : decl_list stmt_list { Block ($1, $2) }

decl_list : /* nothing */ { [] }
          | decl decl_list { $1 :: $2 }

decl      : T_var T_id T_colon type { Decl ($2, ref (-1), $4) }

type      : T_int { TY_int }
          | T_bool { TY_bool }

stmt_list : /* nothing */ { [] }
          | stmt stmt_list { $1 :: $2 }

stmt      : T_print expr { S_print $2 }
          | T_let T_id T_eq expr { S_let ($2, ref (-1), $4) }
  	      | T_for expr T_do stmt { S_for ($2, $4) }
	        | T_begin block T_end { S_block $2 }
	        | T_if expr T_then stmt { S_if ($2, $4) }

expr      : T_const { E_const $1 }
          | T_id { E_var ($1, ref (-1)) }
      	  | T_lparen expr T_rparen { $2 }
      	  | expr T_plus expr { E_op ($1, O_plus, $3) }
      	  | expr T_minus expr { E_op ($1, O_minus, $3) }
      	  | expr T_times expr { E_op ($1, O_times, $3) }
