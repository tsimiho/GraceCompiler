
module MenhirBasics = struct
  
  exception Error
  
  let _eRR =
    fun _s ->
      raise Error
  
  type token = 
    | T_while
    | T_var
    | T_times
    | T_then
    | T_string_literal of (
# 64 "Parser.mly"
      (string)
# 19 "Parser.ml"
  )
    | T_semicolon
    | T_rparen
    | T_return
    | T_ref
    | T_rbrack
    | T_rbrace
    | T_prod
    | T_plus
    | T_or
    | T_nothing
    | T_not
    | T_more
    | T_mod
    | T_minus
    | T_lparen
    | T_less
    | T_leq
    | T_lbrack
    | T_lbrace
    | T_int_const of (
# 62 "Parser.mly"
      (int)
# 43 "Parser.ml"
  )
    | T_int
    | T_if
    | T_id of (
# 61 "Parser.mly"
      (string)
# 50 "Parser.ml"
  )
    | T_hash
    | T_geq
    | T_fun
    | T_eq
    | T_eof
    | T_else
    | T_do
    | T_div
    | T_comma
    | T_colon
    | T_char_const of (
# 63 "Parser.mly"
      (string)
# 65 "Parser.ml"
  )
    | T_char
    | T_and
  
end

include MenhirBasics

# 1 "Parser.mly"
  
  open Symbol
  open Types
  open Identifier
  open Error
  open Narray

  type param = { 
    id: Identifier.id list; 
    mode: pass_mode; 
    param_type: typ 
  }

  and param_mode = PASS_BY_VALUE | PASS_BY_REFERENCE

  let registerHeader id params return_type = 
    let fun_entry = newFunction id true in
    openScope();
    match params with
    | [] -> ()
    | _ -> List.iter ( fun params -> 
                         List.iter ( fun single_id -> 
                                       ignore (newParameter single_id params.param_type params.mode fun_entry true) 
                                   ) params.id
                     ) params;
    match fun_entry.entry_info with
    | ENTRY_function func_info ->
        func_info.function_result <- return_type;
    | _ -> error "Expected a function entry %a" pretty_id id;
    closeScope();
    endFunctionHeader fun_entry return_type


  let callFunction id args =
    let func_entry = lookupEntry id LOOKUP_ALL_SCOPES true in
    match func_entry.entry_info with
    | ENTRY_function func_info -> func_info.function_body () 
    | _ -> error "%a is not a function" pretty_id id; None

        

# 116 "Parser.ml"

