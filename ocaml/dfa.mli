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
   end

module Make(A : Alphabet.A) : DFA with type elem = A.elem
                                   and type str = A.t
