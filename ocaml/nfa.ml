module type NFA =
   sig
      (* The type for NFAs *)
      module A : Alphabet.A
      (* states *)
      type state = int
      (* the various inputs *)
      type elem
      type str
      type trans = state -> elem -> state list
      type eps_trans = state -> state list
      (* The nfa type *)
      type t

      val make : int -> eps_trans -> trans -> state list -> t

      val epsilonClose : t -> state list -> state list
      val delta : t -> state list -> elem -> state list
      val deltaStar : t -> state list -> str -> state list
      val accept : t -> str -> bool

      (* Returns the accepted strings of at most given length *)
      val acceptedStrings : t -> int -> str list

   end

module Make(A : Alphabet.A) =
   struct
      module A = A
      type elem = A.elem
      type str = A.t
      type state = int
      type trans = state -> elem -> state list
      type eps_trans = state -> state list

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

   end
