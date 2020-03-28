\
\  exception-ext.4th
\
\  Unlicense since 1999 by Illya Kysil
\

CR .( Loading EXCEPTION-EXT definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

: (TRY) (S handler-addr -- )
   R> SWAP >R (EXC-PUSH) >R
;

: ()CATCH)
   R> (EXC-POP-CATCH) R> DROP >R 0
;

VARIABLE CATCH(-PAIRS

: CATCH(
   POSTPONE LIT >MARK
   POSTPONE (TRY)
   CATCH(-PAIRS
; IMMEDIATE/COMPILE-ONLY

: )CATCH (S -- exc-id )
   CATCH(-PAIRS ?PAIRS
   POSTPONE ()CATCH)
   >RESOLVE
; IMMEDIATE/COMPILE-ONLY

REPORT-NEW-NAME !
