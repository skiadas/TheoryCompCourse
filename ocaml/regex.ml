(* regex.ml *)

(*
   compile with:

   ocamlc alphabet.mli alphabet.ml bitset.mli bitset.ml dfa.mli dfa.ml nfa.mli nfa.ml regex.mli regex.ml
*)

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

      val simplify : t -> t
   end

module Make(A: Alphabet.A) =
   struct
      module A = A

      type t = Empty
             | Epsilon         (* "matches" the empty string *)
             | Elem of A.elem  (* "matches" the element *)
             | Union of t * t
             | Concat of t * t
             | Star of t

      let allElems = List.sort_uniq A.elemCompare A.allElems

      let empty  = Empty
      let eps    = Epsilon
      let elem a = Elem a
      let union r1 r2  = Union (r1, r2)
      let concat r1 r2 = Concat (r1, r2)
      let star r = Star r
      let plus r = Concat (r, Star r)
      let option r = Union (Epsilon, r)
      let anything = List.fold_left union empty (List.map elem allElems)
      let rec any elems = match elems with
            []        -> Empty
          | [a]       -> elem a
          | a :: rest -> Union (elem a, any rest)
      let range a b = any (List.filter (fun x -> A.elemCompare a x <= 0 && A.elemCompare b x >= 0) allElems)

      module N = Nfa.Make(A)

      let rec simplify r = match r with
           Union  (Empty, r)
         | Union  (r, Empty)
         | Concat (Epsilon, r)
         | Concat (r, Epsilon)    -> simplify r
         | Concat (Empty, _)
         | Concat (_, Empty)      -> Empty
         | Union (Elem a, Elem b) -> if a = b then Elem a else r
         | Star Empty
         | Star Epsilon           -> Epsilon
         | Star r' -> let rs' = simplify r'
                      in if rs' = r'
                         then r
                         else simplify (Star r')
         | Union (r1, r2)         ->
            let (r1', r2') = (simplify r1, simplify r2)
            in if (r1', r2') = (r1, r2)
               then r
               else simplify @@ Union (r1', r2')
         | Concat (r1, r2)        ->
            let (r1', r2') = (simplify r1, simplify r2)
            in if (r1', r2') = (r1, r2)
               then r
               else simplify @@ Concat (r1', r2')
         | _                      -> r

      let rec toNfa r = match r with
            Empty    -> N.emptyLang
          | Epsilon  -> N.emptyString
          | Elem a   -> N.oneElem a
          | Union (r1, r2)  -> N.union (toNfa r1) (toNfa r2)
          | Concat (r1, r2) -> N.concatenate (toNfa r1) (toNfa r2)
          | Star r          -> N.star (toNfa r)

   end
