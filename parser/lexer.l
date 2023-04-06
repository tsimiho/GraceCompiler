%option noyywrap

%{
#include <cstdio>
#include <cstdlib>
#include "lexer.hpp"
#include "parser.hpp"

int lineno = 1;
%}

L [A-Za-z]
D [0-9]
W [ \t\r]
E [\\\'\"]

%x COMMENT

%%

"and"	    { return T_and; }
"char"	  { return T_char; }
"div"	    { return T_div; }
"do"	    { return T_do; }
"else"	  { return T_else; }
"fun"	    { return T_fun; }
"if"	    { return T_if; }
"int"	    { return T_int; }
"mod"	    { return T_mod; }
"not"     { return T_not; }
"nothing" { return T_nothing; }
"or"      { return T_or; }
"ref"     { return T_ref; }
"return"  { return T_return; }
"then"    { return T_then; }
"var"     { return T_var; }
"while"   { return T_while; }
"<-"      { return T_prod }

[\=\+\-\*\(\)\#\<\>\[\]\{\}\,\;\:] { return yytext[0]; }


{L}({L}|{D}|\_)*	{ return T_id; }
{D}+	{ return T_const; }
\x{D}{D} {return T_const; }
\'({L}|{D}|{W}|{E}|(\\0)|(\\x{D}({D}|{L})))\' { return T_const; }
\"({E}|(\\\0)|(\\x{D}({D}|{L}))|[^\'\"\\\n])*\" { return T_const; }


\n	{ ++lineno; }
{W}+	{ /* return nothing */ }
\$[^\n\$]*\n? { ++lineno; }

"$$"          { BEGIN(COMMENT); }
<COMMENT>.|\n { if (*yytext == '\n') lineno++; }
<COMMENT>"$$" { BEGIN(INITIAL); }

.	{ fprintf(stderr, "Illegal character %c at line %d\n", yytext[0], lineno); exit(42); }

%%

int main() {
  int token;
  do {
    token = yylex();
    printf("token = %d, lexeme = \"%s\"\n", token, yytext);
  } while(token != T_eof);
  return 0;
}
