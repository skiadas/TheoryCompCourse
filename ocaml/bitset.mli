exception TooLarge (* Raised when you trying to store number bigger than bit size *)

module type BITSIZE = sig val n: int end

module type BITSET =
   sig
      type t = int    (* integer interpreted as a bitset *)

      val maxN: int (* can only store from 0 up to maxN - 1 *)
      val empty: t
      val isEmpty: t -> bool
      val full: t
      val fromList: int list -> t
      val toList: t -> int list
      val contains: t -> int -> bool
      val add: t -> int -> t
      val union: t -> t -> t
      val intersect: t -> t -> t
      val getAll: (t -> bool) -> t list
   end

module Make(S : BITSIZE) : BITSET


