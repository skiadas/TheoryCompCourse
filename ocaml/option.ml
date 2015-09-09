exception No_value

(* val may : ('a -> unit) -> 'a option -> unit *)
let may f v_opt = match v_opt with
   Some v -> f v
 | None   -> ()

(* val map : ('a -> 'b) -> 'a option -> 'b option *)
let map f v_opt = match v_opt with
   Some v -> Some (f v)
 | None   -> None

(* val default : 'a -> 'a option -> 'a *)
let default dflt v_opt = match v_opt with
   Some v -> v
 | None   -> dflt

(* val map_default : ('a -> 'b) -> 'b -> 'a option -> 'b *)
let map_default f dflt v_opt = match v_opt with
   Some v -> f v
 | None   -> dflt

(* val is_none : 'a option -> bool *)
let is_none v_opt = match v_opt with
   Some v -> false
 | None   -> true

(* val is_some : 'a option -> bool *)
let is_some v_opt = match v_opt with
   Some v -> true
 | None   -> false

(* val get : 'a option -> 'a *)
let get v_opt = match v_opt with
   Some v -> v
 | None   -> raise No_value

(* val bind : ('a -> 'b option) -> 'a option -> 'b option *)
let bind f v_opt = match v_opt with
   Some v -> f v
 | None   -> None
