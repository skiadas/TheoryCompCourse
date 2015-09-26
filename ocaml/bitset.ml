(*
   Compile via

   ocamlc bitset.mli bitset.ml
*)

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

let limit =
   let rec isLimit n = if 1 lsl n = 0
                       then n
                       else isLimit (succ n)
   in isLimit 1

module Make(S : BITSIZE) =
   struct
      if S.n >= limit then raise TooLarge;;

      type t = int

      let maxN = S.n

      let empty = 0
      let isEmpty s = s = 0
      let full = pred (1 lsl maxN)  (* 2^n - 1 *)

      let add s i =
         if i >= maxN
         then raise TooLarge
         else s lor (1 lsl i)

      let contains s i =
         if i >= maxN
         then raise TooLarge
         else s land (1 lsl i) <> 0

      let fromList ints =
         List.fold_left add empty ints

      let toList s =
         let rec testi i =
            if i >= maxN
            then []
            else if contains s i
                 then i :: testi (succ i)
                 else testi (succ i)
         in testi 0

      let union = (lor)      (* union s1 s2 = s1 lor s2 *)
      let intersect = (land)

      let getAll pr =
         let rec geti i =
            if i = full    (* last one to be checked *)
            then if pr full then [full] else []
            else if pr i
                 then i :: geti (succ i)
                 else geti (succ i)
         in geti 0

   end

