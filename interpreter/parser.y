%define parse.error verbose

%{
#include <cstdio>
#include <iostream>
#include <string>
#include "lexer.hpp"
#include "ast.hpp"

SymbolTable st;
std::vector<int> rt_stack;
%}

%token T_and     "and"
%token T_char    "char"
%token T_div     "div"
%token T_do      "do"
%token T_else    "else"
%token T_fun     "fun"
%token T_if      "if"
%token T_int     "int"
%token T_mod     "mod"
%token T_not     "not"
%token T_nothing "nothing"
%token T_or      "or"
%token T_ref     "ref"
%token T_return  "return"
%token T_then    "then"
%token T_var     "var"
%token T_while   "while"
%token T_leq     "<="
%token T_geq     ">="
%token T_prod    "<-"
%token T_id
%token T_int_const
%token T_char_const
%token T_string_literal


%left T_or
%left T_and
%nonassoc T_not
%left '*' '/' T_div T_mod
%left '+' '-'

%expect 1

%union {
  Block *block;
  Stmt *stmt;
  Expr *expr;
  std::string var;
  int num;
  char op;
}

/* %type<block> program stmt_list
%type<stmt>  stmt
%type<expr>  expr */

%%

program:
  func-def /* { $1->run(); } */
;

func-def:
  header local-def-list block
;

local-def-list:
  /* nothing */
| local-def-list local-def
;

header:
  "fun" T_id '(' fpar-def semi-fpar-def-list ')' ':' ret-type
| "fun" T_id '(' ')' ':' ret-type
;

semi-fpar-def-list:
  /* nothing */
| ';' fpar-def semi-fpar-def-list
;

fpar-def:
  "ref" T_id comma-id-list ':' fpar-type
|  T_id comma-id-list ':' fpar-type
;

comma-id-list:
  /* nothing */
| comma-id-list ',' T_id
;

data-type:
  "int"
| "char"
;

bracket-int-const-list:
  /* nothing */
| '[' T_int_const ']' bracket-int-const-list
;

ret-type:
  data-type
| "nothing"
;

fpar-type:
  data-type '[' ']' bracket-int-const-list
| data-type bracket-int-const-list
;

type:
  data-type bracket-int-const-list
;

local-def:
  func-def
| func-decl
| var-def
;

func-decl:
  header ';'
;

var-def:
  "var" T_id comma-id-list ':' type ';'
;

stmt:
';'                                  { /* $$ = nullptr */ }
| l-value "<-" expr ';'              { $$ = new Assign($1, $3); }
| block
| func-call ';'
| "if" cond "then" stmt              { $$ = new If($2, $4); }
| "if" cond "then" stmt "else" stmt  { $$ = new If($2, $4, $6); }
| "while" cond "do" stmt             { $$ = new While($2, $4); }
| "return" ';'                       { $$ = new Return(); }
| "return" expr ';'                  { $$ = new Return($2); }
;

block:
  '{' stmt-list '}'
;

stmt-list:
  /* nothing */
| stmt-list stmt
;

func-call:
  T_id '(' ')'
| T_id '(' expr comma-expr-list ')'
;

comma-expr-list:
  /* nothing */
| comma-expr-list ',' expr
;

l-value:
  T_id
| T_string_literal
| l-value '[' expr ']'
;

expr:
  T_int_const     { $$ = new IntConst($1); }
| T_char_const    { $$ = new CharConst($1); }
| l-value
| '(' expr ')'    { $$ = $2; }
| func-call
| '+' expr
| '-' expr
| expr '+' expr   { $$ = new BinOp($1, $2, $3); }
| expr '-' expr   { $$ = new BinOp($1, $2, $3); }
| expr '*' expr   { $$ = new BinOp($1, $2, $3); }
| expr "div" expr { $$ = new BinOp($1, $2, $3); }
| expr "mod" expr { $$ = new BinOp($1, $2, $3); }
;

cond:
  '(' cond ')'     { $$ = $2 }
| "not" cond
| cond "and" cond
| cond "or" cond
| expr '=' expr    { $$ = new Cond($1, $2, $3); }
| expr '#' expr    { $$ = new Cond($1, $2, $3); }
| expr '<' expr    { $$ = new Cond($1, $2, $3); }
| expr '>' expr    { $$ = new Cond($1, $2, $3); }
| expr "<=" expr   { $$ = new Cond($1, $2, $3); }
| expr ">=" expr   { $$ = new Cond($1, $2, $3); }
;

%%

int main() {
  int result = yyparse();
  if (result == 0) printf("Success.\n");
  return result;
}
