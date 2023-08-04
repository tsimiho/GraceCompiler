open Ast

module IntMap = Map.Make(
  struct
    type t = int
    let compare = Stdlib.compare
  end
)

let rt_vars = ref IntMap.empty

let rec run_expr ast =
  match ast with
  | E_const n         -> n
  | E_var (x, ofs)    -> IntMap.find !ofs !rt_vars
  | E_op (e1, op, e2) -> let v1 = run_expr e1
                         and v2 = run_expr e2 in
            		         match op with
            		         | O_plus  -> v1 + v2
            		         | O_minus -> v1 - v2
            		         | O_times -> v1 * v2

let decl_rt_insert d =
  match d with
  | Decl (x, ofs, t) -> rt_vars := IntMap.add !ofs 0 !rt_vars

let decl_rt_remove d =
  match d with
  | Decl (x, ofs, t) -> rt_vars := IntMap.remove !ofs !rt_vars

let rec run_stmt ast =
  match ast with
  | S_print e         -> let v = run_expr e in
                         Printf.printf "%d\n" v
  | S_let (x, ofs, e) -> let v = run_expr e in
                         rt_vars := IntMap.add !ofs v !rt_vars
  | S_for (e, s)      -> let v = run_expr e in
                         for i = 1 to v do
            		           run_stmt s
            	      	   done
  | S_block b         -> run b
  | S_if (e, s)       -> let v = run_expr e in
                         if v <> 0 then run_stmt s

and run b =
  match b with
  | Block (decls, stmts) ->
      List.iter decl_rt_insert decls;
      List.iter run_stmt stmts;
      List.iter decl_rt_remove decls
