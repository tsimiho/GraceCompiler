%option noyywrap
%{
#include <cstdio>
#include <cstdlib>
#include "ast.hpp"
#include "lexer.hpp"
#include "parser.hpp"

#define T_eof   0

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
"<-"      { return T_prod; }
"<="      { return T_leq; }
">="      { return T_geq; }

[\=\+\-\*\(\)\#\<\>\[\]\{\}\,\;\:] { yylval.op = yytext[0]; return yytext[0]; }


{L}({L}|{D}|\_)*	{ yylval.var = yytext; return T_id; }
{D}+	{ yylval.num = atoi(yytext); return T_int_const; }
\x{D}{D} { yylval.var = yytext; return T_char_const; }
\'({L}|{D}|\\{W}|\\{E}|(\\0)|(\\n)|(\\x{D}({D}|{L})))\' { yylval.var = yytext[0]; return T_char_const; }
\"({E}|(\\\0)|(\\x{D}({D}|{L}))|[^\'\"\\\n])*\" { yylval.var = yytext; return T_string_literal; }


\n	{ ++lineno; }
{W}+	{ /* return nothing */ }
\$[^\n\$]*\n? { ++lineno; }

"$$"          { BEGIN(COMMENT); }
<COMMENT>.|\n { if (*yytext == '\n') lineno++; }
<COMMENT>"$$" { BEGIN(INITIAL); }

.	{ fprintf(stderr, "Illegal character %c at line %d\n", yytext[0], lineno); exit(42); }

%%

void yyerror(const char *msg) {
  fprintf(stderr, "%s on line %d\n", msg, lineno);
  exit(1);
}
