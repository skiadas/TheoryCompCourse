type 'a t = 'a list

let empty = []
let rec member a lst =
   match lst with
      []        -> false
    | x :: rest -> a = x || member a rest

let add a lst =
   if member a lst
   then lst
   else a :: lst

let rec unique lst =
   match lst with
      []      -> lst
    | x :: [] -> lst
    | x :: rest    -> let rest' = unique rest in
                      if member x rest'
                      then rest'
                      else x :: rest'

let to_list   lst = lst
let from_list lst = unique lst

(* alternative for from_list:
   let from_list lst = List.fold_right add lst empty
*)


