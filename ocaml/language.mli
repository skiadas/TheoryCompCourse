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

      val intersect  : t -> t -> t
      val union      : t -> t -> t
      val concat     : t -> t -> t
      val complement : t -> t
      val star       : t -> t

   end

module Make (A : Alphabet.A) : Language with type str = A.t
