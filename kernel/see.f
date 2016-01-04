\
\  see.f
\
\  Copyright (C) 1999-2001 Illya Kysil
\

CR .( Loading SEE definitions )

CREATE-REPORT @
CREATE-REPORT OFF

BASE @

     VARIABLE  V-PRI
0    CONSTANT  C-PRI

    2VARIABLE 2V-PRI
0 0 2CONSTANT 2C-PRI

       CREATE CREATE-PRI

USER U-PRI 1 CELLS USER-ALLOC

: WRITE-VALUE DUP DECIMAL . ." , 0x" H.8 ;

: CHECK-PRIMITIVE (S xt -- flag )
  DUP >R
  @
  CASE
    OVER >BODY OF
      ." Low-level primitive" TRUE
    ENDOF
    [ ' CREATE-PRI @ ] LITERAL OF
      ." CREATE " TRUE
    ENDOF
    [ ' V-PRI @ ] LITERAL OF
      ." VARIABLE( " R@ EXECUTE WRITE-VALUE ." )" TRUE
    ENDOF
    [ ' C-PRI @ ] LITERAL OF
      ." CONSTANT( " R@ EXECUTE WRITE-VALUE ." )" TRUE
    ENDOF
    [ ' 2V-PRI @ ] LITERAL OF
      ." 2VARIABLE( " R@ EXECUTE WRITE-VALUE ." )" TRUE
    ENDOF
    [ ' 2C-PRI @ ] LITERAL OF
      ." 2CONSTANT( " R@ EXECUTE D. ." )" TRUE
    ENDOF
    [ ' U-PRI @ ] LITERAL OF
      ." USER( " R@ EXECUTE WRITE-VALUE ." )" TRUE
    ENDOF
    [ ' : @ ] LITERAL OF
      R@ >NAME .ID SPACE
      ." XT=0x" R@ H.8 SPACE
      R@ CFA>LATEST WORD-ATTR
      CR FALSE
    ENDOF
    ." Unknown executor" TRUE SWAP
  ENDCASE R-DROP ;

: CHECK-EXIT (S body-addr -- flag )
  @
  CASE
    ['] (;)     OF ." ;"     TRUE ENDOF
    ['] (;CODE) OF ." ;CODE" TRUE ENDOF
    FALSE SWAP
  ENDCASE ;

: WRITE-NEXT-ADDR (S body-addr -- body-addr1 )
  ."  --> 0x" DUP @ H.8 CELL+ ;

: WRITE-LIT (S body-addr -- body-addr1 )
  BASE @ >R
  ." LITERAL = " DUP @ WRITE-VALUE CELL+
  R> BASE ! ;

: WRITE-2LIT (S body-addr -- body-addr1 )
  BASE @ >R
  ." 2LITERAL = " DUP 2@ SWAP 2DUP DECIMAL D. ." , 0x" HEX UD. 2 CELLS+
  R> BASE ! ;

: WRITE-STRING (S body-addr addr count -- body-addr1 )
  [CHAR] " EMIT SPACE TYPE [CHAR] " EMIT ;

: WRITE-S" (S body-addr -- body-addr1 )
  ." S" DUP @ SWAP CELL+ SWAP 2DUP + -ROT WRITE-STRING ;

: WRITE-C" (S body-addr -- body-addr1 )
  ." C" COUNT 2DUP + -ROT WRITE-STRING ;

: WRITE-(TYPE) (S body-addr -- body-addr1 )
  ." (TYPE)" COUNT 2DUP + -ROT WRITE-STRING ;

: WRITE-POSTPONE (S body-addr -- body-addr1 )
  ." POSTPONE " DUP @ >NAME COUNT TYPE CELL+ ;

: WRITE-NAME (S body-addr -- body-addr1 )
  DUP CELL+ SWAP @
  CASE
    [']        LIT OF WRITE-LIT  ENDOF
    [']       2LIT OF WRITE-2LIT ENDOF
    [']    ?BRANCH OF ." ?BRANCH" WRITE-NEXT-ADDR ENDOF
    [']     BRANCH OF ." BRANCH " WRITE-NEXT-ADDR ENDOF
    [']       (DO) OF ." DO     " WRITE-NEXT-ADDR ENDOF
    [']      (?DO) OF ." ?DO    " WRITE-NEXT-ADDR ENDOF
    [']     (LOOP) OF ." LOOP   " WRITE-NEXT-ADDR ENDOF
    [']    (+LOOP) OF ." +LOOP  " WRITE-NEXT-ADDR ENDOF
    [']    (ENDOF) OF ." ENDOF  " WRITE-NEXT-ADDR ENDOF
    [']       (OF) OF ." OF     " WRITE-NEXT-ADDR ENDOF
    [']      (<OF) OF ." <OF    " WRITE-NEXT-ADDR ENDOF
    [']      (>OF) OF ." >OF    " WRITE-NEXT-ADDR ENDOF
    [']     (<OF<) OF ." <OF<   " WRITE-NEXT-ADDR ENDOF
    [']  (ENDCASE) OF ." ENDCASE" ENDOF
    [']       (C") OF WRITE-C" ENDOF
    [']       (S") OF WRITE-S" ENDOF
\    ['] (POSTPONE) OF WRITE-POSTPONE ENDOF
    [']     (DOES) OF ." DOES>" 5 + ENDOF
    [']     (TYPE) OF WRITE-(TYPE)  ENDOF
    DUP >NAME COUNT TYPE 
  ENDCASE ;

: (SEE) (S xt -- )
  DUP
  CHECK-PRIMITIVE IF DROP EXIT THEN
  >BODY 0 >R
  BEGIN
    DUP DUP H.8 SPACE CHECK-EXIT INVERT
  WHILE
    WRITE-NAME SPACE CR
    R> 1+ DUP >R 20 MOD 0= IF ." Press any key to continue..." KEY DROP CR THEN
  REPEAT DROP R-DROP ;

: SEE (S 'name' -- )
  BL WORD DUP COUNT 0= IF EXC-EMPTY-NAME THROW THEN DROP
          DUP  FIND 0= IF EXC-UNDEFINED  THROW THEN NIP
  (SEE) ;

BASE !

CREATE-REPORT !
