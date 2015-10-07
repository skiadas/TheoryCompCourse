(*

   First compile lexer.mll as instructed in that file
   ocamlc -o driver1 lexer.cmo driver1.ml
*)
(* let res = Lexer.read (Lexing.from_channel stdin) *)
let lexbuf = Lexing.from_string "2+3*(1+2 *3)"
in try
      while true do
         let res = Lexer.read lexbuf
         in print_string @@ Lexer.print_token res;
            print_newline ();
            flush stdout
      done
   with Lexer.Eof -> exit 0


