(* File calc.ml

   For seeing information about generated tables:
   ocamlyacc -v parser.mly         # generates parser.output

   To run:

   ocamllex lexer.mll       # generates lexer.ml
   ocamlyacc parser.mly     # generates parser.ml and parser.mli
   ocamlc -c calc.mli parser.mli lexer.ml parser.ml calc.ml driver.ml
   ocamlc -o calc lexer.cmo calc.cmo parser.cmo driver.cmo
*)

open Calc

let _ =
  try
    let lexbuf = Lexing.from_channel stdin in
    while true do
      let result = Parser.main Lexer.token lexbuf in
        (match result with
          INT_R i   -> print_int i
        | FLOAT_R f -> print_float f);
        print_newline(); flush stdout
    done
  with Lexer.Eof ->
    exit 0
