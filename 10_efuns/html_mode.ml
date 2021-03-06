# 2 "efuns/html_mode.mll"
 
  
  open Interface
    
open Lexing 
  
type token =
| OPEN_TAG
| CLOSE_TAG
| DOCTYPE
| AMPERSAND
| COMMENT
| NORMAL
| ERROR
| EOF

  
let tokens = []
  
let token_to_string token =
  List.assoc token tokens

let lexer_start = ref 0
let position lexbuf =
  let b = lexeme_start lexbuf in
  let e = lexeme_end lexbuf in
  b + !lexer_start, e - b

let start_pos = ref 0
  
let end_pos lexbuf =
  let b = !start_pos in
  let e = lexeme_end lexbuf in
  b + !lexer_start, e - b


# 39 "efuns/html_mode.ml"
let __ocaml_lex_tables = {
  Lexing.lex_base = 
   "\000\000\248\255\249\255\250\255\000\000\002\000\001\000\254\255\
    \002\000\000\000\253\255\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\001\000\252\255\074\000\161\000\255\255\028\000\
    \010\001\097\001\175\001\033\002\111\002\007\000\009\000\016\000\
    \027\000\225\002\047\003\037\000\002\000\038\000\000\000\035\000\
    \039\000\036\000\004\000\073\000\105\003\251\255\180\003\248\000\
    \255\001";
  Lexing.lex_backtrk = 
   "\000\000\255\255\255\255\255\255\004\000\000\000\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\001\000\255\255\255\255\
    \255\255\255\255\000\000\255\255\001\000\000\000\001\000\000\000\
    \255\255\003\000\000\000\004\000\255\255\000\000\255\255\003\000\
    \000\000\255\255\002\000\255\255\255\255\255\255\003\000\004\000\
    \002\000";
  Lexing.lex_default = 
   "\001\000\000\000\000\000\000\000\255\255\255\255\255\255\000\000\
    \255\255\255\255\000\000\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\018\000\000\000\007\000\023\000\000\000\023\000\
    \023\000\007\000\255\255\019\000\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\037\000\255\255\037\000\255\255\040\000\
    \040\000\010\000\255\255\255\255\045\000\000\000\255\255\255\255\
    \255\255";
  Lexing.lex_trans = 
   "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\005\000\005\000\005\000\005\000\005\000\000\000\005\000\
    \029\000\029\000\032\000\032\000\029\000\000\000\032\000\000\000\
    \000\000\031\000\031\000\000\000\000\000\031\000\000\000\000\000\
    \005\000\006\000\005\000\011\000\032\000\032\000\002\000\029\000\
    \032\000\032\000\038\000\000\000\000\000\010\000\009\000\007\000\
    \031\000\043\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\032\000\004\000\008\000\000\000\019\000\
    \036\000\255\255\007\000\014\000\012\000\018\000\031\000\010\000\
    \255\255\010\000\007\000\019\000\255\255\255\255\255\255\013\000\
    \017\000\042\000\043\000\043\000\015\000\000\000\043\000\000\000\
    \031\000\016\000\022\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\014\000\012\000\018\000\000\000\000\000\
    \000\000\043\000\000\000\000\000\000\000\000\000\000\000\013\000\
    \017\000\000\000\000\000\000\000\015\000\000\000\000\000\021\000\
    \021\000\016\000\021\000\021\000\021\000\021\000\021\000\021\000\
    \021\000\021\000\021\000\021\000\000\000\000\000\000\000\022\000\
    \000\000\000\000\000\000\021\000\021\000\021\000\021\000\021\000\
    \021\000\021\000\021\000\021\000\021\000\021\000\021\000\021\000\
    \021\000\021\000\021\000\021\000\021\000\021\000\021\000\021\000\
    \021\000\021\000\021\000\021\000\021\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\021\000\021\000\021\000\021\000\021\000\
    \021\000\021\000\021\000\021\000\021\000\021\000\021\000\021\000\
    \021\000\021\000\021\000\021\000\021\000\021\000\021\000\021\000\
    \021\000\021\000\021\000\021\000\021\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\024\000\024\000\
    \000\000\024\000\024\000\024\000\024\000\024\000\024\000\024\000\
    \024\000\024\000\024\000\000\000\000\000\000\000\000\000\022\000\
    \000\000\000\000\024\000\024\000\024\000\024\000\024\000\024\000\
    \024\000\024\000\024\000\024\000\024\000\024\000\024\000\024\000\
    \024\000\024\000\024\000\024\000\024\000\024\000\024\000\024\000\
    \024\000\024\000\024\000\024\000\000\000\000\000\000\000\000\000\
    \003\000\255\255\024\000\024\000\024\000\024\000\024\000\024\000\
    \024\000\024\000\024\000\024\000\024\000\024\000\024\000\024\000\
    \024\000\024\000\024\000\024\000\024\000\024\000\024\000\024\000\
    \024\000\024\000\024\000\024\000\255\255\000\000\000\000\000\000\
    \000\000\000\000\000\000\255\255\007\000\255\255\255\255\255\255\
    \048\000\048\000\048\000\048\000\048\000\048\000\048\000\048\000\
    \048\000\048\000\000\000\000\000\000\000\000\000\000\000\024\000\
    \024\000\000\000\024\000\024\000\024\000\024\000\024\000\024\000\
    \024\000\024\000\024\000\024\000\000\000\000\000\000\000\000\000\
    \022\000\000\000\255\255\024\000\024\000\024\000\024\000\024\000\
    \024\000\024\000\024\000\024\000\024\000\024\000\024\000\024\000\
    \024\000\024\000\024\000\024\000\024\000\024\000\024\000\024\000\
    \024\000\024\000\024\000\024\000\024\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\024\000\024\000\024\000\024\000\024\000\
    \024\000\024\000\024\000\024\000\024\000\024\000\024\000\024\000\
    \024\000\024\000\024\000\024\000\024\000\024\000\024\000\024\000\
    \024\000\024\000\024\000\024\000\024\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\026\000\026\000\
    \000\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\255\255\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\000\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\255\255\000\000\000\000\000\000\000\000\000\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\029\000\029\000\000\000\000\000\029\000\048\000\
    \048\000\048\000\048\000\048\000\048\000\048\000\048\000\048\000\
    \048\000\000\000\022\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\029\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\028\000\028\000\
    \000\000\028\000\028\000\028\000\028\000\028\000\028\000\028\000\
    \028\000\028\000\028\000\000\000\000\000\000\000\000\000\010\000\
    \000\000\255\255\028\000\028\000\028\000\028\000\028\000\028\000\
    \028\000\028\000\028\000\028\000\028\000\028\000\028\000\028\000\
    \028\000\028\000\028\000\028\000\028\000\028\000\028\000\028\000\
    \028\000\028\000\028\000\028\000\000\000\000\000\000\000\000\000\
    \028\000\000\000\028\000\028\000\028\000\028\000\028\000\028\000\
    \028\000\028\000\028\000\028\000\028\000\028\000\028\000\028\000\
    \028\000\028\000\028\000\028\000\028\000\028\000\028\000\028\000\
    \028\000\028\000\028\000\028\000\028\000\028\000\000\000\028\000\
    \028\000\028\000\028\000\028\000\028\000\028\000\028\000\028\000\
    \028\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \028\000\028\000\028\000\028\000\028\000\028\000\028\000\028\000\
    \028\000\028\000\028\000\028\000\028\000\028\000\028\000\028\000\
    \028\000\028\000\028\000\028\000\028\000\028\000\028\000\028\000\
    \028\000\028\000\000\000\000\000\000\000\000\000\028\000\000\000\
    \028\000\028\000\028\000\028\000\028\000\028\000\028\000\028\000\
    \028\000\028\000\028\000\028\000\028\000\028\000\028\000\028\000\
    \028\000\028\000\028\000\028\000\028\000\028\000\028\000\028\000\
    \028\000\028\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\007\000\000\000\000\000\000\000\000\000\
    \010\000\000\000\000\000\000\000\000\000\000\000\034\000\034\000\
    \000\000\034\000\034\000\034\000\034\000\034\000\034\000\034\000\
    \034\000\034\000\034\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\255\255\034\000\034\000\034\000\034\000\034\000\034\000\
    \034\000\034\000\034\000\034\000\034\000\034\000\034\000\034\000\
    \034\000\034\000\034\000\034\000\034\000\034\000\034\000\034\000\
    \034\000\034\000\034\000\034\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\034\000\034\000\034\000\034\000\034\000\034\000\
    \034\000\034\000\034\000\034\000\034\000\034\000\034\000\034\000\
    \034\000\034\000\034\000\034\000\034\000\034\000\034\000\034\000\
    \034\000\034\000\034\000\034\000\034\000\034\000\000\000\034\000\
    \034\000\034\000\034\000\034\000\034\000\034\000\034\000\034\000\
    \034\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \034\000\034\000\034\000\034\000\034\000\034\000\034\000\034\000\
    \034\000\034\000\034\000\034\000\034\000\034\000\034\000\034\000\
    \034\000\034\000\034\000\034\000\034\000\034\000\034\000\034\000\
    \034\000\034\000\000\000\000\000\047\000\000\000\000\000\000\000\
    \034\000\034\000\034\000\034\000\034\000\034\000\034\000\034\000\
    \034\000\034\000\034\000\034\000\034\000\034\000\034\000\034\000\
    \034\000\034\000\034\000\034\000\034\000\034\000\034\000\034\000\
    \034\000\034\000\046\000\046\000\046\000\046\000\046\000\046\000\
    \046\000\046\000\046\000\046\000\046\000\046\000\046\000\046\000\
    \046\000\046\000\046\000\046\000\046\000\046\000\046\000\046\000\
    \046\000\046\000\046\000\046\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\046\000\046\000\046\000\046\000\046\000\046\000\
    \046\000\046\000\046\000\046\000\046\000\046\000\046\000\046\000\
    \046\000\046\000\046\000\046\000\046\000\046\000\046\000\046\000\
    \046\000\046\000\046\000\046\000\046\000\046\000\046\000\046\000\
    \046\000\046\000\046\000\046\000\046\000\046\000\000\000\007\000\
    \000\000\000\000\000\000\000\000\000\000\046\000\046\000\046\000\
    \046\000\046\000\046\000\046\000\046\000\046\000\046\000\046\000\
    \046\000\046\000\046\000\046\000\046\000\046\000\046\000\046\000\
    \046\000\046\000\046\000\046\000\046\000\046\000\046\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\046\000\046\000\046\000\
    \046\000\046\000\046\000\046\000\046\000\046\000\046\000\046\000\
    \046\000\046\000\046\000\046\000\046\000\046\000\046\000\046\000\
    \046\000\046\000\046\000\046\000\046\000\046\000\046\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\255\255\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000";
  Lexing.lex_check = 
   "\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\000\000\000\000\005\000\005\000\000\000\255\255\005\000\
    \029\000\029\000\030\000\030\000\029\000\255\255\030\000\255\255\
    \255\255\031\000\031\000\255\255\255\255\031\000\255\255\255\255\
    \000\000\004\000\005\000\008\000\032\000\032\000\000\000\029\000\
    \032\000\030\000\036\000\255\255\255\255\009\000\006\000\004\000\
    \031\000\042\000\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\032\000\000\000\006\000\255\255\018\000\
    \035\000\037\000\038\000\013\000\011\000\017\000\030\000\035\000\
    \037\000\039\000\039\000\035\000\037\000\040\000\040\000\012\000\
    \016\000\041\000\043\000\043\000\014\000\255\255\043\000\255\255\
    \032\000\015\000\023\000\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\013\000\011\000\017\000\255\255\255\255\
    \255\255\043\000\255\255\255\255\255\255\255\255\255\255\012\000\
    \016\000\255\255\255\255\255\255\014\000\255\255\255\255\020\000\
    \020\000\015\000\020\000\020\000\020\000\020\000\020\000\020\000\
    \020\000\020\000\020\000\020\000\255\255\255\255\255\255\043\000\
    \255\255\255\255\255\255\020\000\020\000\020\000\020\000\020\000\
    \020\000\020\000\020\000\020\000\020\000\020\000\020\000\020\000\
    \020\000\020\000\020\000\020\000\020\000\020\000\020\000\020\000\
    \020\000\020\000\020\000\020\000\020\000\255\255\255\255\255\255\
    \255\255\255\255\255\255\020\000\020\000\020\000\020\000\020\000\
    \020\000\020\000\020\000\020\000\020\000\020\000\020\000\020\000\
    \020\000\020\000\020\000\020\000\020\000\020\000\020\000\020\000\
    \020\000\020\000\020\000\020\000\020\000\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\021\000\021\000\
    \255\255\021\000\021\000\021\000\021\000\021\000\021\000\021\000\
    \021\000\021\000\021\000\255\255\255\255\255\255\255\255\021\000\
    \255\255\255\255\021\000\021\000\021\000\021\000\021\000\021\000\
    \021\000\021\000\021\000\021\000\021\000\021\000\021\000\021\000\
    \021\000\021\000\021\000\021\000\021\000\021\000\021\000\021\000\
    \021\000\021\000\021\000\021\000\255\255\255\255\255\255\255\255\
    \000\000\018\000\021\000\021\000\021\000\021\000\021\000\021\000\
    \021\000\021\000\021\000\021\000\021\000\021\000\021\000\021\000\
    \021\000\021\000\021\000\021\000\021\000\021\000\021\000\021\000\
    \021\000\021\000\021\000\021\000\023\000\255\255\255\255\255\255\
    \255\255\255\255\255\255\039\000\041\000\035\000\037\000\040\000\
    \047\000\047\000\047\000\047\000\047\000\047\000\047\000\047\000\
    \047\000\047\000\255\255\255\255\255\255\255\255\255\255\024\000\
    \024\000\255\255\024\000\024\000\024\000\024\000\024\000\024\000\
    \024\000\024\000\024\000\024\000\255\255\255\255\255\255\255\255\
    \024\000\255\255\020\000\024\000\024\000\024\000\024\000\024\000\
    \024\000\024\000\024\000\024\000\024\000\024\000\024\000\024\000\
    \024\000\024\000\024\000\024\000\024\000\024\000\024\000\024\000\
    \024\000\024\000\024\000\024\000\024\000\255\255\255\255\255\255\
    \255\255\255\255\255\255\024\000\024\000\024\000\024\000\024\000\
    \024\000\024\000\024\000\024\000\024\000\024\000\024\000\024\000\
    \024\000\024\000\024\000\024\000\024\000\024\000\024\000\024\000\
    \024\000\024\000\024\000\024\000\024\000\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\025\000\025\000\
    \255\255\025\000\025\000\025\000\025\000\025\000\025\000\025\000\
    \025\000\025\000\025\000\255\255\255\255\255\255\255\255\255\255\
    \255\255\021\000\025\000\025\000\025\000\025\000\025\000\025\000\
    \025\000\025\000\025\000\025\000\025\000\025\000\025\000\025\000\
    \025\000\025\000\025\000\025\000\025\000\025\000\025\000\025\000\
    \025\000\025\000\025\000\025\000\255\255\255\255\255\255\255\255\
    \255\255\255\255\025\000\025\000\025\000\025\000\025\000\025\000\
    \025\000\025\000\025\000\025\000\025\000\025\000\025\000\025\000\
    \025\000\025\000\025\000\025\000\025\000\025\000\025\000\025\000\
    \025\000\025\000\025\000\025\000\026\000\026\000\255\255\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\024\000\255\255\255\255\255\255\255\255\255\255\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\027\000\027\000\255\255\255\255\027\000\048\000\
    \048\000\048\000\048\000\048\000\048\000\048\000\048\000\048\000\
    \048\000\255\255\048\000\255\255\255\255\255\255\255\255\255\255\
    \255\255\027\000\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\027\000\027\000\
    \255\255\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\255\255\255\255\255\255\255\255\027\000\
    \255\255\025\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\027\000\255\255\255\255\255\255\255\255\
    \027\000\255\255\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\027\000\028\000\028\000\255\255\028\000\
    \028\000\028\000\028\000\028\000\028\000\028\000\028\000\028\000\
    \028\000\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \028\000\028\000\028\000\028\000\028\000\028\000\028\000\028\000\
    \028\000\028\000\028\000\028\000\028\000\028\000\028\000\028\000\
    \028\000\028\000\028\000\028\000\028\000\028\000\028\000\028\000\
    \028\000\028\000\255\255\255\255\255\255\255\255\028\000\255\255\
    \028\000\028\000\028\000\028\000\028\000\028\000\028\000\028\000\
    \028\000\028\000\028\000\028\000\028\000\028\000\028\000\028\000\
    \028\000\028\000\028\000\028\000\028\000\028\000\028\000\028\000\
    \028\000\028\000\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\033\000\255\255\255\255\255\255\255\255\
    \033\000\255\255\255\255\255\255\255\255\255\255\033\000\033\000\
    \255\255\033\000\033\000\033\000\033\000\033\000\033\000\033\000\
    \033\000\033\000\033\000\255\255\255\255\255\255\255\255\255\255\
    \255\255\027\000\033\000\033\000\033\000\033\000\033\000\033\000\
    \033\000\033\000\033\000\033\000\033\000\033\000\033\000\033\000\
    \033\000\033\000\033\000\033\000\033\000\033\000\033\000\033\000\
    \033\000\033\000\033\000\033\000\255\255\255\255\255\255\255\255\
    \255\255\255\255\033\000\033\000\033\000\033\000\033\000\033\000\
    \033\000\033\000\033\000\033\000\033\000\033\000\033\000\033\000\
    \033\000\033\000\033\000\033\000\033\000\033\000\033\000\033\000\
    \033\000\033\000\033\000\033\000\034\000\034\000\255\255\034\000\
    \034\000\034\000\034\000\034\000\034\000\034\000\034\000\034\000\
    \034\000\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \034\000\034\000\034\000\034\000\034\000\034\000\034\000\034\000\
    \034\000\034\000\034\000\034\000\034\000\034\000\034\000\034\000\
    \034\000\034\000\034\000\034\000\034\000\034\000\034\000\034\000\
    \034\000\034\000\255\255\255\255\044\000\255\255\255\255\255\255\
    \034\000\034\000\034\000\034\000\034\000\034\000\034\000\034\000\
    \034\000\034\000\034\000\034\000\034\000\034\000\034\000\034\000\
    \034\000\034\000\034\000\034\000\034\000\034\000\034\000\034\000\
    \034\000\034\000\044\000\044\000\044\000\044\000\044\000\044\000\
    \044\000\044\000\044\000\044\000\044\000\044\000\044\000\044\000\
    \044\000\044\000\044\000\044\000\044\000\044\000\044\000\044\000\
    \044\000\044\000\044\000\044\000\255\255\255\255\255\255\255\255\
    \255\255\255\255\044\000\044\000\044\000\044\000\044\000\044\000\
    \044\000\044\000\044\000\044\000\044\000\044\000\044\000\044\000\
    \044\000\044\000\044\000\044\000\044\000\044\000\044\000\044\000\
    \044\000\044\000\044\000\044\000\046\000\046\000\046\000\046\000\
    \046\000\046\000\046\000\046\000\046\000\046\000\255\255\046\000\
    \255\255\255\255\255\255\255\255\255\255\046\000\046\000\046\000\
    \046\000\046\000\046\000\046\000\046\000\046\000\046\000\046\000\
    \046\000\046\000\046\000\046\000\046\000\046\000\046\000\046\000\
    \046\000\046\000\046\000\046\000\046\000\046\000\046\000\255\255\
    \255\255\255\255\255\255\255\255\255\255\046\000\046\000\046\000\
    \046\000\046\000\046\000\046\000\046\000\046\000\046\000\046\000\
    \046\000\046\000\046\000\046\000\046\000\046\000\046\000\046\000\
    \046\000\046\000\046\000\046\000\046\000\046\000\046\000\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\044\000\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255";
  Lexing.lex_base_code = 
   "";
  Lexing.lex_backtrk_code = 
   "";
  Lexing.lex_default_code = 
   "";
  Lexing.lex_trans_code = 
   "";
  Lexing.lex_check_code = 
   "";
  Lexing.lex_code = 
   "";
}

