%{
#define T_eof   0
#define T_begin 1000
#define T_do    1001
#define T_else  1002
#define T_end   1003
#define T_for   1004
#define T_if    1005
#define T_let   1006
#define T_print 1007
#define T_then  1008

#define T_id    1010
#define T_const 1011

int lineno = 1;
%}

L [a-z]
D [0-9]
W [ \t\r]

%option noyywrap

%%

"begin"	{ return T_begin; }
"do"	{ return T_do; }
"else"	{ return T_else; }
"end"	{ return T_end; }
"for"	{ return T_for; }
"if"	{ return T_if; }
"let"	{ return T_let; }
"print"	{ return T_print; }
"then"	{ return T_then; }

[\=\+\-\*\/\%\(\)] { return yytext[0]; }

{L}	{ return T_id; }
{D}+	{ return T_const; }

\n	{ ++lineno; }
{W}+	{ /* return nothing */ }
'.*\n	{ ++lineno; }

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