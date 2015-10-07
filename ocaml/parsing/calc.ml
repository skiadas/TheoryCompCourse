(* File calc.ml

   For seeing information about generated tables:
   ocamlyacc -v parser.mly         # generates parser.output

   To run:

   ocamllex lexer2.mll       # generates lexer.ml
   ocamlyacc parser.mly     # generates parser.ml and parser.mli
   ocamlc -c parser.mli lexer2.ml parser.ml calc.ml
   ocamlc -o calc lexer2.cmo parser.cmo calc.cmo
*)
module Lexer = Lexer2

let _ =
  try
    let lexbuf = Lexing.from_channel stdin in
    while true do
      let result = Parser.main Lexer.token lexbuf in
        print_int result; print_newline(); flush stdout
    done
  with Lexer.Eof ->
    exit 0
