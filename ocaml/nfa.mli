module type NFA =
   sig
      (* The type for NFAs *)
      module A : Alphabet.A
      (* states *)
      type state = int
      (* the various inputs *)
      type elem
      type str

      module D : Dfa.DFA with module A = A
                          and type state = state
                          and type elem = elem
                          and type str = str

      type trans = state -> elem -> state list
      type eps_trans = state -> state list
      (* The nfa type *)
      type t

      val make : int -> eps_trans -> trans -> state list -> t

      val epsilonClose : t -> state list -> state list
      val delta : t -> state list -> elem -> state list
      val deltaStar : t -> state list -> str -> state list
      val accept : t -> str -> bool
      val isFinal : t -> state -> bool

      (* Returns the accepted strings of at most given length *)
      val acceptedStrings : t -> int -> str list

      val union : t -> t -> t
      val complement : t -> t
      val concatenate : t -> t -> t
      val star : t -> t
   end

module Make(A : Alphabet.A) : NFA with type elem = A.elem
                                   and type str = A.t
