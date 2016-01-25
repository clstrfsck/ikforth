\
\  block.f
\
\  Copyright (C) 1999-2004 Illya Kysil
\

CR .( Loading BLOCK definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

S" src\kernel\file.f" REQUIRED

<ENV
             TRUE  CONSTANT BLOCK
             TRUE  CONSTANT BLOCK-EXT
ENV>

1024 CONSTANT BLOCK-SIZE

\ 7.6.1.0790 BLK
USER BLK           1 CELLS USER-ALLOC
USER SCR           1 CELLS USER-ALLOC
USER BLOCK#        1 CELLS USER-ALLOC
USER BLOCK-UPDATED 1 CELLS USER-ALLOC
USER BLOCK-DATA    BLOCK-SIZE 1 + CHARS USER-ALLOC

: ?BLK ?DUP 0= IF EXC-BAD-BLOCK THROW THEN ;

: --> BLK @ ?BLK REFILL DROP ; IMMEDIATE

: EMPTY-BUFFERS 0 BLOCK# ! FALSE BLOCK-UPDATED ! ;

: MAKE-BLOCK-FILE-NAME (S block-num -- c-addr count )
  BASE @ >R HEX
  S>D <# 8 0 DO # LOOP S" blocks\" HOLDS #>
  R> BASE !
;

: WRITE-BLOCK (S block-data block-num -- )
  MAKE-BLOCK-FILE-NAME R/W CREATE-FILE THROW >R
  BLOCK-SIZE R@ WRITE-FILE THROW R> CLOSE-FILE THROW
;

: READ-BLOCK (S block-data block-num -- )
  MAKE-BLOCK-FILE-NAME R/O OPEN-FILE THROW >R
  BLOCK-SIZE
  2DUP BLANK
  R@ READ-FILE THROW DROP R> CLOSE-FILE THROW
;

: BLOCK (S u -- a-addr )
  ?BLK
  BLOCK# @ 0<>
  IF
    BLOCK-UPDATED @
    IF
      BLOCK-DATA BLOCK# @ WRITE-BLOCK
      FALSE BLOCK-UPDATED !
    THEN
  THEN
  DUP BLOCK# @ <>
  IF
    DUP BLOCK# !
    BLOCK-DATA DUP ROT READ-BLOCK
  ELSE
    DROP BLOCK-DATA
  THEN
;

: LIST ?BLK DUP
       SCR ! BLOCK BASE @ SWAP DECIMAL
       ." Block " SCR @ H.8
       16 0 DO CR I S>D <# # # #> TYPE ." . "
               64 OVER OVER TYPE + LOOP DROP BASE ! ;

: SAVE-BUFFERS BLOCK#        @ 0=     IF EXIT THEN
               BLOCK-UPDATED @ INVERT IF EXIT THEN
               BLOCK-DATA BLOCK# @ WRITE-BLOCK
               FALSE BLOCK-UPDATED ! ;

: FLUSH SAVE-BUFFERS EMPTY-BUFFERS ;

: BUFFER (S blk -- addr )
  SAVE-BUFFERS BLOCK# ! BLOCK-DATA ;

: LOAD ?BLK INPUT>R RESET-INPUT BLK ! ['] INTERPRET CATCH R>INPUT THROW ;

: THRU 1+ SWAP ?DO I LOAD LOOP ;

: UPDATE BLOCK# @ 0<> BLOCK-UPDATED ! ;

:NONAME
  BLK @ 0>
  IF
    >IN C@ 63 INVERT AND 64 +
  ELSE
    SOURCE NIP
  THEN >IN C!
; IS \

\ 6.1.2216 SOURCE
\ c-addr is the address of, and u is the number of characters in
\ the input buffer. 
\ D: -- c-addr u
:NONAME
  BLK @ IF BLK @ BLOCK BLOCK-SIZE EXIT THEN
  DEFER@-EXECUTE SOURCE
; IS SOURCE

\ 6.2.2125 REFILL
\ D: -- flag
:NONAME
  BLK @ ?DUP IF 1+ BLK ! 0 >IN ! TRUE EXIT THEN
  DEFER@-EXECUTE REFILL
; IS REFILL

:NONAME
  0 BLK ! DEFER@-EXECUTE (RESET-INPUT)
; IS (RESET-INPUT)

: RESTORE-INPUT-BLOCK
  >R BLK ! R> 2 - SWAP EXECUTE
;

: SAVE-INPUT-BLOCK
  DEFER@-EXECUTE (SAVE-INPUT) >R BLK @ ['] RESTORE-INPUT-BLOCK R> 2 +
;

' SAVE-INPUT-BLOCK IS (SAVE-INPUT)

REPORT-NEW-NAME !
