{
(* Compile with

   ocamllex lexer.mll
   ocamlc -c lexer.ml
*)

open Lexing

exception Eof

type tokens = INT of int
            | FLOAT of float
            | LPAREN
            | RPAREN
            | PLUS
            | MINUS
            | TIMES
            | DIVIDE

let print_token tk =
   match tk with
      INT i   -> "INT " ^ string_of_int i
    | FLOAT f -> "FLOAT " ^ string_of_float f
    | LPAREN  -> "LPAREN"
    | RPAREN  -> "RPAREN"
    | PLUS    -> "PLUS"
    | MINUS   -> "MINUS"
    | TIMES   -> "TIMES"
    | DIVIDE  -> "DIVIDE"

}

let digit = ['0'-'9']
let int = '-'? digit+
let frac = '.' digit*
let exp = ['e' 'E'] ['-' '+']? digit+
let float = digit* frac exp?
let white = [' ' '\t']+
let newline = '\r' | '\n' | "\r\n"

rule read = parse
   | white { read lexbuf }
   | newline { read lexbuf }
   | int as i { INT (int_of_string i) }
   | float as f { FLOAT (float_of_string f) }
   | '('  { LPAREN }
   | ')'  { RPAREN }
   | '+'  { PLUS }
   | '-'  { MINUS }
   | '*'  { TIMES }
   | '/'  { DIVIDE }
   | eof  { raise Eof }