let rec token lexbuf =
    __ocaml_lex_token_rec lexbuf 0
and __ocaml_lex_token_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 42 "efuns/html_mode.mll"
            ( 
      token lexbuf )
# 391 "efuns/html_mode.ml"

  | 1 ->
# 44 "efuns/html_mode.mll"
           ( 
      start_pos := lexeme_start lexbuf;
      close_tag lexbuf )
# 398 "efuns/html_mode.ml"

  | 2 ->
# 47 "efuns/html_mode.mll"
           (       
      start_pos := lexeme_start lexbuf;
      comment lexbuf )
# 405 "efuns/html_mode.ml"

  | 3 ->
# 51 "efuns/html_mode.mll"
                   ( 
      position lexbuf, DOCTYPE )
# 411 "efuns/html_mode.ml"

  | 4 ->
# 53 "efuns/html_mode.mll"
           ( 
      start_pos := lexeme_start lexbuf;
      open_tag lexbuf )
# 418 "efuns/html_mode.ml"

  | 5 ->
# 56 "efuns/html_mode.mll"
           ( position lexbuf, EOF )
# 423 "efuns/html_mode.ml"

  | 6 ->
# 57 "efuns/html_mode.mll"
           ( 
      start_pos := lexeme_start lexbuf;
      ampersand lexbuf )
