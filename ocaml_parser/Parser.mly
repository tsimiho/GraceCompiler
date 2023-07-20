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

%left T_or
%left T_and
%nonassoc T_not
%left '*' '/' T_div T_mod
%left '+' '-'

%start program
%type <unit> program
%type <unit> stmt_list
%type <unit> stmt
%type <unit> expr

%%

program: func-def

func-def: header local-def-list block

local-def-list: /* nothing */
                | local-def-list local-def

header: "fun" T_id '(' fpar-def semi-fpar-def-list ')' ':' ret-type
        | "fun" T_id '(' ')' ':' ret-type

semi-fpar-def-list: /* nothing */
                    | ';' fpar-def semi-fpar-def-list

fpar-def: "ref" T_id comma-id-list ':' fpar-type
          |  T_id comma-id-list ':' fpar-type


comma-id-list: /* nothing */
               | comma-id-list ',' T_id

data-type: "int"
           | "char"

bracket-int-const-list: /* nothing */bin 
                        | '[' T_int_const ']' bracket-int-const-list

ret-type: data-type
          | "nothing"

fpar-type: data-type '[' ']' bracket-int-const-list
           | data-type bracket-int-const-list

type: data-type bracket-int-const-list

local-def: func-def
           | func-decl
           | var-def

func-decl: header ';'

var-def: "var" T_id comma-id-list ':' type ';'

stmt: ';'                                  { /* $$ = nullptr */ }
      | l-value "<-" expr ';'              { $$ = new Assign($1, $3); }
      | block
      | func-call ';'
      | "if" cond "then" stmt              { $$ = new If($2, $4); }
      | "if" cond "then" stmt "else" stmt  { $$ = new If($2, $4, $6); }
      | "while" cond "do" stmt             { $$ = new While($2, $4); }
      | "return" ';'                       { $$ = new Return(); }
      | "return" expr ';'                  { $$ = new Return($2); }


block: '{' stmt-list '}'

stmt-list: /* nothing */
           | stmt-list stmt

func-call: T_id '(' ')'
           | T_id '(' expr comma-expr-list ')'

comma-expr-list: /* nothing */
                 | comma-expr-list ',' expr

l-value: T_id
         | T_string_literal
         | l-value '[' expr ']'

expr: T_int_const     { $$ = new IntConst($1); }
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

cond: '(' cond ')'     { $$ = $2 }
      | "not" cond
      | cond "and" cond
      | cond "or" cond
      | expr '=' expr    { $$ = new Cond($1, $2, $3); }
      | expr '#' expr    { $$ = new Cond($1, $2, $3); }
      | expr '<' expr    { $$ = new Cond($1, $2, $3); }
      | expr '>' expr    { $$ = new Cond($1, $2, $3); }
      | expr "<=" expr   { $$ = new Cond($1, $2, $3); }
      | expr ">=" expr   { $$ = new Cond($1, $2, $3); }
