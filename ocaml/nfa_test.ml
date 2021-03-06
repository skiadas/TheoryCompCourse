(*
   Testing Nfa module. Run with:

   ocamlopt -o nfa_test alphabet.mli alphabet.ml nfa.mli nfa.ml nfa_test.ml
   ./nfa_test

*)

module A = Alphabet.Binary
module N = Nfa.Make(A);;

(* NFA from example 1.38 Sipser 2nd ed *)
print_endline "NFA 1";;
let nfa1 =
   N.make 4
      (fun i -> match i with
         1 -> [2]
       | _ -> [])
      (fun i el -> match (i, el) with
         (0, 0) -> [0]
       | (0, 1) -> [0; 1]
       | (1, 0) -> [2]
       | (2, 1) -> [3]
       | (3, _) -> [3]
       | _      -> [])
      [3];; (* accept state *)

let accStrings = N.acceptedStrings nfa1 3;;
List.iter print_endline (List.map Alphabet.implodeInt accStrings);;

print_endline "";;
print_endline "NFA 2";;

(* NFA that recognizes all strings that end in 00 *)
let nfa2 =
   N.make 3
      (fun _ -> [])   (* No epsilon transitions *)
      (fun i el -> match (i, el) with
         (0, 0) -> [0; 1]
       | (0, 1) -> [0]
       | (1, 0) -> [2]
       | _      -> [])
      [2];;

let accStrings = N.acceptedStrings nfa2 4;;
List.iter print_endline (List.map Alphabet.implodeInt accStrings);;