# 430 "efuns/html_mode.ml"

  | 7 ->
# 60 "efuns/html_mode.mll"
           ( token lexbuf )
# 435 "efuns/html_mode.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; __ocaml_lex_token_rec lexbuf __ocaml_lex_state

and close_tag lexbuf =
    __ocaml_lex_close_tag_rec lexbuf 20
and __ocaml_lex_close_tag_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 64 "efuns/html_mode.mll"
                ( end_pos lexbuf, CLOSE_TAG )
# 446 "efuns/html_mode.ml"

  | 1 ->
# 65 "efuns/html_mode.mll"
       ( end_pos lexbuf, ERROR )
# 451 "efuns/html_mode.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; __ocaml_lex_close_tag_rec lexbuf __ocaml_lex_state

and open_tag lexbuf =
    __ocaml_lex_open_tag_rec lexbuf 25
and __ocaml_lex_open_tag_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 68 "efuns/html_mode.mll"
                                       ( attribs lexbuf )
# 462 "efuns/html_mode.ml"

  | 1 ->
# 69 "efuns/html_mode.mll"
      ( end_pos lexbuf, ERROR )
# 467 "efuns/html_mode.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; __ocaml_lex_open_tag_rec lexbuf __ocaml_lex_state

and attribs lexbuf =
    __ocaml_lex_attribs_rec lexbuf 27
