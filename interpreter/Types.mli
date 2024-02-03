type typ = TYPE_none       
         | TYPE_int        
         | TYPE_char
         | TYPE_array of   
             typ *         
             int           
         | TYPE_proc

val sizeOfType : typ -> int
val equalType : typ -> typ -> bool

type expr = 
  | Int of int
  | Var of string

type stmt =
  | Expr of expr
  | Return of expr option
  | Block of stmt list
  | FunctionCall of string * expr list

type func_body = stmt list
