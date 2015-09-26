(*
   Link with:

   ocamlc alphabet.mli alphabet.ml dfa.mli dfa.ml bitset.mli bitset.ml nfa.mli nfa.ml

*)
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
      val concatenate : t -> t -> t
      val star : t -> t

      val emptyLang : t
      val emptyString : t
      val oneElem : elem -> t
      val zeroOrMore : elem -> t
      val oneOrMore : elem -> t

      val fromDfa: D.t -> t
      val toDfa: t -> D.t
   end

module Make(A : Alphabet.A) =
   struct
      module A = A
      type elem = A.elem
      type str = A.t
      type state = int
      type trans = state -> elem -> state list
      type eps_trans = state -> state list

      module D = Dfa.Make(A)

      (* State 0 is always the start state *)
      type t = {
         nstates : state;
         epsdelta : eps_trans;
         delta : trans;
         final : state list;
      }

      let make nstates epsdelta delta final =
         {
            nstates = nstates;
            epsdelta = epsdelta;
            delta = delta;
            final = final;
         }

      (* Helper methods for managing lists *)

      (*
         diff: int list -> int list -> int list
         those elements in l1 that are not in l2
      *)
      let rec diff l1 l2 =
         match l1 with
            []        -> []
          | x :: rest -> if List.mem x l2
                         then diff rest l2
                         else x :: diff rest l2

      (* map_flatten: ('a -> 'b list) -> 'a list -> 'b list *)
      let map_flatten f lst = List.flatten @@ List.map f lst

      let nstates { nstates; epsdelta; delta; final } = nstates
      let final { nstates; epsdelta; delta; final } = final

      let epsilonClose { nstates; epsdelta; delta; final } ss =
         let rec takeStep states =
            match diff (map_flatten epsdelta states) states with
               []        -> states     (* nothing to add *)
             | newStates -> takeStep (newStates @ states)
         in takeStep ss

      (* includes epsilon transitions *)
      let delta ({ nstates; epsdelta; delta; final } as nfa) ss e =
         epsilonClose nfa (map_flatten (fun s -> delta s e)
                                       (epsilonClose nfa ss))

      let deltaStar nfa sts es =
         List.fold_left (delta nfa) sts es

      let accept ({ nstates; epsdelta; delta; final } as nfa) es =
         List.exists (fun s -> List.mem s final)
                     (deltaStar nfa [0] es)

      let acceptedStrings nfa n =
         List.filter (accept nfa) (A.allStringsLeq n)

      let isFinal { nstates; epsdelta; delta; final } s =
         List.mem s final

      let intUnion l1 l2 = List.sort_uniq Pervasives.compare @@
            List.append l1 l2

      let union { nstates=nstates1; epsdelta=epsdelta1; delta=delta1; final=final1; }
                { nstates=nstates2; epsdelta=epsdelta2; delta=delta2; final=final2; } =
         let (newZero1, newZero2) = (1, nstates1 + 1) in
         let newEpsDelta n =
            if n = 0
            then [newZero1; newZero2]
            else if n < newZero2
                 then epsdelta1 (n - newZero1)
                 else epsdelta2 (n - newZero2) in
         let newDelta n a =
            if n = 0
            then []
            else if n < newZero2
                 then delta1 (n - newZero1) a
                 else delta2 (n - newZero2) a
         in {
            nstates = nstates1 + nstates2 + 1;
            epsdelta = newEpsDelta;
            delta = newDelta;
            final = intUnion (List.map (fun n -> n - newZero1) final1)
                             (List.map (fun n -> n - newZero2) final2);
         }

      let concatenate { nstates=nstates1; epsdelta=epsdelta1; delta=delta1; final=final1; }
                      { nstates=nstates2; epsdelta=epsdelta2; delta=delta2; final=final2; } =
         let newZero2 = nstates1 in
         let newEpsDelta n =
             if n >= newZero2
             then epsdelta2 (n - newZero2)
             else if List.mem n final1
                  then newZero2 :: epsdelta1 n
                  else epsdelta1 n in
         let newDelta n a =
             if n < newZero2
             then delta1 n a
             else delta2 (n - newZero2) a
          in {
            nstates= nstates1 + nstates2;
            epsdelta= newEpsDelta;
            delta= newDelta;
            final = List.map (fun n -> n + newZero2) final2
          }

      let star { nstates; epsdelta; delta; final; } =
         let newEpsDelta n =
            if n = 0
            then [1]   (* 1 is the original start state *)
            else List.map ((+) 1) @@ epsdelta (n - 1) in
         let newDelta n a =
            if n = 0
            then []
            else List.map ((+) 1) @@ delta (n - 1) a
         in {
            nstates= nstates + 1;
            epsdelta= newEpsDelta;
            delta= newDelta;
            final= 0 :: (List.map ((+) 1) @@ final);
         }

      let emptyLang = {
         nstates= 1;
         epsdelta= (fun _ -> []);
         delta= (fun _ _ -> []);
         final= [];
      }

      let emptyString = {
         nstates= 1;
         epsdelta= (fun _ -> []);
         delta= (fun _ _ -> []);
         final= [0];
      }

      let oneElem a = {
         nstates= 2;
         epsdelta= (fun _ -> []);
         delta= (fun s el -> if s = 0 && el = a then [1] else []);
         final= [1];
      }

      let zeroOrMore a = {
            nstates= 1;
            epsdelta= (fun _ -> []);
            delta= (fun _ el -> if el = a then [0] else []);
            final= [0];
         }

      let oneOrMore a = {
         nstates= 2;
         epsdelta= (fun _ -> []);
         delta= (fun _ el -> if el = a then [1] else []);
         final= [1];
      }

      let fromDfa dfa =
         let dfaDelta = D.delta dfa
         in {
            nstates= D.nstates dfa;
            epsdelta= (fun _ -> []);
            delta= (fun n a -> [dfaDelta n a]);
            final= D.final dfa;
         }

      let toDfa nfa =
         let nstates = nstates nfa in
         let module B = Bitset.Make(struct let n=nstates end) in
         let newNstates = 1 lsl nstates in
         let newDelta n a = B.fromList @@ delta nfa (B.toList n) a in
         let finalAsSet = B.fromList (final nfa) in
         let isFinal i = B.isEmpty (B.intersect i finalAsSet)
         in D.make newNstates newDelta (B.getAll isFinal)

   end
