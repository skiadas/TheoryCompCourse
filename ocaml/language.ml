(*
   Language test file.
   To run compile via something like:

   ocamlopt -c alphabet.mli alphabet.ml
   ocamlopt -o test_lang  alphabet.ml language.mli language.ml

   Then execute the file test_lang via:

   ./test_lang
*)

(* Used for stumps for methods the student should implement. *)
exception NotImplemented

module type Language =
   sig
      module A : Alphabet.A
      (* type for a language *)
      type t
      (* type for strings  (equals A.t) *)
      type str

      val fromFunction : (str -> bool) -> t
      (* Finite languages *)
      val fromList : str list -> t
      (* Does the language contain a string? *)
      val contains : t -> str -> bool

      (* The following you need to implement *)
      val intersect  : t -> t -> t
      val union      : t -> t -> t
      val concat     : t -> t -> t
      val complement : t -> t

      (* Kleene Star. This one is harder, and optional. Do at your own peril. *)
      val star : t -> t

   end

module Make (A : Alphabet.A) =
   struct
      module A = A
      type str = A.t
      type t = str -> bool

      let fromFunction f = f
      let fromList lst = fun s -> List.mem s lst
      let contains f s = f s

      let intersect f g =
         raise NotImplemented

      let union f g =
         raise NotImplemented

      let complement f =
         raise NotImplemented

      (* Language concatenation *)
      let concat f g =
         raise NotImplemented

      (* Kleene Star. This one is harder, and optional. Do at your own peril. *)
      let star f =
         raise NotImplemented
   end;;


(* Helper methods to go from "char list" to "string" and vice versa *)
(* val explode : s -> char list *)
let explode s =
   let rec exp i l =
      if i < 0 then l else exp (i - 1) (s.[i] :: l)
   in exp (Bytes.length s - 1) [];;
(* val implode : char list -> s *)
let implode l =
   let res = Bytes.create (List.length l)
   in let rec imp i lst =
         match lst with
           []     -> res
         | c :: l -> Bytes.set res i c; imp (i + 1) l
      in imp 0 l;;

let test_true cnd msg =
   print_endline @@ (if cnd then "PASSED: " else "FAILED: ") ^ msg;;
let test_false cnd msg =
   print_endline @@ (if cnd then "FAILED: " else "PASSED: ") ^ msg;;

(* Everything that follows is test code. You can add your own tests if you like. *)
print_endline "Testing language.ml";;
module L = Make(Alphabet.Chars4);;
let l1 = L.fromFunction (fun s -> s <> []);;
test_false (L.contains l1 []) "l1 should not contain empty";;
test_true (L.contains l1 ['a']) "l1 should contain nonempty";;

(* l2 is all strings containing at least one a *)
let rec f s = match s with [] -> false | x :: rest -> x = 'a' || f rest
let l2 = L.fromFunction f;;
test_true (L.contains l2 (explode ("cdddccbab"))) "l2 should contain strings with a";;
test_false (L.contains l2 (explode ("cdddccbb"))) "l2 should not contain strings without a";;
(* l3 is all strings containing at least one b *)
let rec f s = match s with [] -> false | x :: rest -> x = 'b' || f rest
let l3 = L.fromFunction f;;
test_true (L.contains l3 (explode ("cdddccbab"))) "l3 should contain strings with b";;
test_false (L.contains l3 (explode ("cdddccaa"))) "l3 should not contain strings without b";;
(*
   l4 = L.intersect l2 l3
   Tests will fail until you implement intersect.
   Comment section out if you want to jump through it for now
*)
let l4 = L.intersect l2 l3;;
test_true (L.contains l4 (explode ("cdddccbab"))) "l4 should contain strings with both a and b";;
test_false (L.contains l4 (explode ("cdddccaa"))) "l4 should not contain strings without b";;
test_false (L.contains l4 (explode ("cdddccbb"))) "l4 should not contain strings without a";;

(*
   l5 = L.union l2 l3
   Tests will fail until you implement union.
   Comment section out if you want to jump through it for now
*)
let l5 = L.union l2 l3;;
test_false (L.contains l5 (explode ("cdddcc"))) "l5 should not contain strings without either a or b";;
test_true (L.contains l5 (explode ("cdddcca"))) "l5 should contain strings with a";;
test_true (L.contains l5 (explode ("cdddbcc"))) "l5 should not contain strings with b";;

(*
   Student TODO: Add your own test for complement
*)

let langForChar c =
   let rec f s = match s with [] -> true | x :: rest -> x = c && f rest
   in L.fromFunction f;;
let lAs = langForChar 'a';;
let lBs = langForChar 'b';;
let l7 = L.concat lAs lBs;;
test_true (L.contains l7 (explode ("aaabb"))) "l7 should contain a's followed by b's";;
test_true (L.contains l7 (explode ("bb"))) "l7 should contain all b's";;
test_true (L.contains l7 (explode ("aaaaa"))) "l7 should contain all a's";;
test_false (L.contains l7 (explode ("bba"))) "l7 should not contain b's before a's";;
test_false (L.contains l7 (explode ("acbb"))) "l7 should contain all other letters";;

