%define parse.error verbose

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

%%

program: /* nothing */
         | func_def; 

func_def: header local_def_list block;

local_def_list: /* nothing */ 
                | local_def local_def_list
                ;

header: "fun" T_id '(' fpar_def semi_fpar_def_list ')' ':' ret_type 
        | "fun" T_id '(' ')' ':' ret_type 
        ;

semi_fpar_def_list: /* nothing */ 
                    | ';' fpar_def semi_fpar_def_list 
                    ;

fpar_def: "ref" T_id comma_id_list ':' fpar_type 
          |  T_id comma_id_list ':' fpar_type 
          ;

comma_id_list: /* nothing */ 
               | ',' T_id comma_id_list
               ;

data_type: "int" 
           | "char" 
           ;

bracket_int_const_list: /* nothing */ 
                        | '[' T_int_const ']' bracket_int_const_list
                        ;

ret_type: data_type 
          | "nothing"
          ;

fpar_type: data_type '[' ']' bracket_int_const_list 
           | data_type bracket_int_const_list
           ;

grace_type: data_type bracket_int_const_list; 

local_def: func_def 
           | func_decl 
           | var_def
           ;

func_decl: header ';'; 

var_def: T_var T_id comma_id_list ':' grace_type ';';

stmt: ';'                                  
      | l_value T_prod expr ';'              
      | block                              
      | func_call ';'                      
      | "if" cond "then" stmt              
      | "if" cond "then" stmt "else" stmt  
      | T_while cond "do" stmt             
      | "return" ';'                       
      | "return" expr ';'
      ;


block: '{' stmt_list '}'; 

stmt_list: /* nothing */ 
           | stmt stmt_list
           ;

func_call: T_id '(' ')' 
           | T_id '(' expr comma_expr_list ')'
           ;

comma_expr_list: /* nothing */ 
                 | ',' expr comma_expr_list
                 ;

l_value: T_id 
         | T_string_literal 
         | l_value '[' expr ']'
         ;

expr: T_int_const     
      | T_char_const    
      | l_value 
      | '(' expr ')'    
      | func_call 
      | '+' expr 
      | '-' expr 
      | expr '+' expr   
      | expr '-' expr   
      | expr '*' expr   
      | expr "div" expr 
      | expr "mod" expr
      ;

cond: '(' cond ')'     
      | T_not cond 
      | cond T_and cond 
      | cond T_or cond 
      | expr '=' expr    
      | expr '#' expr    
      | expr '<' expr    
      | expr '>' expr    
      | expr T_leq expr   
      | expr T_geq expr
      ;

%%

int main() {
  int result = yyparse();
  if (result == 0) printf("Success.\n");
  return result;
}
