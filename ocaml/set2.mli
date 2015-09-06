type 'a t

val empty  : 'a t
val member : 'a -> 'a t -> bool
val add    : 'a -> 'a t -> 'a t
val from_list : 'a list -> 'a t
val to_list   : 'a t -> 'a list

val union      : 'a t -> 'a t -> 'a t
val intersect  : 'a t -> 'a t -> 'a t
val difference : 'a t -> 'a t -> 'a t

val union : 'a t -> 'a t -> 'a t
