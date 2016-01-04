\
\  search-order.f
\
\  Copyright (C) 1999-2001 Illya Kysil
\
\  SEARCH-ORDER and SEARCH-ORDER-EXT wordsets
\

CR .( Loading SEARCH-ORDER definitions )

CREATE-REPORT @
CREATE-REPORT OFF

USER #ORDER 1 CELLS USER-ALLOC
:NONAME 0 #ORDER ! ;
DUP STARTUP-CHAIN CHAIN.ADD EXECUTE

USER CONTEXT MAX-ORDER-COUNT 1+ CELLS USER-ALLOC

: FIND-ORDER (S c-addr -- c-addr 0 | xt 1 | xt -1 )
  0 #ORDER @ 0 ?DO                              \ S: c-addr 0
                 OVER COUNT                     \ S: c-addr 0 c-addr1 count
                 I CELLS CONTEXT + @            \ S: c-addr 0 c-addr1 count wid
                 SEARCH-WORDLIST                \ S: c-addr 0 [ 0 | xt 1 | xt -1 ]
                 ?DUP IF                        \ found S: c-addr 0 xt [ 1 | -1 ]
                        2SWAP 2DROP             \ S: xt [ 1 | -1 ]
                        LEAVE                   
                      THEN
               LOOP
               ?DUP IF
                      EXIT                      \ found, EXIT
                    THEN
                                                \ not found S: c-addr
                                                \ try to search FORTH-WORDLIST
               [ DEFER@ FIND ] LITERAL EXECUTE ;

' FIND-ORDER IS FIND

: GET-ORDER #ORDER @ 0 ?DO #ORDER @ I - 1- CELLS CONTEXT + @ LOOP #ORDER @ ;

: (GET-ORDER) FORTH-WORDLIST GET-ORDER 1+ ;

: SET-ORDER DUP MAX-ORDER-COUNT > IF EXC-SEARCH-ORDER-OVERFLOW  THROW THEN
            DUP 0<                IF EXC-SEARCH-ORDER-UNDERFLOW THROW THEN
            DUP #ORDER ! 0 ?DO I CELLS CONTEXT + ! LOOP ;

: GET-CURRENT CURRENT @ ;

: SET-CURRENT CURRENT ! ;

VARIABLE LAST-WORDLIST
FORTH-WORDLIST LAST-WORDLIST !

\  WORDLIST structure
\  Offset (CELLS)       Value
\  +0                   last word in wordlist (modified by header creation words)
\  +1                   VOCABULARY XT (if any, 0 otherwise)
\  +2                   previous WORDLIST
: WORDLIST HERE DUP 0 DUP , , LAST-WORDLIST DUP >R @ , R> ! ;

: WL>LATEST (S wordlist-id -- latest-word-addr )
  ;

: WL>VOC (S wordlist-id -- voc-xt-addr )
  CELL+ ;

: WL>PREV-WL (S wordlist-id -- prev-wordlist-id-addr )
  [ 2 CELLS ] LITERAL + ;

: ONLY 0 SET-ORDER ;

: ALSO        GET-ORDER ?DUP IF
                               OVER SWAP 1+
                             ELSE
                               FORTH-WORDLIST 1
                             THEN SET-ORDER ;

: PREVIOUS    GET-ORDER ?DUP IF
                               NIP 1- SET-ORDER
                             THEN ;

: DEFINITIONS GET-ORDER ?DUP IF
                               OVER SET-CURRENT DROPS
                             ELSE
                               FORTH-WORDLIST SET-CURRENT
                             THEN ;

: DOES>-VOCABULARY DOES> @ >R GET-ORDER
                         DUP 0= IF 1 THEN
                         NIP R> SWAP SET-ORDER ;

: (VOCABULARY) HERE SWAP CREATE DUP , WL>VOC ! DOES>-VOCABULARY ;

: VOCABULARY WORDLIST (VOCABULARY) ;

: .WORDLIST-NAME
  DUP H.8 SPACE WL>VOC @ ?DUP
  IF
    LATEST>NAME COUNT TYPE
  ELSE
    ." (nonamed)"
  THEN ;

: ORDER
  (GET-ORDER)
  DUP . ." wordlist" DUP 1 <> IF ." s" THEN ."  in search order" CR 
  0 ?DO
      .WORDLIST-NAME CR
    LOOP ;

: WORDLISTS
    LAST-WORDLIST @
    BEGIN
      DUP
    WHILE
      DUP WL>PREV-WL @ >R
          .WORDLIST-NAME CR
      R>
    REPEAT DROP ;

FORTH-WORDLIST (VOCABULARY) FORTH

CREATE-REPORT !