and __ocaml_lex_attribs_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 72 "efuns/html_mode.mll"
                          ( attribs lexbuf )
# 478 "efuns/html_mode.ml"

  | 1 ->
# 74 "efuns/html_mode.mll"
      ( tag_attrib lexbuf; attribs lexbuf )
# 483 "efuns/html_mode.ml"

  | 2 ->
# 75 "efuns/html_mode.mll"
        ( end_pos lexbuf, OPEN_TAG )
# 488 "efuns/html_mode.ml"

  | 3 ->
# 76 "efuns/html_mode.mll"
      ( end_pos lexbuf, ERROR )
# 493 "efuns/html_mode.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; __ocaml_lex_attribs_rec lexbuf __ocaml_lex_state

and tag_attrib lexbuf =
    __ocaml_lex_tag_attrib_rec lexbuf 30
and __ocaml_lex_tag_attrib_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 79 "efuns/html_mode.mll"
                                                    ( attribvalue lexbuf )
# 504 "efuns/html_mode.ml"

  | 1 ->
# 80 "efuns/html_mode.mll"
           ( () )
# 509 "efuns/html_mode.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; __ocaml_lex_tag_attrib_rec lexbuf __ocaml_lex_state

and attribvalue lexbuf =
    __ocaml_lex_attribvalue_rec lexbuf 33
