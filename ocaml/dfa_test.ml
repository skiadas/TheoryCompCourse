(*
   Testing Dfa module. Run with:

   ocamlopt -o dfa_test alphabet.mli alphabet.ml dfa.mli dfa.ml dfa_test.ml
   ./dfa_test

*)

module A = Alphabet.Binary
module D = Dfa.Make(A)

(* DFA for language of binary strings that must start with 0 *)
let dfa1 =
   D.make 3 (fun i el -> match (i, el) with
      (0, 0) -> 2
    | (0, 1) -> 1
    | (1, _) -> 1
    | (2, _) -> 2
    | _      -> 3 (* To avoid warnings *)
   ) [2];; (* accept state *)

if D.accept dfa1 [0; 1; 1] then print_endline "Works!";;
if not (D.accept dfa1 [1; 0; 1]) then print_endline "Really works!";;
let accStrings = D.acceptedStrings dfa1 3;;
List.iter print_endline (List.map Alphabet.implodeInt accStrings)
