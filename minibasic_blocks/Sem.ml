open Ast
open Symbol

exception TypeError

let rec type_check e t =
  match e with
  | E_const n         -> if t <> TY_int then raise TypeError
  | E_var (x, ofs)    -> let p = lookup st x in
                         ofs := get_offset p;
                         if t <> get_type p then raise TypeError
  | E_op (e1, op, e2) -> type_check e1 TY_int;
                         type_check e2 TY_int;
                         if t <> TY_int then raise TypeError

let sem_decl d =
  match d with
  | Decl (x, ofs, t) -> ofs := insert st x t

let rec sem_stmt s =
  match s with
  | S_print e         -> type_check e TY_int
  | S_let (x, ofs, e) -> let p = lookup st x in
                         ofs := get_offset p;
                         type_check e (get_type p)
  | S_for (e, s)      -> type_check e TY_int;
                         sem_stmt s
  | S_block b         -> sem b
  | S_if (e, s)       -> type_check e TY_bool;
                         sem_stmt s

and sem b =
  match b with
  | Block (decls, stmts) -> open_scope st;
                            List.iter sem_decl decls;
                            List.iter sem_stmt stmts;
                            close_scope st