and __ocaml_lex_attribvalue_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 83 "efuns/html_mode.mll"
                                             ( () )
# 520 "efuns/html_mode.ml"

  | 1 ->
# 84 "efuns/html_mode.mll"
              ( inquote lexbuf )
# 525 "efuns/html_mode.ml"

  | 2 ->
# 85 "efuns/html_mode.mll"
              ( insingle lexbuf )
# 530 "efuns/html_mode.ml"

  | 3 ->
# 86 "efuns/html_mode.mll"
              ( () )
# 535 "efuns/html_mode.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; __ocaml_lex_attribvalue_rec lexbuf __ocaml_lex_state

and inquote lexbuf =
    __ocaml_lex_inquote_rec lexbuf 35
and __ocaml_lex_inquote_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 89 "efuns/html_mode.mll"
                        ( inquote lexbuf )
# 546 "efuns/html_mode.ml"

  | 1 ->
# 90 "efuns/html_mode.mll"
                                   ( inquote lexbuf )
# 551 "efuns/html_mode.ml"

  | 2 ->
# 91 "efuns/html_mode.mll"
        ( () )
# 556 "efuns/html_mode.ml"

  | 3 ->
# 92 "efuns/html_mode.mll"
        ( let _ = ampersand lexbuf in inquote lexbuf )
