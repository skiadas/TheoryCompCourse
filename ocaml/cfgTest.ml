(*
   Context Free languages test file

   ocamlc -o cfg_test cfg.mli cfg.ml cfg_test.ml
*)

open Cfg

let cfg1 = make {
   vars= ["S"];
   terms= ["a"; "b"];
   prods= [("S", []);
           ("S", [T "a"; V "S"; T "a"]);
           ("S", [T "b"; V "S"; T "b"])];
   start= "S";
};;

print cfg1;;

let (ss1, rhss1) = advance cfg1 [[V "S"]];;
let (ss2, rhss2) = advance cfg1 rhss1;;
let (ss3, rhss3) = advance cfg1 rhss2;;

explore cfg1 5;;
