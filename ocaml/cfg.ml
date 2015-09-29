(*
  Context Free languages

   ocamlc -c cfg.mli cfg.ml
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

let is_valid { vars; terms; prods; start } =
   let var_valid v = List.mem v vars in
   let term_valid t = List.mem t terms in
   let rhs_valid r =
      match r with
         T t -> term_valid t
       | V v -> var_valid v in
   let prod_valid (v, rhs) = var_valid v && List.for_all rhs_valid rhs
   in var_valid start && List.for_all prod_valid prods &&
      List.for_all (fun t -> not (List.mem t vars)) terms

let make ({ vars; terms; prods; start } as cfg) =
   if is_valid cfg then cfg else raise InvalidSpec

let rhs_equal = (=)
let rec isString rhs =
   match rhs with
      []          -> true
    | T t :: rhs' -> isString rhs'
    | V v :: _    -> false

let rec toString rhs =
   match rhs with
      []          -> []
    | T t :: rhs' -> t :: toString rhs'
    | V v :: _    -> raise Not_found

(* Adds element to list if not already there *)
let add lst el =
   if List.mem el lst
   then lst
   else el :: lst

(* Takes two lists, merges avoiding duplicates *)
let uniq_append lst1 lst2 =
   List.fold_left add lst1 lst2

let getRules { vars; terms; prods; start } v =
   prods |> List.filter (fun (v', _) -> v = v')
         |> List.map (fun (_, r) -> r)

let prependTo tail front = front @ tail
let prependEl el lst = el :: lst

(* Substitutes one variable with a substitution rule for it,
   for all possible combinations of variable and rule
*)
let rec oneStep ({ vars; terms; prods; start } as cfg) rhs =
   match rhs with
      []          -> [[]]
    | T t :: rhs' -> List.map (prependEl (T t)) (oneStep cfg rhs')
    | V v :: rhs' ->
      let rules = getRules cfg v
      in uniq_append (List.map (prependEl (V v)) (oneStep cfg rhs'))
                     (List.map (prependTo rhs') rules)


(*
  From a list of rhs', takes one step and separates out any
  complete strings it finds
*)
let advanceOne cfg rhs =
   oneStep cfg rhs |> List.partition isString
                   |> (fun (ss, rs) -> (List.map toString ss, rs))

let advance cfg rhss =
   List.fold_left (fun (strs1, rhss1) rhs ->
      let (strs2, rhss2) = advanceOne cfg rhs
      in (uniq_append strs1 strs2, uniq_append rhss1 rhss2)
   ) ([], []) rhss

let explore ({ vars; terms; prods; start } as cfg) n =
   let rec takeStep i matches rhss =
      if i = 0
      then List.map (String.concat "") matches (* Maybe should short them *)
      else let (newOnes, newRhss) = advance cfg rhss
           in takeStep (pred i) (uniq_append newOnes matches) newRhss
   in takeStep n [] [[V start]]

let is_cnf { vars; terms; prods; start } =
   let valid_prod prod = match prod with
      (v, []) -> v = start
    | (_, [T _])
    | (_, [V _; V _]) -> true
    | _               -> false
   in List.for_all valid_prod prods

(* substitutes a variable v1 for the string repl at any applicable rhs location
   of a list of production rules. Expects strings.
*)
let substitute_var v1 repl prods =
   let rec sub1 prod = match prod with
      T t :: prod' ->
    | V v :: prod' ->


(*
val to_cnf : t -> t
*)

let print { vars; terms; prods; start } =
   let print_el el = match el with
      T s | V s -> print_string s in
   let print_rhs = List.iter print_el in
   let print_prod (v, rhs) =
      begin
         print_string v;
         print_string " --> ";
         print_rhs rhs;
         print_endline ""
      end
   in List.iter print_prod prods
