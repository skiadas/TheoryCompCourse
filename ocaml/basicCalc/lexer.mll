(* File lexer.mll *)
{
open Parser        (* The type token is defined in parser.mli *)
exception Eof
}

let digit = ['0'-'9']+
let sign = ['+' '-']
let int = ['-']? digit+
let frac = '.' digit*
let exp = ['e' 'E'] sign? digit+
let float = ['-']? digit* frac exp?
let letter = ['a'-'z' 'A'-'Z']
let alphanum = letter | digit
let id = letter alphanum*
let white = [' ' '\t']+
let newline = '\r' | '\n' | "\r\n"
let assign = '=' | "<-"

rule token = parse
    white          { token lexbuf }     (* skip blanks *)
  | newline        { EOL }
  | int as lxm     { INT (int_of_string lxm) }
  | float as lxm   { FLOAT (float_of_string lxm) }
  | id as lxm      { ID lxm }
  | '+'            { PLUS }
  | '-'            { MINUS }
  | '*'            { TIMES }
  | '/'            { DIV }
  | '('            { LPAREN }
  | ')'            { RPAREN }
  | assign         { EQ }
  | eof            { raise Eof }
