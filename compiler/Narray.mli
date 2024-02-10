type 'a multi_array = {
  dimensions : int list;
  size: int;
  data : 'a array;
}

val createArray : int list -> int multi_array

val mapIndices : int list -> int list -> int

val setValue : 'a multi_array -> int list -> 'a -> unit

val getValue : 'a multi_array -> int list -> 'a

val extractDimensionSizes : Types.typ -> int list
