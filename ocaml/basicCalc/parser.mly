%{
(*
   For seeing information about generated tables:
   ocamlyacc -v parser.mly         # generates parser.output
*)

(* Everything between the percent+brace symbols will be
   copied as-is into the parser.ml file *)

open Calc

%}

%token <int> INT
%token <float> FLOAT
%token <string> ID
%token EQ
%token PLUS MINUS TIMES DIV
%token LPAREN RPAREN
%token EOL
%right EQ               /* Assignment is right-associative:   a = b = 3 */
%right CALL             /* Function calls are right-associative */
%left PLUS MINUS        /* lowest precedence */
%left TIMES DIV         /* medium precedence */
%nonassoc UMINUS        /* highest precedence */
%start main             /* the entry point */
%type <Calc.result> main
%%

main:
    expr EOL                { $1 }
;

expr:
    INT                     { INT_R $1 }
  | FLOAT                   { FLOAT_R $1 }
  | LPAREN expr RPAREN      { $2 }
  | ID EQ expr              { (store $1 $3; $3) }
  | ID                      { fetch $1 }
  | ID expr   %prec CALL    { do_call $1 $2 }
  | expr PLUS expr          { do_op '+' $1 $3 }
  | expr MINUS expr         { do_op '-' $1 $3 }
  | expr TIMES expr         { do_op '*' $1 $3 }
  | expr DIV expr           { do_op '/' $1 $3 }