# 561 "efuns/html_mode.ml"

  | 4 ->
# 93 "efuns/html_mode.mll"
        ( () )
# 566 "efuns/html_mode.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; __ocaml_lex_inquote_rec lexbuf __ocaml_lex_state

and insingle lexbuf =
    __ocaml_lex_insingle_rec lexbuf 39
and __ocaml_lex_insingle_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 96 "efuns/html_mode.mll"
                  ( insingle lexbuf )
# 577 "efuns/html_mode.ml"

  | 1 ->
# 97 "efuns/html_mode.mll"
         ( () )
# 582 "efuns/html_mode.ml"

  | 2 ->
# 98 "efuns/html_mode.mll"
        ( let _ = ampersand lexbuf in insingle lexbuf )
# 587 "efuns/html_mode.ml"

  | 3 ->
# 99 "efuns/html_mode.mll"
        ( () )
# 592 "efuns/html_mode.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; __ocaml_lex_insingle_rec lexbuf __ocaml_lex_state

and comment lexbuf =
    __ocaml_lex_comment_rec lexbuf 41
and __ocaml_lex_comment_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 102 "efuns/html_mode.mll"
                                    ( end_pos lexbuf, COMMENT )
# 603 "efuns/html_mode.ml"

  | 1 ->
# 103 "efuns/html_mode.mll"
         ( end_pos lexbuf, ERROR )
