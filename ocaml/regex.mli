(* regex.mli *)

module type REGEX =
   sig
      module A: Alphabet.A

      type t

      val empty : t
      val eps   : t
      val elem  : A.elem -> t
      val union : t -> t -> t
      val concat: t -> t -> t
      val any   : A.elem list -> t (* Matches any element from list *)
      val anything : t          (* Matches any element at all *)
      val star  : t -> t
      val plus  : t -> t
      val option: t -> t
      val range : A.elem -> A.elem -> t

      val simplify : t -> t      (* Does simplification when possible *)
   end

module Make(A: Alphabet.A) : REGEX with module A = A
