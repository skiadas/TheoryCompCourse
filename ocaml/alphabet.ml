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

      val elemCompare : elem -> elem -> int
      val compare : t -> t -> int

      val allElems : elem list
      val epsilon : t
      val empty : t -> bool
      val length : t -> int
      val append : t -> t -> t
      val concat : t list -> t
      val substring : t -> t -> bool
      val prefix : t -> t -> bool
      val suffix : t -> t -> bool
      val allPrefixes : t -> t list
      val allSuffixes : t -> t list
      val splits : t -> (t * t) list
      val splitPrefix : t -> t -> t option
      val splitSuffix : t -> t -> t option
      val splitSubstring : t -> t -> (t * t) option
      val allStrings : int -> t list
      val allStringsLeq : int -> t list
   end

module Make(Elems : ElemsType) =
   struct
      (* type for an element *)
      type elem = Elems.elem
      (* type for a string of elements *)
      type t = elem list

      let elemCompare = Elems.compare

      let allElems = List.sort_uniq Elems.compare Elems.allElems
      let epsilon = []
      let empty s = s = []

      let length = List.length
      let append = List.append
      let concat = List.concat

      let rec prefix s1 s2 =
         match (s1, s2) with
            ([], _)                 -> true
          | (_, [])                 -> false
          | (x :: rest, y :: rest2) -> x = y && prefix rest rest2

      let suffix s1 s2 =
         prefix (List.rev s1) (List.rev s2)
(*          match s2 with
            []        -> s1 = []
          | x :: rest -> s1 = s2 || suffix s1 rest
 *)
      let rec allPrefixes s =
         match s with
            []        -> [[]]
          | x :: rest -> [] :: List.map (fun l -> x :: l) (allPrefixes rest)

      let rec allSuffixes s =
         match s with
            []        -> [[]]
          | _ :: rest -> s :: allSuffixes rest

      let substring s1 s2 =
         List.exists (prefix s1) (allSuffixes s2)

      let rec splitPrefix s1 s2 =
         match (s1, s2) with
            ([], _)                 -> Some s2
          | (_, [])                 -> None
          | (x :: rest, y :: rest') -> if x = y
                                       then splitPrefix rest rest'
                                       else None

      let rec splitSuffix s1 s2 =
         match s2 with
            []       -> if s1 = [] then Some [] else None
         | x :: rest -> match splitSuffix s1 rest with
                           Some s -> Some (x :: s)
                         | None   -> None

      let rec splitSubstring s1 s2 =
         match splitPrefix s1 s2 with
            Some v -> Some ([], v)
          | None   -> match s2 with
               []        -> None
             | x :: rest -> match splitSubstring s1 rest with
                  Some (w, v) -> Some (x :: w, v)
                | None        -> None

      (*
         helper methods that add prefixes to each string
         val addAllPrefixes : elem list -> string list -> string list
      *)
      let addPrefixesToOneString prefs str =
         List.map (fun p -> p :: str) prefs

      let addAllPrefixes prefs strs =
         List.flatten
            (List.map (addPrefixesToOneString prefs) strs)

      let rec allStrings n =
         if n = 0
         then [[]]
         else addAllPrefixes allElems (allStrings (n - 1))

      let allStringsLeq n =
         let rec fromPrev nsteps prevs =
            if n = nsteps
            then prevs
            else let next = addAllPrefixes allElems (List.hd prevs)
                 in fromPrev (nsteps + 1) (next :: prevs)
         in List.flatten (List.rev (fromPrev 0 [[[]]]))

      let rec compare s1 s2 =
         match (s1, s2) with
            ([], [])                -> 0
          | ([], _)                 -> -1
          | (_, [])                 -> 1
          | (x :: s1', y :: s2') ->
            let c = Elems.compare x y
            in if c = 0 then compare s1' s2' else c

      let splits s =
         let rec doNext soFar rest =
            match rest with
               []         -> [(soFar, rest)]   (* Last one *)
             | x :: rest' -> (soFar, rest) :: doNext (soFar @ [x]) rest'
         in doNext [] s
   end

module MakeInts(I: sig val allElems: int list end) =
    Make(struct
            type elem = int
            let compare = compare
            let allElems = I.allElems
         end)

module Binary = MakeInts(struct let allElems = [0; 1] end)
module Decimal = MakeInts(struct let allElems = [0; 1; 2; 3; 4; 5; 6; 7; 8; 9] end)

module MakeChars(C: sig val allElems: char list end) =
    Make(struct
            type elem = char
            let compare = compare
            let allElems = C.allElems
         end)

module Chars2 = MakeChars(struct let allElems = ['a'; 'b'] end)
module Chars3 = MakeChars(struct let allElems = ['a'; 'b'; 'c'] end)
module Chars4 = MakeChars(struct let allElems = ['a'; 'b'; 'c'; 'd'] end)

let explode s =
   let rec exp i l =
      if i < 0 then l else exp (i - 1) (s.[i] :: l)
   in exp (Bytes.length s - 1) [];;

let implode l =
   let res = Bytes.create (List.length l)
   in let rec imp i lst =
         match lst with
           []     -> res
         | c :: l -> Bytes.set res i c; imp (i + 1) l
      in imp 0 l;;

let explodeInt s = List.map (fun c -> Char.code c - Char.code '0') (explode s)

let implodeInt l = implode (List.map (fun i -> Char.chr (i + Char.code '0')) l)

