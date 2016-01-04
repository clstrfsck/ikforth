CREATE-REPORT OFF
: PRESENT? BL WORD FIND IF DROP EXIT THEN COUNT TYPE SPACE 1+ ;

: PRINT-COUNT
  ?DUP IF 9 EMIT
          DUP . ." word" 1 <> IF ." s" THEN
          ."  not found in " TYPE ."  wordset" CR
       ELSE
          2DROP
       THEN ;

: WS-NOT-FOUND DUP -ROT TYPE 18 SWAP - SPACES ." not defined" CR ;

: CHECK-KEY ; \ CR ." Press any key to continue" KEY DROP ;

CR
.( ANSI Forth 1994 words NOT found in current search order ) CR
S" CORE" 2DUP ENVIRONMENT? DUP [IF] DROP [THEN] [IF] 0
PRESENT? !
PRESENT? #
PRESENT? #>
PRESENT? #S
PRESENT? '
PRESENT? (
PRESENT? *
PRESENT? */
PRESENT? */MOD
PRESENT? +
PRESENT? +!
PRESENT? +LOOP
PRESENT? ,
PRESENT? -
PRESENT? .
PRESENT? ."
PRESENT? /
PRESENT? /MOD
PRESENT? 0<
PRESENT? 0=
PRESENT? 1+
PRESENT? 1-
PRESENT? 2!
PRESENT? 2*
PRESENT? 2/
PRESENT? 2@
PRESENT? 2DROP
PRESENT? 2DUP
PRESENT? 2OVER
PRESENT? 2SWAP
PRESENT? :
PRESENT? ;
PRESENT? <
PRESENT? <#
PRESENT? =
PRESENT? >
PRESENT? >BODY
PRESENT? >IN
PRESENT? >NUMBER
PRESENT? >R
PRESENT? ?DUP
PRESENT? @
PRESENT? ABORT
PRESENT? ABORT"
PRESENT? ABS
PRESENT? ACCEPT
PRESENT? ALIGN
PRESENT? ALIGNED
PRESENT? ALLOT
PRESENT? AND
PRESENT? BASE
PRESENT? BEGIN
PRESENT? BL
PRESENT? C!
PRESENT? C,
PRESENT? C@
PRESENT? CELL+
PRESENT? CELLS
PRESENT? CHAR
PRESENT? CHAR+
PRESENT? CHARS
PRESENT? CONSTANT
PRESENT? COUNT
PRESENT? CR
PRESENT? CREATE
PRESENT? DECIMAL
PRESENT? DEPTH
PRESENT? DO
PRESENT? DOES>
PRESENT? DROP
PRESENT? DUP
PRESENT? ELSE
PRESENT? EMIT
PRESENT? ENVIRONMENT?
PRESENT? EVALUATE
PRESENT? EXECUTE
PRESENT? EXIT
PRESENT? FILL
PRESENT? FIND
PRESENT? FM/MOD
PRESENT? HERE
PRESENT? HOLD
PRESENT? I
PRESENT? IF
PRESENT? IMMEDIATE
PRESENT? INVERT
PRESENT? J
PRESENT? KEY
PRESENT? LEAVE
PRESENT? LITERAL
PRESENT? LOOP
PRESENT? LSHIFT
PRESENT? M*
PRESENT? MAX
PRESENT? MIN
PRESENT? MOD
PRESENT? MOVE
PRESENT? NEGATE
PRESENT? OR
PRESENT? OVER
PRESENT? POSTPONE
PRESENT? QUIT
PRESENT? R>
PRESENT? R@
PRESENT? RECURSE
PRESENT? REPEAT
PRESENT? ROT
PRESENT? RSHIFT
PRESENT? S"
PRESENT? S>D
PRESENT? SIGN
PRESENT? SM/REM
PRESENT? SOURCE
PRESENT? SPACE
PRESENT? SPACES
PRESENT? STATE
PRESENT? SWAP
PRESENT? THEN
PRESENT? TYPE
PRESENT? U.
PRESENT? U<
PRESENT? UM*
PRESENT? UM/MOD
PRESENT? UNLOOP
PRESENT? UNTIL
PRESENT? VARIABLE
PRESENT? WHILE
PRESENT? WORD
PRESENT? XOR
PRESENT? [
PRESENT? [']
PRESENT? [CHAR]
PRESENT? ]
PRINT-COUNT
[ELSE] WS-NOT-FOUND [THEN] CHECK-KEY

S" CORE-EXT" 2DUP ENVIRONMENT? DUP [IF] DROP [THEN] [IF] 0
PRESENT? #TIB
PRESENT? .(
PRESENT? .R
PRESENT? 0<>
PRESENT? 0>
PRESENT? 2>R
PRESENT? 2R>
PRESENT? 2R@
PRESENT? :NONAME
PRESENT? <>
PRESENT? ?DO
PRESENT? AGAIN
PRESENT? C"
PRESENT? CASE
PRESENT? COMPILE,
PRESENT? CONVERT
PRESENT? ENDCASE
PRESENT? ENDOF
PRESENT? ERASE
PRESENT? EXPECT
PRESENT? FALSE
PRESENT? HEX
PRESENT? MARKER
PRESENT? NIP
PRESENT? OF
PRESENT? PAD
PRESENT? PARSE
PRESENT? PICK
PRESENT? QUERY
PRESENT? REFILL
PRESENT? RESTORE-INPUT
PRESENT? ROLL
PRESENT? SAVE-INPUT
PRESENT? SOURCE-ID
PRESENT? SPAN
PRESENT? TIB
PRESENT? TO
PRESENT? TRUE
PRESENT? TUCK
PRESENT? U.R
PRESENT? U>
PRESENT? UNUSED
PRESENT? VALUE
PRESENT? WITHIN
PRESENT? [COMPILE]
PRESENT? \
PRINT-COUNT
[ELSE] WS-NOT-FOUND [THEN] CHECK-KEY

S" BLOCK" 2DUP ENVIRONMENT? DUP [IF] DROP [THEN] [IF] 0
PRESENT? BLK
PRESENT? BLOCK
PRESENT? BUFFER
PRESENT? FLUSH
PRESENT? LOAD
PRESENT? SAVE-BUFFERS
PRESENT? UPDATE
PRINT-COUNT
[ELSE] WS-NOT-FOUND [THEN] CHECK-KEY

S" BLOCK-EXT" 2DUP ENVIRONMENT? DUP [IF] DROP [THEN] [IF] 0
PRESENT? EMPTY-BUFFERS
PRESENT? LIST
PRESENT? SCR
PRESENT? THRU
PRINT-COUNT
[ELSE] WS-NOT-FOUND [THEN] CHECK-KEY

S" DOUBLE" 2DUP ENVIRONMENT? DUP [IF] DROP [THEN] [IF] 0
PRESENT? 2CONSTANT
PRESENT? 2LITERAL
PRESENT? 2VARIABLE
PRESENT? D+
PRESENT? D-
PRESENT? D.
PRESENT? D.R
PRESENT? D0<
PRESENT? D0=
PRESENT? D2*
PRESENT? D2/
PRESENT? D<
PRESENT? D=
PRESENT? D>S
PRESENT? DABS
PRESENT? DMAX
PRESENT? DMIN
PRESENT? DNEGATE
PRESENT? M*/
PRESENT? M+
PRINT-COUNT
[ELSE] WS-NOT-FOUND [THEN] CHECK-KEY

S" DOUBLE-EXT" 2DUP ENVIRONMENT? DUP [IF] DROP [THEN] [IF] 0
PRESENT? 2ROT
PRESENT? DU<
PRINT-COUNT
[ELSE] WS-NOT-FOUND [THEN] CHECK-KEY

S" EXCEPTION" 2DUP ENVIRONMENT? DUP [IF] DROP [THEN] [IF] 0
PRESENT? CATCH
PRESENT? THROW
PRINT-COUNT
[ELSE] WS-NOT-FOUND [THEN] CHECK-KEY

S" EXCEPTION-EXT" 2DUP ENVIRONMENT? DUP [IF] DROP [THEN] [IF] 0
PRINT-COUNT
[ELSE] WS-NOT-FOUND [THEN] CHECK-KEY

S" FACILITY" 2DUP ENVIRONMENT? DUP [IF] DROP [THEN] [IF] 0
PRESENT? AT-XY
PRESENT? KEY?
PRESENT? PAGE
PRINT-COUNT
[ELSE] WS-NOT-FOUND [THEN] CHECK-KEY

S" FACILITY-EXT" 2DUP ENVIRONMENT? DUP [IF] DROP [THEN] [IF] 0
PRESENT? EKEY
PRESENT? EKEY>CHAR
PRESENT? EKEY?
PRESENT? EMIT?
PRESENT? MS
PRESENT? TIME&DATE
PRINT-COUNT
[ELSE] WS-NOT-FOUND [THEN] CHECK-KEY

S" FILE" 2DUP ENVIRONMENT? DUP [IF] DROP [THEN] [IF] 0
PRESENT? BIN
PRESENT? CLOSE-FILE
PRESENT? CREATE-FILE
PRESENT? DELETE-FILE
PRESENT? FILE-POSITION
PRESENT? FILE-SIZE
PRESENT? INCLUDE-FILE
PRESENT? INCLUDED
PRESENT? OPEN-FILE
PRESENT? R/O
PRESENT? R/W
PRESENT? READ-FILE
PRESENT? READ-LINE
PRESENT? REPOSITION-FILE
PRESENT? RESIZE-FILE
PRESENT? W/O
PRESENT? WRITE-FILE
PRESENT? WRITE-LINE
PRINT-COUNT
[ELSE] WS-NOT-FOUND [THEN] CHECK-KEY

S" FILE-EXT" 2DUP ENVIRONMENT? DUP [IF] DROP [THEN] [IF] 0
PRESENT? FILE-STATUS
PRESENT? FLUSH-FILE
PRESENT? RENAME-FILE
PRINT-COUNT
[ELSE] WS-NOT-FOUND [THEN] CHECK-KEY

S" FLOATING" 2DUP ENVIRONMENT? DUP [IF] DROP [THEN] [IF] 0
PRESENT? >FLOAT
PRESENT? D>F
PRESENT? F!
PRESENT? F*
PRESENT? F+
PRESENT? F-
PRESENT? F/
PRESENT? F0<
PRESENT? F0=
PRESENT? F<
PRESENT? F>D
PRESENT? F@
PRESENT? FALIGN
PRESENT? FALIGNED
PRESENT? FCONSTANT
PRESENT? FDEPTH
PRESENT? FDROP
PRESENT? FDUP
PRESENT? FLITERAL
PRESENT? FLOAT+
PRESENT? FLOATS
PRESENT? FLOOR
PRESENT? FMAX
PRESENT? FMIN
PRESENT? FNEGATE
PRESENT? FOVER
PRESENT? FROT
PRESENT? FROUND
PRESENT? FSWAP
PRESENT? FVARIABLE
PRESENT? REPRESENT
PRINT-COUNT
[ELSE] WS-NOT-FOUND [THEN] CHECK-KEY

S" FLOATING-EXT" 2DUP ENVIRONMENT? DUP [IF] DROP [THEN] [IF] 0
PRESENT? DF!
PRESENT? DF@
PRESENT? DFALIGN
PRESENT? DFALIGNED
PRESENT? DFLOAT+
PRESENT? DFLOATS
PRESENT? F**
PRESENT? F.
PRESENT? FABS
PRESENT? FACOS
PRESENT? FACOSH
PRESENT? FALOG
PRESENT? FASIN
PRESENT? FASINH
PRESENT? FATAN
PRESENT? FATAN2
PRESENT? FATANH
PRESENT? FCOS
PRESENT? FCOSH
PRESENT? FE.
PRESENT? FEXP
PRESENT? FEXPM1
PRESENT? FLN
PRESENT? FLNP1
PRESENT? FLOG
PRESENT? FS.
PRESENT? FSIN
PRESENT? FSINCOS
PRESENT? FSINH
PRESENT? FSQRT
PRESENT? FTAN
PRESENT? FTANH
PRESENT? F~
PRESENT? PRECISION
PRESENT? SET-PRECISION
PRESENT? SF!
PRESENT? SF@
PRESENT? SFALIGN
PRESENT? SFALIGNED
PRESENT? SFLOAT+
PRESENT? SFLOATS
PRINT-COUNT
[ELSE] WS-NOT-FOUND [THEN] CHECK-KEY

S" LOCALS" 2DUP ENVIRONMENT? DUP [IF] DROP [THEN] [IF] 0
PRESENT? (LOCAL)
PRINT-COUNT
[ELSE] WS-NOT-FOUND [THEN] CHECK-KEY

S" LOCALS-EXT" 2DUP ENVIRONMENT? DUP [IF] DROP [THEN] [IF] 0
PRESENT? LOCALS|
PRINT-COUNT
[ELSE] WS-NOT-FOUND [THEN] CHECK-KEY

S" MEMORY-ALLOC" 2DUP ENVIRONMENT? DUP [IF] DROP [THEN] [IF] 0
PRESENT? ALLOCATE
PRESENT? FREE
PRESENT? RESIZE
PRINT-COUNT
[ELSE] WS-NOT-FOUND [THEN] CHECK-KEY

S" MEMORY-ALLOC-EXT" 2DUP ENVIRONMENT? DUP [IF] DROP [THEN] [IF] 0
PRINT-COUNT
[ELSE] WS-NOT-FOUND [THEN] CHECK-KEY

S" TOOLS" 2DUP ENVIRONMENT? DUP [IF] DROP [THEN] [IF] 0
PRESENT? .S
PRESENT? ?
PRESENT? DUMP
PRESENT? SEE
PRESENT? WORDS
PRINT-COUNT
[ELSE] WS-NOT-FOUND [THEN] CHECK-KEY

S" TOOLS-EXT" 2DUP ENVIRONMENT? DUP [IF] DROP [THEN] [IF] 0
PRESENT? ;CODE
PRESENT? AHEAD
PRESENT? ASSEMBLER
PRESENT? BYE
PRESENT? CODE
PRESENT? CS-PICK
PRESENT? CS-ROLL
PRESENT? EDITOR
PRESENT? FORGET
PRINT-COUNT
[ELSE] WS-NOT-FOUND [THEN] CHECK-KEY
\ PRESENT? [ELSE]
\ PRESENT? [IF]
\ PRESENT? [THEN]

S" SEARCH-ORDER" 2DUP ENVIRONMENT? DUP [IF] DROP [THEN] [IF] 0
PRESENT? DEFINITIONS
PRESENT? FORTH-WORDLIST
PRESENT? GET-CURRENT
PRESENT? GET-ORDER
PRESENT? SEARCH-WORDLIST
PRESENT? SET-CURRENT
PRESENT? SET-ORDER
PRESENT? WORDLIST
PRINT-COUNT
[ELSE] WS-NOT-FOUND [THEN] CHECK-KEY

S" SEARCH-ORDER-EXT" 2DUP ENVIRONMENT? DUP [IF] DROP [THEN] [IF] 0
PRESENT? ALSO
PRESENT? FORTH
PRESENT? ONLY
PRESENT? ORDER
PRESENT? PREVIOUS
PRINT-COUNT
[ELSE] WS-NOT-FOUND [THEN] CHECK-KEY

S" STRING" 2DUP ENVIRONMENT? DUP [IF] DROP [THEN] [IF] 0
PRESENT? -TRAILING
PRESENT? /STRING
PRESENT? BLANK
PRESENT? CMOVE
PRESENT? CMOVE>
PRESENT? COMPARE
PRESENT? SEARCH
PRESENT? SLITERAL
PRINT-COUNT
[ELSE] WS-NOT-FOUND [THEN] CHECK-KEY

S" STRING-EXT" 2DUP ENVIRONMENT? DUP [IF] DROP [THEN] [IF] 0
PRINT-COUNT
[ELSE] WS-NOT-FOUND [THEN] CHECK-KEY
