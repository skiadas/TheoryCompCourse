exception InvalidDFA

module type DFA =
   sig
      (* The type for DFAs *)
      module A : Alphabet.A
      (* states *)
      type state = int
      (* the various inputs *)
      type elem
      type str
      (* The dfa type *)
      type t

      val make : int -> (state -> elem -> state) -> state list -> t

      val delta : t -> state -> elem -> state
      val deltaStar : t -> state -> str -> state
      val accept : t -> str -> bool

      (* Returns the accepted strings of at most given length *)
      val acceptedStrings : t -> int -> str list

      val union : t -> t -> t
      val intersect : t -> t -> t

      (* DFA representing the empty language *)
      val emptyLang : t
      (* DFA representing the language containing only the empty string *)
      val emptyString : t
      (* DFA representing the language containing a single string, "a" for its first argument *)
      val oneElem : elem -> t
      (* DFA representing the language containing 0 or more occurences of a single element *)
      val zeroOrMore : elem -> t
      (* DFA representing the language containing 1 or more occurences of a single element *)
      val oneOrMore : elem -> t
   end

module Make(A : Alphabet.A) : DFA with module A = A
                                   and type elem = A.elem
                                   and type str = A.t
