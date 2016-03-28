\
\  locals.4th
\
\  Copyright (C) 1999-2016 Illya Kysil
\

REQUIRES" lib/~ik/locals.4th"

CR .( Loading LOCALS definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME ON

<ENV
   16    CONSTANT #LOCALS
   TRUE  CONSTANT LOCALS
   TRUE  CONSTANT LOCALS-EXT
ENV>

10240 CONSTANT /LOCALS-DATA-AREA

VARIABLE LOCALS-DP0
VARIABLE LOCALS-DP

VARIABLE CURRENT-#LOCALS
WORDLIST CONSTANT LOCALS-WORDLIST

VARIABLE PATCH-#LOCALS

VARIABLE (L@)-INDEX

: RESET-LOCALS
   LOCALS-DP0 @ DUP
   /LOCALS-DATA-AREA ERASE
   LOCALS-DP !
   0 LOCALS-WORDLIST WL>LATEST !
   0 CURRENT-#LOCALS !
   0 PATCH-#LOCALS !
   -1 (L@)-INDEX !
;

:NONAME
   0 LOCALS-DP0 !
   /LOCALS-DATA-AREA ALLOCATE THROW LOCALS-DP0 !
   RESET-LOCALS
; DUP STARTUP-CHAIN CHAIN.ADD EXECUTE

:NONAME
   LOCALS-DP0 @ FREE THROW
; SHUTDOWN-CHAIN CHAIN.ADD

: LOCALS-FRAME,
   PATCH-#LOCALS @ 0= IF
      ['] LIT COMPILE,
      HERE PATCH-#LOCALS !
      0 ,
      POSTPONE LOCALS-FRAME
   THEN
;

: LOCALS-UNFRAME,
   PATCH-#LOCALS @ IF
      POSTPONE LOCALS-UNFRAME
   THEN
;

: (L@),
   (L@)-INDEX @
   POSTPONE LITERAL
   POSTPONE (L@)
;

: LOCAL, \ ( c-addr u -- )
   2>R (DO-CREATE) 2R> &IMMEDIATE HEADER, \ xt
   DROP
   CURRENT-#LOCALS @ ,
;

: LOCAL-INIT,
   CURRENT-#LOCALS @ POSTPONE LITERAL POSTPONE (L!)
;

: (LOCAL) \ ( c-addr u -- )
   2DUP OR 0= IF
      \ last message
      PATCH-#LOCALS @ ?DUP IF
         CURRENT-#LOCALS @ SWAP !
      THEN
   ELSE
      DP @ >R GET-CURRENT >R
      LOCALS-DP @ DP !
      LOCALS-WORDLIST SET-CURRENT
      ['] LOCAL, CATCH
      DP @ LOCALS-DP !
      R> SET-CURRENT R> DP !
      THROW
      LOCAL-INIT,
      1 CURRENT-#LOCALS +!
   THEN
; COMPILE-ONLY

: LOCALS| ( "name...name |" -- )
   LOCALS-FRAME,
   BEGIN
      PARSE-NAME OVER C@
      [CHAR] | - OVER 1 - OR
   WHILE
      (LOCAL)
   REPEAT 2DROP 0 0 (LOCAL)
; IMMEDIATE

HERE CONSTANT UNDEFINED-VALUE

: MATCH-OR-END? ( c-addr1 u1 c-addr2 u2 -- f )
   2 PICK 0= >R COMPARE 0= R> OR
;

: SCAN-ARGS
   \ 0 c-addr1 u1 -- c-addr1 u1 ... c-addrn un n c-addrn+1 un+1
   BEGIN
      2DUP S" |"  MATCH-OR-END? 0= WHILE
      2DUP S" --" MATCH-OR-END? 0= WHILE
      2DUP S" :}" MATCH-OR-END? 0= WHILE
      ROT 1+ PARSE-NAME
   AGAIN THEN THEN THEN
;

: SCAN-LOCALS
   \ n c-addr1 u1 -- c-addr1 u1 ... c-addrn un n c-addrn+1 un+1
   2DUP S" |" COMPARE 0= 0= IF
      EXIT
   THEN
   2DROP PARSE-NAME
   BEGIN
      2DUP S" --" MATCH-OR-END? 0= WHILE
      2DUP S" :}" MATCH-OR-END? 0= WHILE
      ROT 1+ PARSE-NAME
      POSTPONE UNDEFINED-VALUE
   AGAIN THEN THEN
;

: SCAN-END ( c-addr1 u1 -- c-addr2 u2 )
   BEGIN
      2DUP S" :}" MATCH-OR-END? 0= WHILE
      2DROP PARSE-NAME
   REPEAT
;

: DEFINE-LOCALS ( c-addr1 u1 ... c-addrn un n -- )
   LOCALS-FRAME,
   0 ?DO
      (LOCAL)
   LOOP
   0 0 (LOCAL)
;

: {: ( -- )
   0 PARSE-NAME
   SCAN-ARGS SCAN-LOCALS SCAN-END
   2DROP DEFINE-LOCALS
; IMMEDIATE/COMPILE-ONLY

:NONAME \ FIND-LOCALS (S c-addr -- c-addr 0 | xt 1 | xt -1 )
   DUP
   COUNT LOCALS-WORDLIST SEARCH-WORDLIST
   ?DUP IF
      ROT DROP
      SWAP >BODY @ (L@)-INDEX !
      ['] (L@), SWAP
      EXIT
   THEN
   \ not found S: c-addr
   DEFERRED FIND
; IS FIND

: ; LOCALS-UNFRAME, POSTPONE ; ; IMMEDIATE

: [: POSTPONE [: RESET-LOCALS ; IMMEDIATE

: ;] LOCALS-UNFRAME, POSTPONE ;] ; IMMEDIATE

: EXIT LOCALS-UNFRAME, POSTPONE EXIT ;

: DOES> LOCALS-UNFRAME, POSTPONE DOES> RESET-LOCALS ; IMMEDIATE

: ;CODE LOCALS-UNFRAME, POSTPONE ;CODE RESET-LOCALS ; IMMEDIATE

: :NONAME :NONAME RESET-LOCALS ;

: : : RESET-LOCALS ;

REPORT-NEW-NAME !
