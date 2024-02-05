open Types

type 'a multi_array = {
  dimensions : int list;
  data : 'a array;
}

let createArray dimensions =
  let total_size = List.fold_left ( * ) 1 dimensions in
  let data = Array.make total_size 0 in
  { dimensions; data }

let mapIndices dimensions indices =
  let rec map_rec dims inds acc =
    match dims, inds with
    | [], [] -> acc
    | dim :: rest_dims, i :: rest_inds ->
        let stride = List.fold_left ( * ) 1 rest_dims in
        map_rec rest_dims rest_inds (acc + i * stride)
    | _ -> failwith "Mismatched dimensions and indices"
  in
  map_rec dimensions indices 0

let setValue multi_arr indices value =
  let idx_1d = mapIndices multi_arr.dimensions indices in
  multi_arr.data.(idx_1d) <- value

let getValue multi_arr indices =
  let idx_1d = mapIndices multi_arr.dimensions indices in
  multi_arr.data.(idx_1d)

let rec extractDimensionSizes typ =
  match typ with
  | TYPE_array (elem_typ, size) ->
      let rest_sizes = extractDimensionSizes elem_typ in
      size :: rest_sizes
  | _ -> []
