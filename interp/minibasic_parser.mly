%token T_print
%token T_let
%token T_for
%token T_do
%token T_begin
%token T_end
%token T_if
%token T_then

%token <int> T_const
%token <int> T_var

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
%type <unit -> unit> program
%type <unit -> unit> stmt_list
%type <unit -> unit> stmt
%type <unit -> int> expr

%{
  let var = Array.make 26 0
%}

%%

program   : stmt_list T_eof { $1 }

stmt_list : /* nothing */ { fun _ -> () }
          | stmt stmt_list { fun _ -> begin $1 (); $2 () end }

stmt      : T_print expr { fun _ -> Printf.printf "%d\n" ($2 ()) }
          | T_let T_var T_eq expr { fun _ -> var.($2) <- $4 () }
      	  | T_for expr T_do stmt { fun _ -> let n = $2 () in
                                            for i = 1 to n do $4 () done }
      	  | T_begin stmt_list T_end { $2 }
      	  | T_if expr T_then stmt { fun _ -> if $2 () <> 0 then $4 () }

expr      : T_const { fun _ -> $1 }
          | T_var { fun _ -> var.($1) }
      	  | T_lparen expr T_rparen { $2 }
      	  | expr T_plus expr { fun _ -> $1 () + $3 () }
      	  | expr T_minus expr { fun _ -> $1 () - $3 () }
      	  | expr T_times expr { fun _ -> $1 () * $3 () }
