(* Alphabet module *)

module type ElemsType =
   sig
      type elem
      val compare  : elem -> elem -> int
      val allElems : elem list
   end

module type A =
   sig
      (* type for an element *)
      type elem
      (* type for a string of elements *)
      type t = elem list

      val allElems : elem list
      val epsilon : t
      val empty : t -> bool
      val length : t -> int
      (* Concatenation of two strings *)
      val append : t -> t -> t
      val concat : t list -> t
      (* Whether first argument is a substring of the second *)
      val substring : t -> t -> bool
      (* Whether first argument is a prefix of the second *)
      val prefix : t -> t -> bool
      (* Whether first argument is a prefix of the second *)
      val suffix : t -> t -> bool
      val allPrefixes : t -> t list
      val allSuffixes : t -> t list

      (* Given a string, returns a list of all splits of
         the string into 2 concatenated substrings *)
      val splits : t -> (t * t) list
      (* If splitPrefix w v = Some z then v = append w z *)
      val splitPrefix : t -> t -> t option
      (* If splitSuffix w v = Some z then v = append z w *)
      val splitSuffix : t -> t -> t option
      (* If splitSubstring w v = Some (z, u) then v = concat [z; w; u] *)
      val splitSubstring : t -> t -> (t * t) option

      (* Returns all lists of given length *)
      val allStrings : int -> t list
      (* Returns all lists of at most the given length *)
      val allStringsLeq : int -> t list
   end

module Make (Elems : ElemsType) : A with type elem = Elems.elem

module MakeInts  (I: sig val allElems: int list end)  : A with type elem = int
module MakeChars (I: sig val allElems: char list end) : A with type elem = char

module Binary  : A with type elem = int
module Decimal : A with type elem = int
module Chars2  : A with type elem = char
module Chars3  : A with type elem = char
module Chars4  : A with type elem = char
