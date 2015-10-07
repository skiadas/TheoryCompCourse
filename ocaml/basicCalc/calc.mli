type result = INT_R of int
            | FLOAT_R of float

exception UnknownIdentifier of string

val store : string -> result -> unit
val fetch : string -> result

val do_op : char -> result -> result -> result

val do_call : string -> result -> result