type ('s, 'r) _menhir_state = 
  | MenhirState000 : ('s, _menhir_box_program) _menhir_state
    (** State 000.
        Stack shape : .
        Start symbol: program. *)

  | MenhirState003 : (('s, _menhir_box_program) _menhir_cell1_T_fun _menhir_cell0_T_id, _menhir_box_program) _menhir_state
    (** State 003.
        Stack shape : T_fun T_id.
        Start symbol: program. *)

  | MenhirState005 : ((('s, _menhir_box_program) _menhir_cell1_T_fun _menhir_cell0_T_id, _menhir_box_program) _menhir_cell1_T_rparen, _menhir_box_program) _menhir_state
    (** State 005.
        Stack shape : T_fun T_id T_rparen.
        Start symbol: program. *)

  | MenhirState012 : (('s, _menhir_box_program) _menhir_cell1_T_ref _menhir_cell0_T_id, _menhir_box_program) _menhir_state
    (** State 012.
        Stack shape : T_ref T_id.
        Start symbol: program. *)

  | MenhirState014 : (('s, _menhir_box_program) _menhir_cell1_T_comma _menhir_cell0_T_id, _menhir_box_program) _menhir_state
    (** State 014.
        Stack shape : T_comma T_id.
        Start symbol: program. *)

  | MenhirState017 : ((('s, _menhir_box_program) _menhir_cell1_T_ref _menhir_cell0_T_id, _menhir_box_program) _menhir_cell1_comma_id_list, _menhir_box_program) _menhir_state
    (** State 017.
        Stack shape : T_ref T_id comma_id_list.
        Start symbol: program. *)

  | MenhirState019 : ((('s, _menhir_box_program) _menhir_cell1_comma_id_list, _menhir_box_program) _menhir_cell1_data_type, _menhir_box_program) _menhir_state
    (** State 019.
        Stack shape : comma_id_list data_type.
        Start symbol: program. *)

  | MenhirState021 : (((('s, _menhir_box_program) _menhir_cell1_comma_id_list, _menhir_box_program) _menhir_cell1_data_type, _menhir_box_program) _menhir_cell1_T_lbrack, _menhir_box_program) _menhir_state
    (** State 021.
        Stack shape : comma_id_list data_type T_lbrack.
        Start symbol: program. *)

  | MenhirState024 : (('s, _menhir_box_program) _menhir_cell1_T_lbrack _menhir_cell0_T_int_const, _menhir_box_program) _menhir_state
    (** State 024.
        Stack shape : T_lbrack T_int_const.
        Start symbol: program. *)

  | MenhirState028 : (('s, _menhir_box_program) _menhir_cell1_T_id, _menhir_box_program) _menhir_state
    (** State 028.
        Stack shape : T_id.
        Start symbol: program. *)

  | MenhirState030 : ((('s, _menhir_box_program) _menhir_cell1_T_id, _menhir_box_program) _menhir_cell1_comma_id_list, _menhir_box_program) _menhir_state
    (** State 030.
        Stack shape : T_id comma_id_list.
        Start symbol: program. *)

  | MenhirState032 : ((('s, _menhir_box_program) _menhir_cell1_T_fun _menhir_cell0_T_id, _menhir_box_program) _menhir_cell1_fpar_def, _menhir_box_program) _menhir_state
    (** State 032.
        Stack shape : T_fun T_id fpar_def.
        Start symbol: program. *)

  | MenhirState033 : ((('s, _menhir_box_program) _menhir_cell1_fpar_def, _menhir_box_program) _menhir_cell1_T_semicolon, _menhir_box_program) _menhir_state
    (** State 033.
        Stack shape : fpar_def T_semicolon.
        Start symbol: program. *)

  | MenhirState034 : (((('s, _menhir_box_program) _menhir_cell1_fpar_def, _menhir_box_program) _menhir_cell1_T_semicolon, _menhir_box_program) _menhir_cell1_fpar_def, _menhir_box_program) _menhir_state
    (** State 034.
        Stack shape : fpar_def T_semicolon fpar_def.
        Start symbol: program. *)

  | MenhirState038 : (((('s, _menhir_box_program) _menhir_cell1_T_fun _menhir_cell0_T_id, _menhir_box_program) _menhir_cell1_fpar_def, _menhir_box_program) _menhir_cell1_semi_fpar_def_list, _menhir_box_program) _menhir_state
    (** State 038.
        Stack shape : T_fun T_id fpar_def semi_fpar_def_list.
        Start symbol: program. *)

  | MenhirState041 : (('s, _menhir_box_program) _menhir_cell1_header, _menhir_box_program) _menhir_state
    (** State 041.
        Stack shape : header.
        Start symbol: program. *)

  | MenhirState043 : (('s, _menhir_box_program) _menhir_cell1_T_var _menhir_cell0_T_id, _menhir_box_program) _menhir_state
    (** State 043.
        Stack shape : T_var T_id.
        Start symbol: program. *)

  | MenhirState045 : ((('s, _menhir_box_program) _menhir_cell1_T_var _menhir_cell0_T_id, _menhir_box_program) _menhir_cell1_comma_id_list, _menhir_box_program) _menhir_state
    (** State 045.
        Stack shape : T_var T_id comma_id_list.
        Start symbol: program. *)

  | MenhirState048 : (((('s, _menhir_box_program) _menhir_cell1_T_var _menhir_cell0_T_id, _menhir_box_program) _menhir_cell1_comma_id_list, _menhir_box_program) _menhir_cell1_data_type, _menhir_box_program) _menhir_state
    (** State 048.
        Stack shape : T_var T_id comma_id_list data_type.
        Start symbol: program. *)

  | MenhirState051 : ((('s, _menhir_box_program) _menhir_cell1_header, _menhir_box_program) _menhir_cell1_local_def_list, _menhir_box_program) _menhir_state
    (** State 051.
        Stack shape : header local_def_list.
        Start symbol: program. *)

  | MenhirState052 : (('s, _menhir_box_program) _menhir_cell1_T_lbrace, _menhir_box_program) _menhir_state
    (** State 052.
        Stack shape : T_lbrace.
        Start symbol: program. *)

  | MenhirState053 : (('s, _menhir_box_program) _menhir_cell1_T_while, _menhir_box_program) _menhir_state
    (** State 053.
        Stack shape : T_while.
        Start symbol: program. *)

  | MenhirState055 : (('s, _menhir_box_program) _menhir_cell1_T_plus, _menhir_box_program) _menhir_state
    (** State 055.
        Stack shape : T_plus.
        Start symbol: program. *)

  | MenhirState056 : (('s, _menhir_box_program) _menhir_cell1_T_minus, _menhir_box_program) _menhir_state
    (** State 056.
        Stack shape : T_minus.
        Start symbol: program. *)

  | MenhirState057 : (('s, _menhir_box_program) _menhir_cell1_T_lparen, _menhir_box_program) _menhir_state
    (** State 057.
        Stack shape : T_lparen.
        Start symbol: program. *)

  | MenhirState060 : (('s, _menhir_box_program) _menhir_cell1_T_id, _menhir_box_program) _menhir_state
    (** State 060.
        Stack shape : T_id.
        Start symbol: program. *)

  | MenhirState064 : (('s, _menhir_box_program) _menhir_cell1_l_value, _menhir_box_program) _menhir_state
    (** State 064.
        Stack shape : l_value.
        Start symbol: program. *)

  | MenhirState066 : ((('s, _menhir_box_program) _menhir_cell1_l_value, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 066.
        Stack shape : l_value expr.
        Start symbol: program. *)

  | MenhirState067 : ((('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_times, _menhir_box_program) _menhir_state
    (** State 067.
        Stack shape : expr T_times.
        Start symbol: program. *)

  | MenhirState070 : ((('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_plus, _menhir_box_program) _menhir_state
    (** State 070.
        Stack shape : expr T_plus.
        Start symbol: program. *)

  | MenhirState071 : (((('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_plus, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 071.
        Stack shape : expr T_plus expr.
        Start symbol: program. *)

  | MenhirState072 : ((('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_mod, _menhir_box_program) _menhir_state
    (** State 072.
        Stack shape : expr T_mod.
        Start symbol: program. *)

  | MenhirState074 : ((('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_div, _menhir_box_program) _menhir_state
    (** State 074.
        Stack shape : expr T_div.
        Start symbol: program. *)

  | MenhirState076 : ((('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_minus, _menhir_box_program) _menhir_state
    (** State 076.
        Stack shape : expr T_minus.
        Start symbol: program. *)

  | MenhirState077 : (((('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_minus, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 077.
        Stack shape : expr T_minus expr.
        Start symbol: program. *)

  | MenhirState078 : ((('s, _menhir_box_program) _menhir_cell1_T_id, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 078.
        Stack shape : T_id expr.
        Start symbol: program. *)

  | MenhirState079 : ((('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_comma, _menhir_box_program) _menhir_state
    (** State 079.
        Stack shape : expr T_comma.
        Start symbol: program. *)

  | MenhirState080 : (((('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_comma, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 080.
        Stack shape : expr T_comma expr.
        Start symbol: program. *)

  | MenhirState084 : ((('s, _menhir_box_program) _menhir_cell1_T_lparen, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 084.
        Stack shape : T_lparen expr.
        Start symbol: program. *)

  | MenhirState086 : ((('s, _menhir_box_program) _menhir_cell1_T_minus, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 086.
        Stack shape : T_minus expr.
        Start symbol: program. *)

  | MenhirState087 : ((('s, _menhir_box_program) _menhir_cell1_T_plus, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 087.
        Stack shape : T_plus expr.
        Start symbol: program. *)

  | MenhirState088 : (('s, _menhir_box_program) _menhir_cell1_T_not, _menhir_box_program) _menhir_state
    (** State 088.
        Stack shape : T_not.
        Start symbol: program. *)

  | MenhirState089 : (('s, _menhir_box_program) _menhir_cell1_T_lparen, _menhir_box_program) _menhir_state
    (** State 089.
        Stack shape : T_lparen.
        Start symbol: program. *)

  | MenhirState090 : ((('s, _menhir_box_program) _menhir_cell1_T_lparen, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 090.
        Stack shape : T_lparen expr.
        Start symbol: program. *)

  | MenhirState091 : ((('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_more, _menhir_box_program) _menhir_state
    (** State 091.
        Stack shape : expr T_more.
        Start symbol: program. *)

  | MenhirState092 : (((('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_more, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 092.
        Stack shape : expr T_more expr.
        Start symbol: program. *)

  | MenhirState093 : ((('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_less, _menhir_box_program) _menhir_state
    (** State 093.
        Stack shape : expr T_less.
        Start symbol: program. *)

  | MenhirState094 : (((('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_less, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 094.
        Stack shape : expr T_less expr.
        Start symbol: program. *)

  | MenhirState095 : ((('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_leq, _menhir_box_program) _menhir_state
    (** State 095.
        Stack shape : expr T_leq.
        Start symbol: program. *)

  | MenhirState096 : (((('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_leq, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 096.
        Stack shape : expr T_leq expr.
        Start symbol: program. *)

  | MenhirState097 : ((('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_hash, _menhir_box_program) _menhir_state
    (** State 097.
        Stack shape : expr T_hash.
        Start symbol: program. *)

  | MenhirState098 : (((('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_hash, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 098.
        Stack shape : expr T_hash expr.
        Start symbol: program. *)

  | MenhirState099 : ((('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_geq, _menhir_box_program) _menhir_state
    (** State 099.
        Stack shape : expr T_geq.
        Start symbol: program. *)

  | MenhirState100 : (((('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_geq, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 100.
        Stack shape : expr T_geq expr.
        Start symbol: program. *)

  | MenhirState101 : ((('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_eq, _menhir_box_program) _menhir_state
    (** State 101.
        Stack shape : expr T_eq.
        Start symbol: program. *)

  | MenhirState102 : (((('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_eq, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 102.
        Stack shape : expr T_eq expr.
        Start symbol: program. *)

  | MenhirState105 : (('s, _menhir_box_program) _menhir_cell1_cond, _menhir_box_program) _menhir_state
    (** State 105.
        Stack shape : cond.
        Start symbol: program. *)

  | MenhirState106 : (('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 106.
        Stack shape : expr.
        Start symbol: program. *)

  | MenhirState108 : (('s, _menhir_box_program) _menhir_cell1_cond, _menhir_box_program) _menhir_state
    (** State 108.
        Stack shape : cond.
        Start symbol: program. *)

  | MenhirState112 : ((('s, _menhir_box_program) _menhir_cell1_T_while, _menhir_box_program) _menhir_cell1_cond, _menhir_box_program) _menhir_state
    (** State 112.
        Stack shape : T_while cond.
        Start symbol: program. *)

  | MenhirState114 : (('s, _menhir_box_program) _menhir_cell1_T_return, _menhir_box_program) _menhir_state
    (** State 114.
        Stack shape : T_return.
        Start symbol: program. *)

  | MenhirState116 : ((('s, _menhir_box_program) _menhir_cell1_T_return, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 116.
        Stack shape : T_return expr.
        Start symbol: program. *)

  | MenhirState118 : (('s, _menhir_box_program) _menhir_cell1_T_if, _menhir_box_program) _menhir_state
    (** State 118.
        Stack shape : T_if.
        Start symbol: program. *)

  | MenhirState120 : ((('s, _menhir_box_program) _menhir_cell1_T_if, _menhir_box_program) _menhir_cell1_cond, _menhir_box_program) _menhir_state
    (** State 120.
        Stack shape : T_if cond.
        Start symbol: program. *)

  | MenhirState122 : (((('s, _menhir_box_program) _menhir_cell1_T_if, _menhir_box_program) _menhir_cell1_cond, _menhir_box_program) _menhir_cell1_stmt, _menhir_box_program) _menhir_state
    (** State 122.
        Stack shape : T_if cond stmt.
        Start symbol: program. *)

  | MenhirState125 : (('s, _menhir_box_program) _menhir_cell1_l_value, _menhir_box_program) _menhir_state
    (** State 125.
        Stack shape : l_value.
        Start symbol: program. *)

  | MenhirState126 : ((('s, _menhir_box_program) _menhir_cell1_l_value, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 126.
        Stack shape : l_value expr.
        Start symbol: program. *)

  | MenhirState134 : (('s, _menhir_box_program) _menhir_cell1_stmt, _menhir_box_program) _menhir_state
    (** State 134.
        Stack shape : stmt.
        Start symbol: program. *)

  | MenhirState137 : (('s, _menhir_box_program) _menhir_cell1_local_def, _menhir_box_program) _menhir_state
    (** State 137.
        Stack shape : local_def.
        Start symbol: program. *)

  | MenhirState139 : (('s, _menhir_box_program) _menhir_cell1_header, _menhir_box_program) _menhir_state
    (** State 139.
        Stack shape : header.
        Start symbol: program. *)


and ('s, 'r) _menhir_cell1_comma_id_list = 
  | MenhirCell1_comma_id_list of 's * ('s, 'r) _menhir_state * (
# 99 "Parser.mly"
      (unit -> Identifier.id list)
# 474 "Parser.ml"
)

and ('s, 'r) _menhir_cell1_cond = 
  | MenhirCell1_cond of 's * ('s, 'r) _menhir_state * (
# 115 "Parser.mly"
      (unit -> bool)
# 481 "Parser.ml"
)

and ('s, 'r) _menhir_cell1_data_type = 
  | MenhirCell1_data_type of 's * ('s, 'r) _menhir_state * (
# 100 "Parser.mly"
      (unit -> typ)
# 488 "Parser.ml"
)

and ('s, 'r) _menhir_cell1_expr = 
  | MenhirCell1_expr of 's * ('s, 'r) _menhir_state * (
# 114 "Parser.mly"
      (unit -> expr_type)
# 495 "Parser.ml"
)

and ('s, 'r) _menhir_cell1_fpar_def = 
  | MenhirCell1_fpar_def of 's * ('s, 'r) _menhir_state * (
# 98 "Parser.mly"
      (unit -> param)
# 502 "Parser.ml"
)

and ('s, 'r) _menhir_cell1_header = 
  | MenhirCell1_header of 's * ('s, 'r) _menhir_state * (
# 96 "Parser.mly"
      (unit -> Identifier.id option)
# 509 "Parser.ml"
)

and ('s, 'r) _menhir_cell1_l_value = 
  | MenhirCell1_l_value of 's * ('s, 'r) _menhir_state * (
# 113 "Parser.mly"
      (unit -> (string * int list))
# 516 "Parser.ml"
)

and ('s, 'r) _menhir_cell1_local_def = 
  | MenhirCell1_local_def of 's * ('s, 'r) _menhir_state * (
# 105 "Parser.mly"
      (unit -> Identifier.id option)
# 523 "Parser.ml"
)

and ('s, 'r) _menhir_cell1_local_def_list = 
  | MenhirCell1_local_def_list of 's * ('s, 'r) _menhir_state * (
# 95 "Parser.mly"
      (unit -> unit)
# 530 "Parser.ml"
)

and ('s, 'r) _menhir_cell1_semi_fpar_def_list = 
  | MenhirCell1_semi_fpar_def_list of 's * ('s, 'r) _menhir_state * (
# 97 "Parser.mly"
      (unit -> param list)
# 537 "Parser.ml"
)

and ('s, 'r) _menhir_cell1_stmt = 
  | MenhirCell1_stmt of 's * ('s, 'r) _menhir_state * (
# 108 "Parser.mly"
      (unit -> expr_type option)
# 544 "Parser.ml"
)

and ('s, 'r) _menhir_cell1_T_comma = 
  | MenhirCell1_T_comma of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_T_div = 
  | MenhirCell1_T_div of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_T_eq = 
  | MenhirCell1_T_eq of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_T_fun = 
  | MenhirCell1_T_fun of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_T_geq = 
  | MenhirCell1_T_geq of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_T_hash = 
  | MenhirCell1_T_hash of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_T_id = 
  | MenhirCell1_T_id of 's * ('s, 'r) _menhir_state * (
# 61 "Parser.mly"
      (string)
# 569 "Parser.ml"
)

and 's _menhir_cell0_T_id = 
  | MenhirCell0_T_id of 's * (
# 61 "Parser.mly"
      (string)
# 576 "Parser.ml"
)

and ('s, 'r) _menhir_cell1_T_if = 
  | MenhirCell1_T_if of 's * ('s, 'r) _menhir_state

and 's _menhir_cell0_T_int_const = 
  | MenhirCell0_T_int_const of 's * (
# 62 "Parser.mly"
      (int)
# 586 "Parser.ml"
)

and ('s, 'r) _menhir_cell1_T_lbrace = 
  | MenhirCell1_T_lbrace of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_T_lbrack = 
  | MenhirCell1_T_lbrack of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_T_leq = 
  | MenhirCell1_T_leq of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_T_less = 
  | MenhirCell1_T_less of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_T_lparen = 
  | MenhirCell1_T_lparen of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_T_minus = 
  | MenhirCell1_T_minus of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_T_mod = 
  | MenhirCell1_T_mod of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_T_more = 
  | MenhirCell1_T_more of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_T_not = 
  | MenhirCell1_T_not of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_T_plus = 
  | MenhirCell1_T_plus of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_T_ref = 
  | MenhirCell1_T_ref of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_T_return = 
  | MenhirCell1_T_return of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_T_rparen = 
  | MenhirCell1_T_rparen of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_T_semicolon = 
  | MenhirCell1_T_semicolon of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_T_times = 
  | MenhirCell1_T_times of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_T_var = 
  | MenhirCell1_T_var of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_T_while = 
  | MenhirCell1_T_while of 's * ('s, 'r) _menhir_state

and _menhir_box_program = 
  | MenhirBox_program of (
# 93 "Parser.mly"
      (unit -> Identifier.id option)
# 644 "Parser.ml"
) [@@unboxed]

let _menhir_action_01 =
  fun _2 ->
    (
# 218 "Parser.mly"
                                   ( _2 )
# 652 "Parser.ml"
     : (
# 109 "Parser.mly"
      (unit -> expr_type option)
# 656 "Parser.ml"
    ))

let _menhir_action_02 =
  fun () ->
    (
# 169 "Parser.mly"
                                                                             ( fun _ -> [] )
# 664 "Parser.ml"
     : (
# 101 "Parser.mly"
      (unit -> int list)
# 668 "Parser.ml"
    ))

let _menhir_action_03 =
  fun _2 _4 ->
    (
# 170 "Parser.mly"
                                                                             ( fun _ -> _2 :: _4 () )
# 676 "Parser.ml"
     : (
# 101 "Parser.mly"
      (unit -> int list)
# 680 "Parser.ml"
    ))

let _menhir_action_04 =
  fun () ->
    (
# 250 "Parser.mly"
                                              ( fun _ -> [] )
# 688 "Parser.ml"
     : (
# 112 "Parser.mly"
      (unit -> expr_type list)
# 692 "Parser.ml"
    ))

let _menhir_action_05 =
  fun _2 _3 ->
    (
# 251 "Parser.mly"
                                              ( fun _ -> _2 () :: _3 () )
# 700 "Parser.ml"
     : (
# 112 "Parser.mly"
      (unit -> expr_type list)
# 704 "Parser.ml"
    ))

let _menhir_action_06 =
  fun () ->
    (
# 163 "Parser.mly"
                                          ( fun _ -> [] )
# 712 "Parser.ml"
     : (
# 99 "Parser.mly"
      (unit -> Identifier.id list)
# 716 "Parser.ml"
    ))

let _menhir_action_07 =
  fun _2 _3 ->
    (
# 164 "Parser.mly"
                                          ( fun _ -> (id_make _2) :: _3 () )
# 724 "Parser.ml"
     : (
# 99 "Parser.mly"
      (unit -> Identifier.id list)
# 728 "Parser.ml"
    ))

let _menhir_action_08 =
  fun _2 ->
    (
# 301 "Parser.mly"
                             ( _2 )
# 736 "Parser.ml"
     : (
# 115 "Parser.mly"
      (unit -> bool)
# 740 "Parser.ml"
    ))

let _menhir_action_09 =
  fun _2 ->
    (
# 302 "Parser.mly"
                             ( fun _ -> not (_2 ()) )
# 748 "Parser.ml"
     : (
# 115 "Parser.mly"
      (unit -> bool)
# 752 "Parser.ml"
    ))

let _menhir_action_10 =
  fun _1 _3 ->
    (
# 303 "Parser.mly"
                             ( fun _ -> _1 () && _3 () )
# 760 "Parser.ml"
     : (
# 115 "Parser.mly"
      (unit -> bool)
# 764 "Parser.ml"
    ))

let _menhir_action_11 =
  fun _1 _3 ->
    (
# 304 "Parser.mly"
                             ( fun _ -> _1 () || _3 () )
# 772 "Parser.ml"
     : (
# 115 "Parser.mly"
      (unit -> bool)
# 776 "Parser.ml"
    ))

let _menhir_action_12 =
  fun _1 _3 ->
    (
# 305 "Parser.mly"
                             ( fun _ -> _1 () = _3 () )
# 784 "Parser.ml"
     : (
# 115 "Parser.mly"
      (unit -> bool)
# 788 "Parser.ml"
    ))

let _menhir_action_13 =
  fun _1 _3 ->
    (
# 306 "Parser.mly"
                             ( fun _ -> _1 () <> _3 () )
# 796 "Parser.ml"
     : (
# 115 "Parser.mly"
      (unit -> bool)
# 800 "Parser.ml"
    ))

let _menhir_action_14 =
  fun _1 _3 ->
    (
# 307 "Parser.mly"
                             ( fun _ -> _1 () < _3 () )
# 808 "Parser.ml"
     : (
# 115 "Parser.mly"
      (unit -> bool)
# 812 "Parser.ml"
    ))

let _menhir_action_15 =
  fun _1 _3 ->
    (
# 308 "Parser.mly"
                             ( fun _ -> _1 () > _3 () )
# 820 "Parser.ml"
     : (
# 115 "Parser.mly"
      (unit -> bool)
# 824 "Parser.ml"
    ))

let _menhir_action_16 =
  fun _1 _3 ->
    (
# 309 "Parser.mly"
                             ( fun _ -> _1 () <= _3 () )
# 832 "Parser.ml"
     : (
# 115 "Parser.mly"
      (unit -> bool)
# 836 "Parser.ml"
    ))

let _menhir_action_17 =
  fun _1 _3 ->
    (
# 310 "Parser.mly"
                             ( fun _ -> _1 () >= _3 () )
# 844 "Parser.ml"
     : (
# 115 "Parser.mly"
      (unit -> bool)
# 848 "Parser.ml"
    ))

let _menhir_action_18 =
  fun () ->
    (
# 166 "Parser.mly"
                  ( fun _ -> TYPE_int )
# 856 "Parser.ml"
     : (
# 100 "Parser.mly"
      (unit -> typ)
# 860 "Parser.ml"
    ))

let _menhir_action_19 =
  fun () ->
    (
# 167 "Parser.mly"
                  ( fun _ -> TYPE_char )
# 868 "Parser.ml"
     : (
# 100 "Parser.mly"
      (unit -> typ)
# 872 "Parser.ml"
    ))

let _menhir_action_20 =
  fun _1 ->
    (
# 262 "Parser.mly"
                             ( fun _ -> IntConst _1 )
# 880 "Parser.ml"
     : (
# 114 "Parser.mly"
      (unit -> expr_type)
# 884 "Parser.ml"
    ))

let _menhir_action_21 =
  fun _1 ->
    (
# 263 "Parser.mly"
                             ( fun _ -> CharConst _1 )
# 892 "Parser.ml"
     : (
# 114 "Parser.mly"
      (unit -> expr_type)
# 896 "Parser.ml"
    ))

let _menhir_action_22 =
  fun _1 ->
    (
# 264 "Parser.mly"
                             ( fun _ -> let (value , l) = _1 () in
                                        MultiArray (createArray l)
                             )
# 906 "Parser.ml"
     : (
# 114 "Parser.mly"
      (unit -> expr_type)
# 910 "Parser.ml"
    ))

let _menhir_action_23 =
  fun _2 ->
    (
# 267 "Parser.mly"
                             ( _2 )
# 918 "Parser.ml"
     : (
# 114 "Parser.mly"
      (unit -> expr_type)
# 922 "Parser.ml"
    ))

let _menhir_action_24 =
  fun _1 ->
    (
# 268 "Parser.mly"
                             ( fun _ -> match _1 () with
                                        | Some value -> value
                                        | None -> Unit
                             )
# 933 "Parser.ml"
     : (
# 114 "Parser.mly"
      (unit -> expr_type)
# 937 "Parser.ml"
    ))

let _menhir_action_25 =
  fun _2 ->
    (
# 272 "Parser.mly"
                             ( fun _ -> match _2 () with 
                                        | IntConst num -> IntConst num
                                        | _ -> error "not an integer"; Unit
                             )
# 948 "Parser.ml"
     : (
# 114 "Parser.mly"
      (unit -> expr_type)
# 952 "Parser.ml"
    ))

let _menhir_action_26 =
  fun _2 ->
    (
# 276 "Parser.mly"
                             ( fun _ -> match _2 () with 
                                        | IntConst num -> IntConst (- num)
                                        | _ -> error "not an integer"; Unit
                             )
# 963 "Parser.ml"
     : (
# 114 "Parser.mly"
      (unit -> expr_type)
# 967 "Parser.ml"
    ))

let _menhir_action_27 =
  fun _1 _3 ->
    (
# 280 "Parser.mly"
                             ( fun _ -> match (_1 (), _3 ()) with
                                        | (IntConst a, IntConst b) -> IntConst (a + b)
                                        | _ -> error "not an integer"; Unit
                             )
# 978 "Parser.ml"
     : (
# 114 "Parser.mly"
      (unit -> expr_type)
# 982 "Parser.ml"
    ))

let _menhir_action_28 =
  fun _1 _3 ->
    (
# 284 "Parser.mly"
                             ( fun _ -> match (_1 (), _3 ()) with
                                        | (IntConst a, IntConst b) -> IntConst (a - b)
                                        | _ -> error "not an integer"; Unit
                             )
# 993 "Parser.ml"
     : (
# 114 "Parser.mly"
      (unit -> expr_type)
# 997 "Parser.ml"
    ))

let _menhir_action_29 =
  fun _1 _3 ->
    (
# 288 "Parser.mly"
                             ( fun _ -> match (_1 (), _3 ()) with
                                        | (IntConst a, IntConst b) -> IntConst (a * b)
                                        | _ -> error "not an integer"; Unit
                             )
# 1008 "Parser.ml"
     : (
# 114 "Parser.mly"
      (unit -> expr_type)
# 1012 "Parser.ml"
    ))

let _menhir_action_30 =
  fun _1 _3 ->
    (
# 292 "Parser.mly"
                             ( fun _ -> match (_1 (), _3 ()) with
                                        | (IntConst a, IntConst b) -> IntConst (a / b)
                                        | _ -> error "not an integer"; Unit
                             )
# 1023 "Parser.ml"
     : (
# 114 "Parser.mly"
      (unit -> expr_type)
# 1027 "Parser.ml"
    ))

let _menhir_action_31 =
  fun _1 _3 ->
    (
# 296 "Parser.mly"
                             ( fun _ -> match (_1 (), _3 ()) with
                                        | (IntConst a, IntConst b) -> IntConst (a mod b)
                                        | _ -> error "not an integer"; Unit
                             )
# 1038 "Parser.ml"
     : (
# 114 "Parser.mly"
      (unit -> expr_type)
# 1042 "Parser.ml"
    ))

let _menhir_action_32 =
  fun _2 _3 _5 ->
    (
# 154 "Parser.mly"
                                                     ( fun _ -> let params = (id_make _2) :: _3 () in
                                                                let param_type = _5 () in
                                                                { id = params; mode = PASS_BY_REFERENCE ; param_type = param_type }
                                                     )
# 1053 "Parser.ml"
     : (
# 98 "Parser.mly"
      (unit -> param)
# 1057 "Parser.ml"
    ))

let _menhir_action_33 =
  fun _1 _2 _4 ->
    (
# 158 "Parser.mly"
                                                     ( fun _ -> let params = (id_make _1) :: _2 () in
                                                                let param_type = _4 () in
                                                                { id = params; mode = PASS_BY_VALUE ; param_type = param_type }
                                                     )
# 1068 "Parser.ml"
     : (
# 98 "Parser.mly"
      (unit -> param)
# 1072 "Parser.ml"
    ))

let _menhir_action_34 =
  fun _1 _4 ->
    (
# 175 "Parser.mly"
                                                              ( fun _ -> let base_type = _1 () in
                                                                         let dimensions = max_int :: _4 () in
                                                                         let arr = List.fold_right (fun size acc -> TYPE_array (acc, size)) dimensions base_type in
                                                                         arr
                                                              )
# 1084 "Parser.ml"
     : (
# 103 "Parser.mly"
      (unit -> typ)
# 1088 "Parser.ml"
    ))

let _menhir_action_35 =
  fun _1 _2 ->
    (
# 180 "Parser.mly"
                                                              ( fun _ -> let base_type = _1 () in
                                                                         let dimensions = _2 () in
                                                                         let arr = List.fold_right (fun size acc -> TYPE_array (acc, size)) dimensions base_type in
                                                                         arr
                                                              )
# 1100 "Parser.ml"
     : (
# 103 "Parser.mly"
      (unit -> typ)
# 1104 "Parser.ml"
    ))

let _menhir_action_36 =
  fun _1 ->
    (
# 227 "Parser.mly"
                                                       ( fun _ -> let func_name = _1 in
                                                                  let func_entry = lookupEntry (id_make func_name) LOOKUP_ALL_SCOPES true in
                                                                  match func_entry.entry_info with
                                                                  | ENTRY_function func_info ->
                                                                     if List.length func_info.function_paramlist = 0 then
                                                                       callFunction (id_make func_name) []
                                                                     else
                                                                        (error "Incorrect number of arguments for function %a" pretty_id (id_make func_name); None)
                                                                  | _ -> (error "%a is not a function" pretty_id (id_make func_name); None)
                                                       )
# 1121 "Parser.ml"
     : (
# 111 "Parser.mly"
      (unit -> expr_type option)
# 1125 "Parser.ml"
    ))

let _menhir_action_37 =
  fun _1 _3 _4 ->
    (
# 237 "Parser.mly"
                                                       ( fun _ -> let func_name = _1 in
                                                                  let args = _3 () :: _4 () in
                                                                  let func_entry = lookupEntry (id_make func_name) LOOKUP_ALL_SCOPES true in
                                                                  match func_entry.entry_info with
                                                                  | ENTRY_function func_info ->
                                                                      if List.length func_info.function_paramlist = List.length args then
                                                                        callFunction (id_make func_name) args
                                                                      else
                                                                        (error "Incorrect number of arguments for function %a" pretty_id (id_make func_name); None)
                                                                  | _ -> (error "%a is not a function" pretty_id (id_make func_name); None)
                                                       )
# 1143 "Parser.ml"
     : (
# 111 "Parser.mly"
      (unit -> expr_type option)
# 1147 "Parser.ml"
    ))

let _menhir_action_38 =
  fun _1 ->
    (
# 196 "Parser.mly"
                              ( _1 )
# 1155 "Parser.ml"
     : (
# 106 "Parser.mly"
      (unit -> Identifier.id option)
# 1159 "Parser.ml"
    ))

let _menhir_action_39 =
  fun _1 _2 _3 ->
    (
# 122 "Parser.mly"
                                      ( fun _ -> begin 
                                          match _1 () with
                                          | Some func_name -> 
                                              _2 ();
                                              let func_body = _3 in
                                              let func_entry = lookupEntry func_name LOOKUP_CURRENT_SCOPE true in
                                              (match func_entry.entry_info with
                                              | ENTRY_function func_info -> func_info.function_body <- func_body; None
                                              | _ -> None)
                                          | None -> error "not a function"; None
                                        end
                                      )
# 1178 "Parser.ml"
     : (
# 94 "Parser.mly"
      (unit -> Identifier.id option)
# 1182 "Parser.ml"
    ))

let _menhir_action_40 =
  fun _1 _2 ->
    (
# 186 "Parser.mly"
                                             ( fun _ -> let base_type = _1 () in
                                                        let dimensions = _2 () in
                                                        let arr = List.fold_right (fun size acc -> TYPE_array (acc, size)) dimensions base_type in
                                                        arr
                                             )
# 1194 "Parser.ml"
     : (
# 104 "Parser.mly"
      (unit -> typ)
# 1198 "Parser.ml"
    ))

let _menhir_action_41 =
  fun _2 _4 _5 _8 ->
    (
# 138 "Parser.mly"
                                                                                  ( fun _ -> let id = (id_make _2) in
                                                                                             let params = _4 () :: _5 () in
                                                                                             let return_type = _8 () in 
                                                                                             registerHeader id params return_type;
                                                                                             Some id
                                                                                  )
# 1211 "Parser.ml"
     : (
# 96 "Parser.mly"
      (unit -> Identifier.id option)
# 1215 "Parser.ml"
    ))

let _menhir_action_42 =
  fun _2 _6 ->
    (
# 144 "Parser.mly"
                                                                                  ( fun _ -> let id = (id_make _2) in
                                                                                             let params = [] in
                                                                                             let return_type = _6 () in 
                                                                                             registerHeader id params return_type;
                                                                                             Some id
                                                                                  )
# 1228 "Parser.ml"
     : (
# 96 "Parser.mly"
      (unit -> Identifier.id option)
# 1232 "Parser.ml"
    ))

let _menhir_action_43 =
  fun _1 ->
    (
# 253 "Parser.mly"
                                        ( fun _ -> (_1,[]) )
# 1240 "Parser.ml"
     : (
# 113 "Parser.mly"
      (unit -> (string * int list))
# 1244 "Parser.ml"
    ))

let _menhir_action_44 =
  fun _1 ->
    (
# 254 "Parser.mly"
                                        ( fun _ -> (_1,[]) )
# 1252 "Parser.ml"
     : (
# 113 "Parser.mly"
      (unit -> (string * int list))
# 1256 "Parser.ml"
    ))

let _menhir_action_45 =
  fun _1 _3 ->
    (
# 255 "Parser.mly"
                                        ( fun _ -> let (value, l) = _1 () in
                                                   match _3 () with 
                                                   | IntConst exp -> (value, exp :: l)
                                                   | _ -> error "not an integer"; (value, [])
                                        )
# 1268 "Parser.ml"
     : (
# 113 "Parser.mly"
      (unit -> (string * int list))
# 1272 "Parser.ml"
    ))

let _menhir_action_46 =
  fun _1 ->
    (
# 192 "Parser.mly"
                     ( _1 )
# 1280 "Parser.ml"
     : (
# 105 "Parser.mly"
      (unit -> Identifier.id option)
# 1284 "Parser.ml"
    ))

let _menhir_action_47 =
  fun _1 ->
    (
# 193 "Parser.mly"
                     ( _1 )
# 1292 "Parser.ml"
     : (
# 105 "Parser.mly"
      (unit -> Identifier.id option)
# 1296 "Parser.ml"
    ))

let _menhir_action_48 =
  fun _1 ->
    (
# 194 "Parser.mly"
                     ( _1 )
# 1304 "Parser.ml"
     : (
# 105 "Parser.mly"
      (unit -> Identifier.id option)
# 1308 "Parser.ml"
    ))

let _menhir_action_49 =
  fun () ->
    (
# 135 "Parser.mly"
                                         ( fun _ -> () )
# 1316 "Parser.ml"
     : (
# 95 "Parser.mly"
      (unit -> unit)
# 1320 "Parser.ml"
    ))

let _menhir_action_50 =
  fun _1 _2 ->
    (
# 136 "Parser.mly"
                                         ( fun _ -> begin ignore(_1 ()); _2 () end )
# 1328 "Parser.ml"
     : (
# 95 "Parser.mly"
      (unit -> unit)
# 1332 "Parser.ml"
    ))

let _menhir_action_51 =
  fun _1 ->
    (
# 120 "Parser.mly"
                        ( _1 )
# 1340 "Parser.ml"
     : (
# 93 "Parser.mly"
      (unit -> Identifier.id option)
# 1344 "Parser.ml"
    ))

let _menhir_action_52 =
  fun _1 ->
    (
# 172 "Parser.mly"
                    ( fun _ -> _1 () )
# 1352 "Parser.ml"
     : (
# 102 "Parser.mly"
      (unit -> typ)
# 1356 "Parser.ml"
    ))

let _menhir_action_53 =
  fun () ->
    (
# 173 "Parser.mly"
                    ( fun _ -> TYPE_proc )
# 1364 "Parser.ml"
     : (
# 102 "Parser.mly"
      (unit -> typ)
# 1368 "Parser.ml"
    ))

let _menhir_action_54 =
  fun () ->
    (
# 151 "Parser.mly"
                                                            ( fun _ -> [] )
# 1376 "Parser.ml"
     : (
# 97 "Parser.mly"
      (unit -> param list)
# 1380 "Parser.ml"
    ))

let _menhir_action_55 =
  fun _2 _3 ->
    (
# 152 "Parser.mly"
                                                            ( fun _ -> _2 () :: _3 () )
# 1388 "Parser.ml"
     : (
# 97 "Parser.mly"
      (unit -> param list)
# 1392 "Parser.ml"
    ))

let _menhir_action_56 =
  fun () ->
    (
# 203 "Parser.mly"
                                        ( fun _ -> None )
# 1400 "Parser.ml"
     : (
# 108 "Parser.mly"
      (unit -> expr_type option)
# 1404 "Parser.ml"
    ))

let _menhir_action_57 =
  fun _1 _3 ->
    (
# 204 "Parser.mly"
                                        ( fun _ -> let (id,l) = _1 () in
                                                   let value = _3 () in
                                                   assignToVariable (id_make id) l value;
                                                   None
                                        )
# 1416 "Parser.ml"
     : (
# 108 "Parser.mly"
      (unit -> expr_type option)
# 1420 "Parser.ml"
    ))

let _menhir_action_58 =
  fun _1 ->
    (
# 209 "Parser.mly"
                                        ( _1 )
# 1428 "Parser.ml"
     : (
# 108 "Parser.mly"
      (unit -> expr_type option)
# 1432 "Parser.ml"
    ))

let _menhir_action_59 =
  fun _1 ->
    (
# 210 "Parser.mly"
                                        ( _1 )
# 1440 "Parser.ml"
     : (
# 108 "Parser.mly"
      (unit -> expr_type option)
# 1444 "Parser.ml"
    ))

let _menhir_action_60 =
  fun _2 _4 ->
    (
# 211 "Parser.mly"
                                        ( fun _ -> if _2 () then _4 () else None )
# 1452 "Parser.ml"
     : (
# 108 "Parser.mly"
      (unit -> expr_type option)
# 1456 "Parser.ml"
    ))

let _menhir_action_61 =
  fun _2 _4 _6 ->
    (
# 212 "Parser.mly"
                                        ( fun _ -> if _2 () then _4 () else _6 () )
# 1464 "Parser.ml"
     : (
# 108 "Parser.mly"
      (unit -> expr_type option)
# 1468 "Parser.ml"
    ))

let _menhir_action_62 =
  fun _2 _4 ->
    (
# 213 "Parser.mly"
                                        ( fun _ -> while _2 () do ignore(_4 ()) done; None )
# 1476 "Parser.ml"
     : (
# 108 "Parser.mly"
      (unit -> expr_type option)
# 1480 "Parser.ml"
    ))

let _menhir_action_63 =
  fun () ->
    (
# 214 "Parser.mly"
                                        ( fun _ -> None )
# 1488 "Parser.ml"
     : (
# 108 "Parser.mly"
      (unit -> expr_type option)
# 1492 "Parser.ml"
    ))

let _menhir_action_64 =
  fun _2 ->
    (
# 215 "Parser.mly"
                                        ( fun _ -> Some(_2 ()) )
# 1500 "Parser.ml"
     : (
# 108 "Parser.mly"
      (unit -> expr_type option)
# 1504 "Parser.ml"
    ))

let _menhir_action_65 =
  fun () ->
    (
# 220 "Parser.mly"
                          ( fun _ -> None )
# 1512 "Parser.ml"
     : (
# 110 "Parser.mly"
      (unit -> expr_type option)
# 1516 "Parser.ml"
    ))

let _menhir_action_66 =
  fun _1 _2 ->
    (
# 221 "Parser.mly"
                          ( fun _ -> let result = _1 () in
                                     match result with
                                     | Some _ as returnValue -> returnValue
                                     | None -> _2 ()
      )
# 1528 "Parser.ml"
     : (
# 110 "Parser.mly"
      (unit -> expr_type option)
# 1532 "Parser.ml"
    ))

let _menhir_action_67 =
  fun _2 _3 _5 ->
    (
# 198 "Parser.mly"
                                                                 ( fun _ -> let vars = (id_make _2) :: _3 () in
                                                                            let var_type = _5 () in
                                                                            List.iter ( fun var -> ignore(newVariable var var_type true) ) vars; None
                                                                 )
# 1543 "Parser.ml"
     : (
# 107 "Parser.mly"
      (unit -> Identifier.id option)
# 1547 "Parser.ml"
    ))

let _menhir_print_token : token -> string =
  fun _tok ->
    match _tok with
    | T_and ->
        "T_and"
    | T_char ->
        "T_char"
    | T_char_const _ ->
        "T_char_const"
    | T_colon ->
        "T_colon"
    | T_comma ->
        "T_comma"
    | T_div ->
        "T_div"
    | T_do ->
        "T_do"
    | T_else ->
        "T_else"
    | T_eof ->
        "T_eof"
    | T_eq ->
        "T_eq"
    | T_fun ->
        "T_fun"
    | T_geq ->
        "T_geq"
    | T_hash ->
        "T_hash"
    | T_id _ ->
        "T_id"
    | T_if ->
        "T_if"
    | T_int ->
        "T_int"
    | T_int_const _ ->
        "T_int_const"
    | T_lbrace ->
        "T_lbrace"
    | T_lbrack ->
        "T_lbrack"
    | T_leq ->
        "T_leq"
    | T_less ->
        "T_less"
    | T_lparen ->
        "T_lparen"
    | T_minus ->
        "T_minus"
    | T_mod ->
        "T_mod"
    | T_more ->
        "T_more"
    | T_not ->
        "T_not"
    | T_nothing ->
        "T_nothing"
    | T_or ->
        "T_or"
    | T_plus ->
        "T_plus"
    | T_prod ->
        "T_prod"
    | T_rbrace ->
        "T_rbrace"
    | T_rbrack ->
        "T_rbrack"
    | T_ref ->
        "T_ref"
    | T_return ->
        "T_return"
    | T_rparen ->
        "T_rparen"
    | T_semicolon ->
        "T_semicolon"
    | T_string_literal _ ->
        "T_string_literal"
    | T_then ->
        "T_then"
    | T_times ->
        "T_times"
    | T_var ->
        "T_var"
    | T_while ->
        "T_while"

let _menhir_fail : unit -> 'a =
  fun () ->
    Printf.eprintf "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

include struct
  
  [@@@ocaml.warning "-4-37"]
  
  let _menhir_run_143 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _v _tok ->
      match (_tok : MenhirBasics.token) with
      | T_eof ->
          let _1 = _v in
          let _v = _menhir_action_51 _1 in
          MenhirBox_program _v
      | _ ->
          _eRR ()
  
  let rec _menhir_run_001 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_T_fun (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_id _v ->
          let _menhir_stack = MenhirCell0_T_id (_menhir_stack, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | T_lparen ->
              let _menhir_s = MenhirState003 in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | T_rparen ->
                  let _menhir_stack = MenhirCell1_T_rparen (_menhir_stack, _menhir_s) in
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  (match (_tok : MenhirBasics.token) with
                  | T_colon ->
                      let _menhir_s = MenhirState005 in
                      let _tok = _menhir_lexer _menhir_lexbuf in
                      (match (_tok : MenhirBasics.token) with
                      | T_nothing ->
                          _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                      | T_int ->
                          _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                      | T_char ->
                          _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                      | _ ->
                          _eRR ())
                  | _ ->
                      _eRR ())
              | T_ref ->
                  _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | T_id _v ->
                  _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_006 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_53 () in
      _menhir_goto_ret_type _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_ret_type : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState038 ->
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState005 ->
          _menhir_run_009 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_039 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_T_fun _menhir_cell0_T_id, _menhir_box_program) _menhir_cell1_fpar_def, _menhir_box_program) _menhir_cell1_semi_fpar_def_list -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_semi_fpar_def_list (_menhir_stack, _, _5) = _menhir_stack in
      let MenhirCell1_fpar_def (_menhir_stack, _, _4) = _menhir_stack in
      let MenhirCell0_T_id (_menhir_stack, _2) = _menhir_stack in
      let MenhirCell1_T_fun (_menhir_stack, _menhir_s) = _menhir_stack in
      let _8 = _v in
      let _v = _menhir_action_41 _2 _4 _5 _8 in
      _menhir_goto_header _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_header : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState041 ->
          _menhir_run_139 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState139 ->
          _menhir_run_139 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState137 ->
          _menhir_run_139 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState000 ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_139 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | T_var ->
          let _menhir_stack = MenhirCell1_header (_menhir_stack, _menhir_s, _v) in
          _menhir_run_042 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState139
      | T_semicolon ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _1 = _v in
          let _v = _menhir_action_38 _1 in
          let _1 = _v in
          let _v = _menhir_action_47 _1 in
          _menhir_goto_local_def _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | T_fun ->
          let _menhir_stack = MenhirCell1_header (_menhir_stack, _menhir_s, _v) in
          _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState139
      | T_lbrace ->
          let _menhir_stack = MenhirCell1_header (_menhir_stack, _menhir_s, _v) in
          let _v_0 = _menhir_action_49 () in
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState139
      | _ ->
          _eRR ()
  
  and _menhir_run_042 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_T_var (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_id _v ->
          let _menhir_stack = MenhirCell0_T_id (_menhir_stack, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | T_comma ->
              _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState043
          | T_colon ->
              let _v_0 = _menhir_action_06 () in
              _menhir_run_044 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState043
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_013 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_T_comma (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_id _v ->
          let _menhir_stack = MenhirCell0_T_id (_menhir_stack, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | T_comma ->
              _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState014
          | T_colon ->
              let _v_0 = _menhir_action_06 () in
              _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_015 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_T_comma _menhir_cell0_T_id -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell0_T_id (_menhir_stack, _2) = _menhir_stack in
      let MenhirCell1_T_comma (_menhir_stack, _menhir_s) = _menhir_stack in
      let _3 = _v in
      let _v = _menhir_action_07 _2 _3 in
      _menhir_goto_comma_id_list _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_goto_comma_id_list : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState043 ->
          _menhir_run_044 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MenhirState028 ->
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MenhirState012 ->
          _menhir_run_016 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MenhirState014 ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_044 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_T_var _menhir_cell0_T_id as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_comma_id_list (_menhir_stack, _menhir_s, _v) in
      let _menhir_s = MenhirState045 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_int ->
          _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_char ->
          _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_007 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_18 () in
      _menhir_goto_data_type _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_data_type : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState045 ->
          _menhir_run_048 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState030 ->
          _menhir_run_019 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState017 ->
          _menhir_run_019 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState038 ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState005 ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_048 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_T_var _menhir_cell0_T_id, _menhir_box_program) _menhir_cell1_comma_id_list as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_data_type (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | T_lbrack ->
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState048
      | T_semicolon ->
          let _v_0 = _menhir_action_02 () in
          _menhir_run_049 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_022 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_T_lbrack (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_int_const _v ->
          _menhir_run_023 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _eRR ()
  
  and _menhir_run_023 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_T_lbrack -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _menhir_stack = MenhirCell0_T_int_const (_menhir_stack, _v) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_rbrack ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | T_lbrack ->
              _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState024
          | T_rparen | T_semicolon ->
              let _v_0 = _menhir_action_02 () in
              _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 _tok
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_025 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_T_lbrack _menhir_cell0_T_int_const -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell0_T_int_const (_menhir_stack, _2) = _menhir_stack in
      let MenhirCell1_T_lbrack (_menhir_stack, _menhir_s) = _menhir_stack in
      let _4 = _v in
      let _v = _menhir_action_03 _2 _4 in
      _menhir_goto_bracket_int_const_list _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_bracket_int_const_list : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState048 ->
          _menhir_run_049 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState019 ->
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState021 ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState024 ->
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_049 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_T_var _menhir_cell0_T_id, _menhir_box_program) _menhir_cell1_comma_id_list, _menhir_box_program) _menhir_cell1_data_type -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_data_type (_menhir_stack, _, _1) = _menhir_stack in
      let _2 = _v in
      let _v = _menhir_action_40 _1 _2 in
      match (_tok : MenhirBasics.token) with
      | T_semicolon ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_comma_id_list (_menhir_stack, _, _3) = _menhir_stack in
          let MenhirCell0_T_id (_menhir_stack, _2) = _menhir_stack in
          let MenhirCell1_T_var (_menhir_stack, _menhir_s) = _menhir_stack in
          let _5 = _v in
          let _v = _menhir_action_67 _2 _3 _5 in
          let _1 = _v in
          let _v = _menhir_action_48 _1 in
          _menhir_goto_local_def _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_goto_local_def : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_local_def (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | T_var ->
          _menhir_run_042 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState137
      | T_fun ->
          _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState137
      | T_lbrace ->
          let _v_0 = _menhir_action_49 () in
          _menhir_run_138 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0
      | _ ->
          _eRR ()
  
  and _menhir_run_138 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_local_def -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_local_def (_menhir_stack, _menhir_s, _1) = _menhir_stack in
      let _2 = _v in
      let _v = _menhir_action_50 _1 _2 in
      _menhir_goto_local_def_list _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_goto_local_def_list : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState137 ->
          _menhir_run_138 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState139 ->
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MenhirState041 ->
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_051 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_header as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_local_def_list (_menhir_stack, _menhir_s, _v) in
      _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState051
  
  and _menhir_run_052 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_T_lbrace (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_while ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState052
      | T_string_literal _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState052
      | T_semicolon ->
          _menhir_run_113 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState052
      | T_return ->
          _menhir_run_114 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState052
      | T_lbrace ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState052
      | T_if ->
          _menhir_run_118 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState052
      | T_id _v ->
          _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState052
      | T_rbrace ->
          let _v = _menhir_action_65 () in
          _menhir_run_132 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _eRR ()
  
  and _menhir_run_053 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_T_while (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState053 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_string_literal _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_plus ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_not ->
          _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_minus ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_lparen ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_int_const _v ->
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_id _v ->
          _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_char_const _v ->
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_054 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _1 = _v in
      let _v = _menhir_action_44 _1 in
      _menhir_goto_l_value _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_l_value : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState052 ->
          _menhir_run_124 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState134 ->
          _menhir_run_124 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState112 ->
          _menhir_run_124 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState120 ->
          _menhir_run_124 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState122 ->
          _menhir_run_124 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState125 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState118 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState114 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState053 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState088 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState108 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState105 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState101 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState099 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState097 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState095 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState093 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState091 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState089 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState055 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState056 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState057 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState079 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState076 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState074 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState072 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState070 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState067 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState064 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState060 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_124 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_l_value (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | T_prod ->
          let _menhir_s = MenhirState125 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | T_string_literal _v ->
              _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | T_plus ->
              _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | T_minus ->
              _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | T_lparen ->
              _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | T_int_const _v ->
              _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | T_id _v ->
              _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | T_char_const _v ->
              _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | T_lbrack ->
          _menhir_run_064 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_055 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_T_plus (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState055 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_string_literal _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_plus ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_minus ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_lparen ->
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_int_const _v ->
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_id _v ->
          _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_char_const _v ->
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_056 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_T_minus (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState056 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_string_literal _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_plus ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_minus ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_lparen ->
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_int_const _v ->
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_id _v ->
          _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_char_const _v ->
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_057 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_T_lparen (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState057 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_string_literal _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_plus ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_minus ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_lparen ->
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_int_const _v ->
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_id _v ->
          _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_char_const _v ->
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_058 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _1 = _v in
      let _v = _menhir_action_20 _1 in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_expr : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState125 ->
          _menhir_run_126 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState114 ->
          _menhir_run_116 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState118 ->
          _menhir_run_106 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState053 ->
          _menhir_run_106 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState088 ->
          _menhir_run_106 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState108 ->
          _menhir_run_106 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState105 ->
          _menhir_run_106 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState101 ->
          _menhir_run_102 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState099 ->
          _menhir_run_100 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState097 ->
          _menhir_run_098 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState095 ->
          _menhir_run_096 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState093 ->
          _menhir_run_094 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState091 ->
          _menhir_run_092 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState089 ->
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState055 ->
          _menhir_run_087 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState056 ->
          _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState057 ->
          _menhir_run_084 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState079 ->
          _menhir_run_080 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState060 ->
          _menhir_run_078 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState076 ->
          _menhir_run_077 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState074 ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState072 ->
          _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState070 ->
          _menhir_run_071 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState067 ->
          _menhir_run_068 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState064 ->
          _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_126 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_l_value as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | T_times ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState126
      | T_semicolon ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_l_value (_menhir_stack, _menhir_s, _1) = _menhir_stack in
          let _3 = _v in
          let _v = _menhir_action_57 _1 _3 in
          _menhir_goto_stmt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | T_plus ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_070 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState126
      | T_mod ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState126
      | T_minus ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState126
      | T_div ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState126
      | _ ->
          _eRR ()
  
  and _menhir_run_067 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_expr as 'stack) -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_T_times (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState067 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_string_literal _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_plus ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_minus ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_lparen ->
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_int_const _v ->
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_id _v ->
          _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_char_const _v ->
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_059 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_lparen ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | T_string_literal _v_0 ->
              let _menhir_stack = MenhirCell1_T_id (_menhir_stack, _menhir_s, _v) in
              _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState060
          | T_rparen ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let _1 = _v in
              let _v = _menhir_action_36 _1 in
              _menhir_goto_func_call _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
          | T_plus ->
              let _menhir_stack = MenhirCell1_T_id (_menhir_stack, _menhir_s, _v) in
              _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState060
          | T_minus ->
              let _menhir_stack = MenhirCell1_T_id (_menhir_stack, _menhir_s, _v) in
              _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState060
          | T_lparen ->
              let _menhir_stack = MenhirCell1_T_id (_menhir_stack, _menhir_s, _v) in
              _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState060
          | T_int_const _v_1 ->
              let _menhir_stack = MenhirCell1_T_id (_menhir_stack, _menhir_s, _v) in
              _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState060
          | T_id _v_2 ->
              let _menhir_stack = MenhirCell1_T_id (_menhir_stack, _menhir_s, _v) in
              _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v_2 MenhirState060
          | T_char_const _v_3 ->
              let _menhir_stack = MenhirCell1_T_id (_menhir_stack, _menhir_s, _v) in
              _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _v_3 MenhirState060
          | _ ->
              _eRR ())
      | T_and | T_comma | T_div | T_do | T_eq | T_geq | T_hash | T_lbrack | T_leq | T_less | T_minus | T_mod | T_more | T_or | T_plus | T_prod | T_rbrack | T_rparen | T_semicolon | T_then | T_times ->
          let _1 = _v in
          let _v = _menhir_action_43 _1 in
          _menhir_goto_l_value _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_goto_func_call : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState052 ->
          _menhir_run_128 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState134 ->
          _menhir_run_128 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState112 ->
          _menhir_run_128 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState120 ->
          _menhir_run_128 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState122 ->
          _menhir_run_128 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState125 ->
          _menhir_run_065 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState118 ->
          _menhir_run_065 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState114 ->
          _menhir_run_065 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState053 ->
          _menhir_run_065 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState088 ->
          _menhir_run_065 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState108 ->
          _menhir_run_065 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState105 ->
          _menhir_run_065 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState101 ->
          _menhir_run_065 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState099 ->
          _menhir_run_065 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState097 ->
          _menhir_run_065 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState095 ->
          _menhir_run_065 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState093 ->
          _menhir_run_065 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState091 ->
          _menhir_run_065 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState089 ->
          _menhir_run_065 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState055 ->
          _menhir_run_065 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState056 ->
          _menhir_run_065 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState057 ->
          _menhir_run_065 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState079 ->
          _menhir_run_065 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState060 ->
          _menhir_run_065 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState076 ->
          _menhir_run_065 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState074 ->
          _menhir_run_065 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState072 ->
          _menhir_run_065 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState070 ->
          _menhir_run_065 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState067 ->
          _menhir_run_065 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState064 ->
          _menhir_run_065 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_128 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | T_semicolon ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _1 = _v in
          let _v = _menhir_action_59 _1 in
          _menhir_goto_stmt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_goto_stmt : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState134 ->
          _menhir_run_134 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState052 ->
          _menhir_run_134 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState112 ->
          _menhir_run_131 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState122 ->
          _menhir_run_123 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState120 ->
          _menhir_run_121 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_134 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_stmt (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | T_while ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState134
      | T_string_literal _v_0 ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState134
      | T_semicolon ->
          _menhir_run_113 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState134
      | T_return ->
          _menhir_run_114 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState134
      | T_lbrace ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState134
      | T_if ->
          _menhir_run_118 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState134
      | T_id _v_1 ->
          _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState134
      | T_rbrace ->
          let _v_2 = _menhir_action_65 () in
          _menhir_run_135 _menhir_stack _menhir_lexbuf _menhir_lexer _v_2
      | _ ->
          _eRR ()
  
  and _menhir_run_113 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_56 () in
      _menhir_goto_stmt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_114 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_string_literal _v ->
          let _menhir_stack = MenhirCell1_T_return (_menhir_stack, _menhir_s) in
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState114
      | T_semicolon ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_63 () in
          _menhir_goto_stmt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | T_plus ->
          let _menhir_stack = MenhirCell1_T_return (_menhir_stack, _menhir_s) in
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState114
      | T_minus ->
          let _menhir_stack = MenhirCell1_T_return (_menhir_stack, _menhir_s) in
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState114
      | T_lparen ->
          let _menhir_stack = MenhirCell1_T_return (_menhir_stack, _menhir_s) in
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState114
      | T_int_const _v ->
          let _menhir_stack = MenhirCell1_T_return (_menhir_stack, _menhir_s) in
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState114
      | T_id _v ->
          let _menhir_stack = MenhirCell1_T_return (_menhir_stack, _menhir_s) in
          _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState114
      | T_char_const _v ->
          let _menhir_stack = MenhirCell1_T_return (_menhir_stack, _menhir_s) in
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState114
      | _ ->
          _eRR ()
  
  and _menhir_run_062 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _1 = _v in
      let _v = _menhir_action_21 _1 in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_118 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_T_if (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState118 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_string_literal _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_plus ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_not ->
          _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_minus ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_lparen ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_int_const _v ->
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_id _v ->
          _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_char_const _v ->
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_088 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_T_not (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState088 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_string_literal _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_plus ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_not ->
          _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_minus ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_lparen ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_int_const _v ->
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_id _v ->
          _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_char_const _v ->
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_089 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_T_lparen (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState089 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_string_literal _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_plus ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_not ->
          _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_minus ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_lparen ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_int_const _v ->
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_id _v ->
          _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_char_const _v ->
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_135 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_stmt -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_stmt (_menhir_stack, _menhir_s, _1) = _menhir_stack in
      let _2 = _v in
      let _v = _menhir_action_66 _1 _2 in
      _menhir_goto_stmt_list _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_goto_stmt_list : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState134 ->
          _menhir_run_135 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState052 ->
          _menhir_run_132 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_132 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_T_lbrace -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell1_T_lbrace (_menhir_stack, _menhir_s) = _menhir_stack in
      let _2 = _v in
      let _v = _menhir_action_01 _2 in
      _menhir_goto_block _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_block : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState051 ->
          _menhir_run_136 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState052 ->
          _menhir_run_130 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState134 ->
          _menhir_run_130 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState112 ->
          _menhir_run_130 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState120 ->
          _menhir_run_130 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState122 ->
          _menhir_run_130 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_136 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_header, _menhir_box_program) _menhir_cell1_local_def_list -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_local_def_list (_menhir_stack, _, _2) = _menhir_stack in
      let MenhirCell1_header (_menhir_stack, _menhir_s, _1) = _menhir_stack in
      let _3 = _v in
      let _v = _menhir_action_39 _1 _2 _3 in
      _menhir_goto_func_def _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_func_def : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState000 ->
          _menhir_run_143 _menhir_stack _v _tok
      | MenhirState041 ->
          _menhir_run_141 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState137 ->
          _menhir_run_141 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState139 ->
          _menhir_run_141 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_141 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _1 = _v in
      let _v = _menhir_action_46 _1 in
      _menhir_goto_local_def _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_130 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _1 = _v in
      let _v = _menhir_action_58 _1 in
      _menhir_goto_stmt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_131 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_T_while, _menhir_box_program) _menhir_cell1_cond -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_cond (_menhir_stack, _, _2) = _menhir_stack in
      let MenhirCell1_T_while (_menhir_stack, _menhir_s) = _menhir_stack in
      let _4 = _v in
      let _v = _menhir_action_62 _2 _4 in
      _menhir_goto_stmt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_123 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_T_if, _menhir_box_program) _menhir_cell1_cond, _menhir_box_program) _menhir_cell1_stmt -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_stmt (_menhir_stack, _, _4) = _menhir_stack in
      let MenhirCell1_cond (_menhir_stack, _, _2) = _menhir_stack in
      let MenhirCell1_T_if (_menhir_stack, _menhir_s) = _menhir_stack in
      let _6 = _v in
      let _v = _menhir_action_61 _2 _4 _6 in
      _menhir_goto_stmt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_121 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_T_if, _menhir_box_program) _menhir_cell1_cond as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | T_else ->
          let _menhir_stack = MenhirCell1_stmt (_menhir_stack, _menhir_s, _v) in
          let _menhir_s = MenhirState122 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | T_while ->
              _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | T_string_literal _v ->
              _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | T_semicolon ->
              _menhir_run_113 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | T_return ->
              _menhir_run_114 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | T_lbrace ->
              _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | T_if ->
              _menhir_run_118 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | T_id _v ->
              _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | T_id _ | T_if | T_lbrace | T_rbrace | T_return | T_semicolon | T_string_literal _ | T_while ->
          let MenhirCell1_cond (_menhir_stack, _, _2) = _menhir_stack in
          let MenhirCell1_T_if (_menhir_stack, _menhir_s) = _menhir_stack in
          let _4 = _v in
          let _v = _menhir_action_60 _2 _4 in
          _menhir_goto_stmt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_065 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _1 = _v in
      let _v = _menhir_action_24 _1 in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_070 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_expr as 'stack) -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_T_plus (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState070 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_string_literal _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_plus ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_minus ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_lparen ->
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_int_const _v ->
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_id _v ->
          _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_char_const _v ->
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_072 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_expr as 'stack) -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_T_mod (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState072 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_string_literal _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_plus ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_minus ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_lparen ->
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_int_const _v ->
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_id _v ->
          _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_char_const _v ->
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_076 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_expr as 'stack) -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_T_minus (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState076 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_string_literal _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_plus ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_minus ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_lparen ->
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_int_const _v ->
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_id _v ->
          _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_char_const _v ->
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_074 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_expr as 'stack) -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_T_div (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState074 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_string_literal _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_plus ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_minus ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_lparen ->
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_int_const _v ->
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_id _v ->
          _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_char_const _v ->
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_116 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_T_return as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | T_times ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState116
      | T_semicolon ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_T_return (_menhir_stack, _menhir_s) = _menhir_stack in
          let _2 = _v in
          let _v = _menhir_action_64 _2 in
          _menhir_goto_stmt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | T_plus ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_070 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState116
      | T_mod ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState116
      | T_minus ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState116
      | T_div ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState116
      | _ ->
          _eRR ()
  
  and _menhir_run_106 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | T_times ->
          _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState106
      | T_plus ->
          _menhir_run_070 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState106
      | T_more ->
          _menhir_run_091 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState106
      | T_mod ->
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState106
      | T_minus ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState106
      | T_less ->
          _menhir_run_093 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState106
      | T_leq ->
          _menhir_run_095 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState106
      | T_hash ->
          _menhir_run_097 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState106
      | T_geq ->
          _menhir_run_099 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState106
      | T_eq ->
          _menhir_run_101 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState106
      | T_div ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState106
      | _ ->
          _eRR ()
  
  and _menhir_run_091 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_expr as 'stack) -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_T_more (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState091 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_string_literal _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_plus ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_minus ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_lparen ->
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_int_const _v ->
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_id _v ->
          _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_char_const _v ->
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_093 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_expr as 'stack) -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_T_less (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState093 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_string_literal _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_plus ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_minus ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_lparen ->
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_int_const _v ->
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_id _v ->
          _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_char_const _v ->
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_095 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_expr as 'stack) -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_T_leq (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState095 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_string_literal _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_plus ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_minus ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_lparen ->
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_int_const _v ->
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_id _v ->
          _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_char_const _v ->
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_097 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_expr as 'stack) -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_T_hash (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState097 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_string_literal _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_plus ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_minus ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_lparen ->
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_int_const _v ->
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_id _v ->
          _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_char_const _v ->
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_099 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_expr as 'stack) -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_T_geq (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState099 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_string_literal _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_plus ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_minus ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_lparen ->
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_int_const _v ->
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_id _v ->
          _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_char_const _v ->
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_101 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_expr as 'stack) -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_T_eq (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState101 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_string_literal _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_plus ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_minus ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_lparen ->
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_int_const _v ->
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_id _v ->
          _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_char_const _v ->
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_102 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_eq as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | T_times ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState102
      | T_plus ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_070 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState102
      | T_mod ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState102
      | T_minus ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState102
      | T_div ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState102
      | T_and | T_do | T_or | T_rparen | T_then ->
          let MenhirCell1_T_eq (_menhir_stack, _) = _menhir_stack in
          let MenhirCell1_expr (_menhir_stack, _menhir_s, _1) = _menhir_stack in
          let _3 = _v in
          let _v = _menhir_action_12 _1 _3 in
          _menhir_goto_cond _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_goto_cond : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState118 ->
          _menhir_run_119 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState053 ->
          _menhir_run_111 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState088 ->
          _menhir_run_110 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState108 ->
          _menhir_run_109 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState105 ->
          _menhir_run_107 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState089 ->
          _menhir_run_103 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_119 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_T_if as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_cond (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | T_then ->
          let _menhir_s = MenhirState120 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | T_while ->
              _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | T_string_literal _v ->
              _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | T_semicolon ->
              _menhir_run_113 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | T_return ->
              _menhir_run_114 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | T_lbrace ->
              _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | T_if ->
              _menhir_run_118 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | T_id _v ->
              _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | T_or ->
          _menhir_run_105 _menhir_stack _menhir_lexbuf _menhir_lexer
      | T_and ->
          _menhir_run_108 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_105 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_cond -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState105 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_string_literal _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_plus ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_not ->
          _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_minus ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_lparen ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_int_const _v ->
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_id _v ->
          _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_char_const _v ->
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_108 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_cond -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState108 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_string_literal _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_plus ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_not ->
          _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_minus ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_lparen ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_int_const _v ->
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_id _v ->
          _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_char_const _v ->
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_111 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_T_while as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_cond (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | T_or ->
          _menhir_run_105 _menhir_stack _menhir_lexbuf _menhir_lexer
      | T_do ->
          let _menhir_s = MenhirState112 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | T_while ->
              _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | T_string_literal _v ->
              _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | T_semicolon ->
              _menhir_run_113 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | T_return ->
              _menhir_run_114 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | T_lbrace ->
              _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | T_if ->
              _menhir_run_118 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | T_id _v ->
              _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | T_and ->
          _menhir_run_108 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_110 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_T_not -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_T_not (_menhir_stack, _menhir_s) = _menhir_stack in
      let _2 = _v in
      let _v = _menhir_action_09 _2 in
      _menhir_goto_cond _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_109 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_cond -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_cond (_menhir_stack, _menhir_s, _1) = _menhir_stack in
      let _3 = _v in
      let _v = _menhir_action_10 _1 _3 in
      _menhir_goto_cond _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_107 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_cond as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | T_and ->
          let _menhir_stack = MenhirCell1_cond (_menhir_stack, _menhir_s, _v) in
          _menhir_run_108 _menhir_stack _menhir_lexbuf _menhir_lexer
      | T_do | T_or | T_rparen | T_then ->
          let MenhirCell1_cond (_menhir_stack, _menhir_s, _1) = _menhir_stack in
          let _3 = _v in
          let _v = _menhir_action_11 _1 _3 in
          _menhir_goto_cond _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_103 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_T_lparen as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | T_rparen ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_T_lparen (_menhir_stack, _menhir_s) = _menhir_stack in
          let _2 = _v in
          let _v = _menhir_action_08 _2 in
          _menhir_goto_cond _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | T_or ->
          let _menhir_stack = MenhirCell1_cond (_menhir_stack, _menhir_s, _v) in
          _menhir_run_105 _menhir_stack _menhir_lexbuf _menhir_lexer
      | T_and ->
          let _menhir_stack = MenhirCell1_cond (_menhir_stack, _menhir_s, _v) in
          _menhir_run_108 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_100 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_geq as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | T_times ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState100
      | T_plus ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_070 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState100
      | T_mod ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState100
      | T_minus ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState100
      | T_div ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState100
      | T_and | T_do | T_or | T_rparen | T_then ->
          let MenhirCell1_T_geq (_menhir_stack, _) = _menhir_stack in
          let MenhirCell1_expr (_menhir_stack, _menhir_s, _1) = _menhir_stack in
          let _3 = _v in
          let _v = _menhir_action_17 _1 _3 in
          _menhir_goto_cond _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_098 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_hash as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | T_times ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState098
      | T_plus ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_070 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState098
      | T_mod ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState098
      | T_minus ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState098
      | T_div ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState098
      | T_and | T_do | T_or | T_rparen | T_then ->
          let MenhirCell1_T_hash (_menhir_stack, _) = _menhir_stack in
          let MenhirCell1_expr (_menhir_stack, _menhir_s, _1) = _menhir_stack in
          let _3 = _v in
          let _v = _menhir_action_13 _1 _3 in
          _menhir_goto_cond _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_096 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_leq as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | T_times ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState096
      | T_plus ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_070 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState096
      | T_mod ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState096
      | T_minus ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState096
      | T_div ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState096
      | T_and | T_do | T_or | T_rparen | T_then ->
          let MenhirCell1_T_leq (_menhir_stack, _) = _menhir_stack in
          let MenhirCell1_expr (_menhir_stack, _menhir_s, _1) = _menhir_stack in
          let _3 = _v in
          let _v = _menhir_action_16 _1 _3 in
          _menhir_goto_cond _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_094 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_less as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | T_times ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState094
      | T_plus ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_070 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState094
      | T_mod ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState094
      | T_minus ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState094
      | T_div ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState094
      | T_and | T_do | T_or | T_rparen | T_then ->
          let MenhirCell1_T_less (_menhir_stack, _) = _menhir_stack in
          let MenhirCell1_expr (_menhir_stack, _menhir_s, _1) = _menhir_stack in
          let _3 = _v in
          let _v = _menhir_action_14 _1 _3 in
          _menhir_goto_cond _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_092 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_more as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | T_times ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState092
      | T_plus ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_070 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState092
      | T_mod ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState092
      | T_minus ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState092
      | T_div ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState092
      | T_and | T_do | T_or | T_rparen | T_then ->
          let MenhirCell1_T_more (_menhir_stack, _) = _menhir_stack in
          let MenhirCell1_expr (_menhir_stack, _menhir_s, _1) = _menhir_stack in
          let _3 = _v in
          let _v = _menhir_action_15 _1 _3 in
          _menhir_goto_cond _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_090 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_T_lparen as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | T_times ->
          _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState090
      | T_rparen ->
          _menhir_run_085 _menhir_stack _menhir_lexbuf _menhir_lexer
      | T_plus ->
          _menhir_run_070 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState090
      | T_more ->
          _menhir_run_091 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState090
      | T_mod ->
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState090
      | T_minus ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState090
      | T_less ->
          _menhir_run_093 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState090
      | T_leq ->
          _menhir_run_095 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState090
      | T_hash ->
          _menhir_run_097 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState090
      | T_geq ->
          _menhir_run_099 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState090
      | T_eq ->
          _menhir_run_101 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState090
      | T_div ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState090
      | _ ->
          _eRR ()
  
  and _menhir_run_085 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_T_lparen, _menhir_box_program) _menhir_cell1_expr -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell1_expr (_menhir_stack, _, _2) = _menhir_stack in
      let MenhirCell1_T_lparen (_menhir_stack, _menhir_s) = _menhir_stack in
      let _v = _menhir_action_23 _2 in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_087 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_T_plus as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | T_times ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState087
      | T_mod ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState087
      | T_div ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState087
      | T_and | T_comma | T_do | T_eq | T_geq | T_hash | T_leq | T_less | T_minus | T_more | T_or | T_plus | T_rbrack | T_rparen | T_semicolon | T_then ->
          let MenhirCell1_T_plus (_menhir_stack, _menhir_s) = _menhir_stack in
          let _2 = _v in
          let _v = _menhir_action_25 _2 in
          _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_086 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_T_minus as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | T_times ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState086
      | T_mod ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState086
      | T_div ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState086
      | T_and | T_comma | T_do | T_eq | T_geq | T_hash | T_leq | T_less | T_minus | T_more | T_or | T_plus | T_rbrack | T_rparen | T_semicolon | T_then ->
          let MenhirCell1_T_minus (_menhir_stack, _menhir_s) = _menhir_stack in
          let _2 = _v in
          let _v = _menhir_action_26 _2 in
          _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_084 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_T_lparen as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | T_times ->
          _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState084
      | T_rparen ->
          _menhir_run_085 _menhir_stack _menhir_lexbuf _menhir_lexer
      | T_plus ->
          _menhir_run_070 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState084
      | T_mod ->
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState084
      | T_minus ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState084
      | T_div ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState084
      | _ ->
          _eRR ()
  
  and _menhir_run_080 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_comma as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | T_times ->
          _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState080
      | T_plus ->
          _menhir_run_070 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState080
      | T_mod ->
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState080
      | T_minus ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState080
      | T_div ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState080
      | T_comma ->
          _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState080
      | T_rparen ->
          let _v_0 = _menhir_action_04 () in
          _menhir_run_081 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0
      | _ ->
          _eRR ()
  
  and _menhir_run_079 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_expr as 'stack) -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_T_comma (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState079 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_string_literal _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_plus ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_minus ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_lparen ->
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_int_const _v ->
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_id _v ->
          _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_char_const _v ->
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_081 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_comma, _menhir_box_program) _menhir_cell1_expr -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_expr (_menhir_stack, _, _2) = _menhir_stack in
      let MenhirCell1_T_comma (_menhir_stack, _menhir_s) = _menhir_stack in
      let _3 = _v in
      let _v = _menhir_action_05 _2 _3 in
      _menhir_goto_comma_expr_list _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_goto_comma_expr_list : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_expr as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState078 ->
          _menhir_run_082 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState080 ->
          _menhir_run_081 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_082 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_T_id, _menhir_box_program) _menhir_cell1_expr -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell1_expr (_menhir_stack, _, _3) = _menhir_stack in
      let MenhirCell1_T_id (_menhir_stack, _menhir_s, _1) = _menhir_stack in
      let _4 = _v in
      let _v = _menhir_action_37 _1 _3 _4 in
      _menhir_goto_func_call _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_078 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_T_id as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | T_times ->
          _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState078
      | T_plus ->
          _menhir_run_070 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState078
      | T_mod ->
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState078
      | T_minus ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState078
      | T_div ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState078
      | T_comma ->
          _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState078
      | T_rparen ->
          let _v_0 = _menhir_action_04 () in
          _menhir_run_082 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0
      | _ ->
          _eRR ()
  
  and _menhir_run_077 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_minus as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | T_times ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState077
      | T_mod ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState077
      | T_div ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState077
      | T_and | T_comma | T_do | T_eq | T_geq | T_hash | T_leq | T_less | T_minus | T_more | T_or | T_plus | T_rbrack | T_rparen | T_semicolon | T_then ->
          let MenhirCell1_T_minus (_menhir_stack, _) = _menhir_stack in
          let MenhirCell1_expr (_menhir_stack, _menhir_s, _1) = _menhir_stack in
          let _3 = _v in
          let _v = _menhir_action_28 _1 _3 in
          _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_075 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_div -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_T_div (_menhir_stack, _) = _menhir_stack in
      let MenhirCell1_expr (_menhir_stack, _menhir_s, _1) = _menhir_stack in
      let _3 = _v in
      let _v = _menhir_action_30 _1 _3 in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_073 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_mod -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_T_mod (_menhir_stack, _) = _menhir_stack in
      let MenhirCell1_expr (_menhir_stack, _menhir_s, _1) = _menhir_stack in
      let _3 = _v in
      let _v = _menhir_action_31 _1 _3 in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_071 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_plus as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | T_times ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState071
      | T_mod ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState071
      | T_div ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState071
      | T_and | T_comma | T_do | T_eq | T_geq | T_hash | T_leq | T_less | T_minus | T_more | T_or | T_plus | T_rbrack | T_rparen | T_semicolon | T_then ->
          let MenhirCell1_T_plus (_menhir_stack, _) = _menhir_stack in
          let MenhirCell1_expr (_menhir_stack, _menhir_s, _1) = _menhir_stack in
          let _3 = _v in
          let _v = _menhir_action_27 _1 _3 in
          _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_068 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_cell1_T_times -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_T_times (_menhir_stack, _) = _menhir_stack in
      let MenhirCell1_expr (_menhir_stack, _menhir_s, _1) = _menhir_stack in
      let _3 = _v in
      let _v = _menhir_action_29 _1 _3 in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_066 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_l_value as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | T_times ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState066
      | T_rbrack ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_l_value (_menhir_stack, _menhir_s, _1) = _menhir_stack in
          let _3 = _v in
          let _v = _menhir_action_45 _1 _3 in
          _menhir_goto_l_value _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | T_plus ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_070 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState066
      | T_mod ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState066
      | T_minus ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState066
      | T_div ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState066
      | _ ->
          _eRR ()
  
  and _menhir_run_064 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_l_value -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState064 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_string_literal _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_plus ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_minus ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_lparen ->
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_int_const _v ->
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_id _v ->
          _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | T_char_const _v ->
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_063 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | T_lbrack ->
          let _menhir_stack = MenhirCell1_l_value (_menhir_stack, _menhir_s, _v) in
          _menhir_run_064 _menhir_stack _menhir_lexbuf _menhir_lexer
      | T_and | T_comma | T_div | T_do | T_eq | T_geq | T_hash | T_leq | T_less | T_minus | T_mod | T_more | T_or | T_plus | T_rbrack | T_rparen | T_semicolon | T_then | T_times ->
          let _1 = _v in
          let _v = _menhir_action_22 _1 in
          _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_027 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_comma_id_list, _menhir_box_program) _menhir_cell1_data_type -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_data_type (_menhir_stack, _menhir_s, _1) = _menhir_stack in
      let _2 = _v in
      let _v = _menhir_action_35 _1 _2 in
      _menhir_goto_fpar_type _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_fpar_type : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_comma_id_list as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState030 ->
          _menhir_run_031 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState017 ->
          _menhir_run_018 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_031 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_T_id, _menhir_box_program) _menhir_cell1_comma_id_list -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_comma_id_list (_menhir_stack, _, _2) = _menhir_stack in
      let MenhirCell1_T_id (_menhir_stack, _menhir_s, _1) = _menhir_stack in
      let _4 = _v in
      let _v = _menhir_action_33 _1 _2 _4 in
      _menhir_goto_fpar_def _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_fpar_def : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState033 ->
          _menhir_run_034 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState003 ->
          _menhir_run_032 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_034 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_fpar_def, _menhir_box_program) _menhir_cell1_T_semicolon as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_fpar_def (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | T_semicolon ->
          _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState034
      | T_rparen ->
          let _v_0 = _menhir_action_54 () in
          _menhir_run_035 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_033 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_fpar_def as 'stack) -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_T_semicolon (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState033 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_ref ->
          _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_id _v ->
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_011 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_T_ref (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_id _v ->
          let _menhir_stack = MenhirCell0_T_id (_menhir_stack, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | T_comma ->
              _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState012
          | T_colon ->
              let _v_0 = _menhir_action_06 () in
              _menhir_run_016 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState012
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_016 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_T_ref _menhir_cell0_T_id as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_comma_id_list (_menhir_stack, _menhir_s, _v) in
      let _menhir_s = MenhirState017 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_int ->
          _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_char ->
          _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_008 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_19 () in
      _menhir_goto_data_type _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_028 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_T_id (_menhir_stack, _menhir_s, _v) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_comma ->
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState028
      | T_colon ->
          let _v_0 = _menhir_action_06 () in
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState028
      | _ ->
          _eRR ()
  
  and _menhir_run_029 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_T_id as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_comma_id_list (_menhir_stack, _menhir_s, _v) in
      let _menhir_s = MenhirState030 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_int ->
          _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | T_char ->
          _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_035 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_fpar_def, _menhir_box_program) _menhir_cell1_T_semicolon, _menhir_box_program) _menhir_cell1_fpar_def -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_fpar_def (_menhir_stack, _, _2) = _menhir_stack in
      let MenhirCell1_T_semicolon (_menhir_stack, _menhir_s) = _menhir_stack in
      let _3 = _v in
      let _v = _menhir_action_55 _2 _3 in
      _menhir_goto_semi_fpar_def_list _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_goto_semi_fpar_def_list : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_fpar_def as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState032 ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MenhirState034 ->
          _menhir_run_035 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_036 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_T_fun _menhir_cell0_T_id, _menhir_box_program) _menhir_cell1_fpar_def as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_semi_fpar_def_list (_menhir_stack, _menhir_s, _v) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_colon ->
          let _menhir_s = MenhirState038 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | T_nothing ->
              _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | T_int ->
              _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | T_char ->
              _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_032 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_T_fun _menhir_cell0_T_id as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_fpar_def (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | T_semicolon ->
          _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState032
      | T_rparen ->
          let _v_0 = _menhir_action_54 () in
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState032
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_018 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_T_ref _menhir_cell0_T_id, _menhir_box_program) _menhir_cell1_comma_id_list -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_comma_id_list (_menhir_stack, _, _3) = _menhir_stack in
      let MenhirCell0_T_id (_menhir_stack, _2) = _menhir_stack in
      let MenhirCell1_T_ref (_menhir_stack, _menhir_s) = _menhir_stack in
      let _5 = _v in
      let _v = _menhir_action_32 _2 _3 _5 in
      _menhir_goto_fpar_def _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_026 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_comma_id_list, _menhir_box_program) _menhir_cell1_data_type, _menhir_box_program) _menhir_cell1_T_lbrack -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_T_lbrack (_menhir_stack, _) = _menhir_stack in
      let MenhirCell1_data_type (_menhir_stack, _menhir_s, _1) = _menhir_stack in
      let _4 = _v in
      let _v = _menhir_action_34 _1 _4 in
      _menhir_goto_fpar_type _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_019 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_comma_id_list as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_data_type (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | T_lbrack ->
          let _menhir_stack = MenhirCell1_T_lbrack (_menhir_stack, MenhirState019) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | T_rbrack ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | T_lbrack ->
                  _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState021
              | T_rparen | T_semicolon ->
                  let _v_0 = _menhir_action_02 () in
                  _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 _tok
              | _ ->
                  _eRR ())
          | T_int_const _v_1 ->
              _menhir_run_023 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1
          | _ ->
              _eRR ())
      | T_rparen | T_semicolon ->
          let _v_2 = _menhir_action_02 () in
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer _v_2 _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_010 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _1 = _v in
      let _v = _menhir_action_52 _1 in
      _menhir_goto_ret_type _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_041 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_header (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | T_var ->
          _menhir_run_042 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState041
      | T_fun ->
          _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState041
      | T_lbrace ->
          let _v_0 = _menhir_action_49 () in
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState041
      | _ ->
          _eRR ()
  
  and _menhir_run_009 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_T_fun _menhir_cell0_T_id, _menhir_box_program) _menhir_cell1_T_rparen -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_T_rparen (_menhir_stack, _) = _menhir_stack in
      let MenhirCell0_T_id (_menhir_stack, _2) = _menhir_stack in
      let MenhirCell1_T_fun (_menhir_stack, _menhir_s) = _menhir_stack in
      let _6 = _v in
      let _v = _menhir_action_42 _2 _6 in
      _menhir_goto_header _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  let _menhir_run_000 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState000 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | T_fun ->
          _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
end

let program =
  fun _menhir_lexer _menhir_lexbuf ->
    let _menhir_stack = () in
    let MenhirBox_program v = _menhir_run_000 _menhir_stack _menhir_lexbuf _menhir_lexer in
    v
