%{
#define T_eof     0
#define T_and     1000
#define T_char    1001
#define T_div     1002
#define T_do      1003
#define T_else    1004
#define T_fun     1005
#define T_if      1006
#define T_int     1007
#define T_mod     1008
#define T_not     1009
#define T_nothing 1010
#define T_or      1011
#define T_ref     1012
#define T_return  1013
#define T_then    1014
#define T_var     1015
#define T_while   1016
#define T_prod    1017

#define T_id      1018
#define T_char_const   1019
#define T_string_literal   1020
#define T_int_const   1021


int lineno = 1;
%}

L [A-Za-z]
D [0-9]
W [ \t\r]
E \\[\\\'\"]

%x COMMENT

%option noyywrap

%%

"and"     { return T_and; }
"char"	  { return T_char; }
"div"     { return T_div; }
"do"      { return T_do; }
"else"	  { return T_else; }
"fun"     { return T_fun; }
"if"      { return T_if; }
"int"     { return T_int; }
"mod"     { return T_mod; }
"not"     { return T_not; }
"nothing" { return T_nothing; }
"or"      { return T_or; }
"ref"     { return T_ref; }
"return"  { return T_return; }
"then"    { return T_then; }
"var"     { return T_var; }
"while"   { return T_while; }
"<-"      { return T_prod; }

[\=\+\-\*\(\)\#\<\>\[\]\{\}\,\;\:] { return yytext[0]; }


{L}({L}|{D}|\_)*	{ return T_id; }
{D}+	{ return T_int_const; }
\x{D}{D} {return T_char_const; }
\'({L}|{D}|{W}|{E}|(\\0)|(\\x{D}({D}|{L}))|(\\n)|(\\'))\' { return T_char_const; }
\"({E}|(\\\0)|(\\.)|(\\x{D}({D}|{L}))|[^\'\"\\\n])*\" { return T_string_literal; }


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
