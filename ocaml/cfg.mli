(*
  Context Free languages

*)

exception InvalidSpec   (* Raised when specification is invalid *)

type terminal = string
type nonterminal = string  (* named states *)

(* right-hand-side element of a production rule *)
type rhsEl = T of terminal | V of nonterminal
type rhs = rhsEl list
type production = nonterminal * rhs

type str = terminal list (* Final possible list *)

type t = {
   vars: nonterminal list;
   terms: terminal list;
   prods: production list;
   start: nonterminal;
}

val make : t -> t    (* Does validation *)

val rhs_equal : rhs -> rhs -> bool
val isString : rhs -> bool
val toString : rhs -> str    (* May raise Not_found *)

(* Returns list of production rules with given lhs*)
val getRules : t -> nonterminal -> rhs list

(* Substitutes one variable with a substitution rule for it,
   for all possible combinations of variable and rule
*)
val oneStep : t -> rhs -> rhs list

(*
  From a list of rhs', takes one step and separates out any
  complete strings it finds
*)
val advance : t -> rhs list -> str list * rhs list

(* advances a given number of production steps, returns all produced strings *)
val explore : t -> int -> string list

val is_cnf : t -> bool

(*
val to_cnf : t -> t
*)

val print : t -> unit
