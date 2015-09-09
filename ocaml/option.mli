(* Raised when calling get None. *)
exception No_value

(* may f (Some x) calls f x and may f None does nothing. *)
val may : ('a -> unit) -> 'a option -> unit

(* map f (Some x) returns Some (f x) and map None returns None. *)
val map : ('a -> 'b) -> 'a option -> 'b option

(* default x (Some v) returns v and default x None returns x. *)
val default : 'a -> 'a option -> 'a

(* map_default f x (Some v) returns f v and map_default f x None returns x. *)
val map_default : ('a -> 'b) -> 'b -> 'a option -> 'b

(* is_none None returns true otherwise it returns false. *)
val is_none : 'a option -> bool

(* is_some (Some x) returns true otherwise it returns false. *)
val is_some : 'a option -> bool

(* get (Some x) returns x and get None raises No_value. *)
val get : 'a option -> 'a

val bind : ('a -> 'b option) -> 'a option -> 'b option
