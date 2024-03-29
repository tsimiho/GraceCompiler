type typ = TYPE_none
         | TYPE_int
         | TYPE_char
         | TYPE_array of
             typ *
             int list
         | TYPE_proc

let rec sizeOfType t =
   match t with
   | TYPE_int            -> 2
   | TYPE_char           -> 1
   | TYPE_array (et, sz) -> (List.fold_left ( * ) 1 sz) * sizeOfType et
   | _                   -> 0

let rec equalType t1 t2 =
   match t1, t2 with
   | TYPE_array (et1, sz1), TYPE_array (et2, sz2) -> equalType et1 et2
   | _                                            -> t1 = t2
