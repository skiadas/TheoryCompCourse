type result = INT_R of int
            | FLOAT_R of float

exception UnknownIdentifier of string

type memory = (string * result) list

let ourMemory : memory ref = ref []
let store s v = ourMemory := (s, v) :: (!ourMemory)
let fetch s =  try snd @@ List.find (fun (t, v) -> s = t) (!ourMemory)
               with Not_found -> raise (UnknownIdentifier s)

let fetch_int op = match op with
   '+' -> ( + ) | '-' -> ( - ) | '*' -> ( * ) | '/' -> ( / )
   | _ -> raise (UnknownIdentifier (String.make 1 op))

let fetch_float op = match op with
   '+' -> ( +. ) | '-' -> ( -. ) | '*' -> ( *. ) | '/' -> ( /. )
   | _ -> raise (UnknownIdentifier (String.make 1 op))

let do_op op x y = match (x, y) with
    (INT_R i, INT_R j)     -> INT_R ((fetch_int op) i j)
  | (FLOAT_R f, FLOAT_R g) -> FLOAT_R ((fetch_float op) f g)
  | (INT_R i, FLOAT_R f)   -> FLOAT_R ((fetch_float op) (float_of_int i) f)
  | (FLOAT_R f, INT_R i)   -> FLOAT_R ((fetch_float op) f (float_of_int i))

let get_float res = match res with FLOAT_R f -> f | INT_R i   -> float_of_int i
let do_f_call fn res = FLOAT_R (res |> get_float |> fn)

let do_call s v = match s with
   "cos"   -> do_f_call cos v
 | "sin"   -> do_f_call sin v
 | "tan"   -> do_f_call tan v
 | "sqrt"  -> do_f_call sqrt v
 | "exp"   -> do_f_call exp v
 | "ln"    -> do_f_call log v
 | "log"   -> do_f_call log10 v
 | "ceil"  -> INT_R (v |> get_float |> ceil |> int_of_float)
 | "floor" -> INT_R (v |> get_float |> floor |> int_of_float)
 | "abs"   -> (match v with INT_R i -> INT_R (abs i) | FLOAT_R f -> FLOAT_R (abs_float f))
 | _       -> raise (UnknownIdentifier s)
