(*
   Compile with:

   ocamlc alphabet.mli alphabet.ml dfa.mli dfa.ml
*)
exception InvalidDFA

module type DFA =
   sig
      (* The type for DFAs *)
      module A : Alphabet.A
      (* states start at 0, that always being the start state *)
      type state = int
      (* the various inputs *)
      type elem
      type str
      (* The dfa type *)
      type t

      val make : int -> (state -> elem -> state) -> state list -> t

      val nstates: t -> int
      val final: t -> state list

      val delta : t -> state -> elem -> state
      val deltaStar : t -> state -> str -> state
      val accept : t -> str -> bool

      (* Returns the accepted strings of at most given length *)
      val acceptedStrings : t -> int -> str list

      val union : t -> t -> t
      val intersect : t -> t -> t

      val emptyLang : t
      val emptyString : t
      val oneElem : elem -> t
      val zeroOrMore : elem -> t
      val oneOrMore : elem -> t

      val print : t -> unit
   end

module Make(A : Alphabet.A) =
   struct
      module A = A
      type elem = A.elem
      type str = A.t
      type state = int

      (* State 0 is always the start state *)
      type t = {
         nstates : state;
         delta : state -> elem -> state;
         final : state list;
      }

      (*
         Checks that the provided information is "valid":
         - nstates should be >= 1
         - numbers in final must all be between 0 and nstates-1
         - all states in transitions are between 0 and nstates-1
         - there is a transition for each state and each input
       *)
      let validate { nstates; delta; final } =
         let isValid st = st >=  0 && st < nstates in
         let rec isValidTrans i el = i < 0 || (isValid (delta i el) &&
                                               isValidTrans (i - 1) el)
         in nstates > 0 &&
            List.for_all isValid final &&
            List.for_all (isValidTrans (nstates - 1)) A.allElems

      let make nstates delta final =
         let res = {
               nstates = nstates;
               delta = delta;
               final = final;
            }
         in if validate res then res else raise InvalidDFA


      let nstates { nstates; delta; final } = nstates
      let final { nstates; delta; final } = final
      let delta { nstates; delta; final } = delta

      let deltaStar dfa st es =
         List.fold_left (delta dfa) st es

      let accept ({ nstates; delta; final } as dfa) es =
         List.mem (deltaStar dfa 0 es) final

      let acceptedStrings dfa n =
         List.filter (accept dfa) (A.allStringsLeq n)

      let rec fromTo a b =
         if a > b
         then []
         else a :: fromTo (a + 1) b

      let upTo n = fromTo 0 (n - 1)

      let union { nstates= nstate1; delta= delta1; final= final1 }
                { nstates= nstate2; delta= delta2; final= final2 } =
         let from12 i j = i + nstate2 * j in
         let to12 n = (n mod nstate2, n / nstate2) in
         let nstates = nstate1 * nstate2 in
         let newDelta n a = let (i, j) = to12 n
                            in from12 (delta1 i a) (delta2 j a) in
         let isFinal n =
            let (i, j) = to12 n
            in List.mem i final1 || List.mem j final2
         in {
            nstates= nstates;
            delta= newDelta;
            final= List.filter isFinal (upTo nstates);
         }

      let intersect { nstates= nstate1; delta= delta1; final= final1 }
                    { nstates= nstate2; delta= delta2; final= final2 } =
         let from12 i j = i + nstate2 * j in
         let to12 n = (n mod nstate2, n / nstate2) in
         let nstates = nstate1 * nstate2 in
         let newDelta n a = let (i, j) = to12 n
                            in from12 (delta1 i a) (delta2 j a) in
         let isFinal n =
            let (i, j) = to12 n
            in List.mem i final1 && List.mem j final2
         in {
            nstates= nstates;
            delta= newDelta;
            final= List.filter isFinal (upTo nstates);
         }

      let emptyLang = {
         nstates= 1;
         delta= (fun _ _ -> 0);
         final= [];
      }

      let emptyString = {
         nstates= 2;
         delta= (fun _ _ -> 1);
         final= [0];
      }

      let oneElem a =
         let delta s el =
            match (s, el) with
               (0, _) -> if el = a then 1 else 2
             | _      -> 2
         in {
            nstates= 3;
            delta= delta;
            final= [1];
         }

      let zeroOrMore a =
         let delta s el =
            match (s, el) with
               (0, _) -> if el = a then 0 else 1
             | _      -> 1
         in {
            nstates= 2;
            delta= delta;
            final= [0];
         }

      let oneOrMore a =
         let delta s el =
            match (s, el) with
               (0, _)
             | (1, _) -> if el = a then 1 else 2
             | _      -> 2
         in {
            nstates= 3;
            delta= delta;
            final= [1];
         }

      let print { nstates; delta; final } =
         let sep = String.make 40 '=' in
         let elems= A.allElems in
         let printTransition s el =
               Printf.printf "--(%s)--> %d\n" (A.elemToString el) (delta s el) in
         let isFinal s = if List.mem s final then "(* FINAL *)" else ""
         in begin
            print_endline sep;
            for state = 0 to pred nstates do
               Printf.printf "STATE %d %s\n" state (isFinal state);
               List.iter (printTransition state) elems;
               print_endline ""
            done;
            print_endline sep
         end

   end