# 608 "efuns/html_mode.ml"

  | 2 ->
# 104 "efuns/html_mode.mll"
       ( comment lexbuf )
# 613 "efuns/html_mode.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; __ocaml_lex_comment_rec lexbuf __ocaml_lex_state

and ampersand lexbuf =
    __ocaml_lex_ampersand_rec lexbuf 44
and __ocaml_lex_ampersand_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 107 "efuns/html_mode.mll"
                       ( end_pos lexbuf, AMPERSAND )
# 624 "efuns/html_mode.ml"

  | 1 ->
# 109 "efuns/html_mode.mll"
      ( end_pos lexbuf, AMPERSAND )
# 629 "efuns/html_mode.ml"

  | 2 ->
# 112 "efuns/html_mode.mll"
                   ( end_pos lexbuf, AMPERSAND )
# 634 "efuns/html_mode.ml"

  | 3 ->
# 114 "efuns/html_mode.mll"
    ( end_pos lexbuf, AMPERSAND )
# 639 "efuns/html_mode.ml"

  | 4 ->
# 115 "efuns/html_mode.mll"
      ( end_pos lexbuf, ERROR )
# 644 "efuns/html_mode.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; __ocaml_lex_ampersand_rec lexbuf __ocaml_lex_state

;;

# 117 "efuns/html_mode.mll"
 
(* val token : lexbuf -> token *)

(***********************************************************************)
(*                                                                     *)
(*                           xlib for Ocaml                            *)
(*                                                                     *)
(*       Fabrice Le Fessant, projet Para/SOR, INRIA Rocquencourt       *)
(*                                                                     *)
(*  Copyright 1998 Institut National de Recherche en Informatique et   *)
(*  Automatique.  Distributed only by permission.                      *)
(*                                                                     *)
(***********************************************************************)

open Text
open Efuns
open Interactive
open Simple
open Select
open Compil
open Eval
open Complex
open Abbrevs  
open Keymap
open Window
  
let lexing text start_point end_point =
  lexer_start := get_position text start_point;
  Text.lexing text start_point end_point

