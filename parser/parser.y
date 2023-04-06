%{
#include <cstdio>
#include "lexer.hpp"
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
%token T_prod    "<-"
%token T_id
%token T_const

%left '+' '-'
%left '*' '/' T_div T_mod

%expect 1

%%

program:
  func-def
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
;

semi-fpar-def-list:
  /* nothing */
| semi-fpar-def-list ';' fpar-def
;

fpar-def:
  "ref" T_id comma-id-list ':' fpar-type
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
| bracket-int-const-list '[' T_int ']'
;

ret-type:
  data-type
| "nothing"
;

fpar-type:
  data-type
| '[' ']'
| bracket-int-const-list
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
  ';'
| l-value "<-" expr ';'
| block
| func-call ';'
| "if" cond "then" stmt
| "if" cond "then" stmt "else" stmt
| "while" cond "do" stmt
| "return" ';'
| "return" expr ';'
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
| comma-expr-list ';' expr
;

l-value:
  T_id
| T_const
| l-value '[' expr ']'
;

expr:
  T_int
| T_char
| l-value
| '(' expr ')'
| func-call
| '+' expr
| '-' expr
| expr '+' expr
| expr '-' expr
| expr '*' expr
| expr "div" expr
| expr "mod" expr
;

cond:
  '(' cond ')'
| "not" cond
| cond "and" cond
| cond "or" cond
| expr '=' expr
| expr '#' expr
| expr '<' expr
| expr '>' expr
| expr ">=" expr
| expr "<=" expr
;

%%

int main() {
  int result = yyparse();
  if (result == 0) printf("Success.\n");
  return result;
}
