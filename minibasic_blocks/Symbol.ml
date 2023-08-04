open Ast

exception UnknownVariable of var
exception DuplicateVariable of var

type symbol_entry =
| SE of typ * int

let get_type se =
  match se with
  | SE (t, ofs) -> t

let get_offset se =
  match se with
  | SE (t, ofs) -> ofs

type symbol_scope =
| SC of (var * symbol_entry) list ref * int ref

let new_scope ofs = SC (ref [], ref ofs)

let get_scope_offset sc =
  match sc with
  | SC (entries, ofs) -> !ofs

let scope_lookup sc x =
  match sc with
  | SC (entries, ofs) -> List.assoc_opt x !entries

let scope_insert sc x t =
  match sc with
  | SC (entries, ofs) ->
      if List.mem_assoc x !entries then
        raise (DuplicateVariable x)
      else
        let the_ofs = !ofs in
        let se = SE (t, the_ofs) in
        ofs := !ofs + 1;
        entries := (x, se) :: !entries;
        the_ofs

type symbol_table =
| ST of symbol_scope list ref

let st = ST (ref [])

let open_scope st =
  match st with
  | ST scopes ->
      let ofs =
        if !scopes = [] then 0 else get_scope_offset (List.hd !scopes) in
      let sc = new_scope ofs in
      scopes := sc :: !scopes

let close_scope st =
  match st with
  | ST scopes ->
      scopes := List.tl !scopes

let lookup st x =
  match st with
  | ST scopes ->
      let rec walk scs = match scs with
        | [] -> raise (UnknownVariable x)
        | sc :: rest -> match scope_lookup sc x with
                       | None -> walk rest
                       | Some se -> se in
      walk !scopes

let insert st x t =
  match st with
  | ST scopes -> scope_insert (List.hd !scopes) x t