(*********************** colors ***********************)
let html_color_region location buf start_point end_point =
  let red_attr = make_attr (get_color location "red") 1 0 false in
  let yellow_attr = make_attr (get_color location "yellow") 1 0 false in
  let blue_attr = make_attr (get_color location "blue") 1 0 false in
  let gray_attr = make_attr (get_color location "gray") 1 0 false in
  let text = buf.buf_text in
  let curseur = Text.add_point text in
  let lexbuf = lexing text start_point end_point in
  let rec iter prev_tok lexbuf =
    let (pos,len), token = token lexbuf in
    (match token with
        EOF  -> raise Exit
      | COMMENT ->
          set_position text curseur pos;
          set_attr text curseur len blue_attr
      | ERROR ->
          set_position text curseur pos;
          set_attr text curseur len blue_attr
      
      | OPEN_TAG
      | CLOSE_TAG ->
          set_position text curseur pos;
          set_attr text curseur len yellow_attr
      | AMPERSAND
      | DOCTYPE ->
          set_position text curseur pos;
          set_attr text curseur len gray_attr            
      | _ -> ());
    iter token lexbuf
  in
  try
    iter COMMENT lexbuf
  with
    _ ->
      buf.buf_modified <- buf.buf_modified + 1;
      remove_point text curseur

let html_color_buffer buf =
  let text = buf.buf_text in
  let start_point = Text.add_point text in
  let end_point = Text.add_point text in
  set_position text end_point (size text);
  html_color_region buf.buf_location buf start_point end_point;
  remove_point text start_point;
  remove_point text end_point

let html_color frame =
  html_color_buffer frame.frm_buffer

(************************  abbreviations ********************)

let abbreviations = []

(*********************  structures ********************)

let structures = [
    [c_c; NormalMap, Char.code 'h'], "<a href=\"^^\"> ^^ </a> ^^";
    [c_c; NormalMap, Char.code 'n'], "<a name=\"^^\"> ^^ </a> ^^";
    [c_c; NormalMap, Char.code 'b'], 
"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\"
\"http://www.w3.org/TR/REC-html40/strict.dtd\">
<html> <head>
<title> ^^ </title>
</head>
<body>
^^
<address>
Fabrice Le Fessant<br>
Tel travail: 01 69 33 52 93<br>
<a href=\"mailto:fabrice.le_fessant@inria.fr\">fabrice.le_fessant@inria.fr</a>
</address>
<hr>
</body> </html>
";
    [c_c; NormalMap, Char.code '1'], "<H1> ^^ </H1> ^^";
    [c_c; NormalMap, Char.code '2'], "<H2> ^^ </H2> ^^";
    [c_c; NormalMap, Char.code '3'], "<H3> ^^ </H3> ^^";
    [c_c; NormalMap, Char.code '4'], "<H4> ^^ </H4> ^^";
    [c_c; NormalMap, Char.code '5'], "<H5> ^^ </H5> ^^";
    [c_c; NormalMap, Char.code 'l'], "<UL>\n<LI> ^^ </LI>\n^^ </UL> ^^";
    [c_c; NormalMap, Char.code 'i'], "<LI> ^^ </LI>\n ^^";
    ]
  
  
(*********************  installation ********************)

let c_c = (ControlMap,Char.code 'c')
let install buf =
  html_color_buffer buf; 
  buf.buf_syntax_table.(Char.code '_') <- true;
  buf.buf_syntax_table.(Char.code '-') <- true;
  buf.buf_syntax_table.(Char.code '+') <- true;
  buf.buf_syntax_table.(Char.code '*') <- true;
  Accents_mode.install buf;
  let abbrevs = Hashtbl.create 11 in
  set_local buf abbrev_table abbrevs;
  Utils.hash_add_assoc abbrevs abbreviations;
  install_structures buf structures;
  ()

let mode = Ebuffer.new_major_mode "HTML" [install]
let _ = 
  add_major_key mode [c_c; ControlMap,Char.code 'l']
  "html-color-buffer" (fun frame -> html_color_buffer frame.frm_buffer);
  let map = mode.maj_map in
  Keymap.add_binding map [NormalMap, Char.code ' '] 
    (fun frame ->
      expand_sabbrev frame;
      electric_insert_space frame);
  Keymap.add_binding map [MetaMap, Char.code 'q'] fill_paragraph;
  List.iter (fun char ->
      Keymap.add_binding map [NormalMap, Char.code char]
        (fun frame ->
          self_insert_command frame;
          highlight_paren frame)
  ) ['>']
  
let _ =  
  Efuns.add_start_hook (fun location ->
      add_interactive (location.loc_map) "html-mode" 
      (fun frame -> install frame.frm_buffer);
    let alist = get_global location Ebuffer.modes_alist in
    set_global location Ebuffer.modes_alist 
        ((".*\.\(html\|htm\)",mode)
        :: alist)
      )  

# 809 "efuns/html_mode.ml"
