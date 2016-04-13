\
\  main.4th
\
\  Copyright (C) 1999-2016 Illya Kysil
\

REQUIRES" src/kernel/quit.4th"

CR .( Loading MAIN definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

: .COMPILED
  CR ." Compiled: "
  [
    TIME&DATE DECIMAL
    <# 5 ROLL S>D # # 2DROP CHAR : HOLD
       4 ROLL S>D # # 2DROP CHAR : HOLD
       3 ROLL S>D #S  2DROP
       BL HOLD CHAR , HOLD
       S>D #S 2DROP CHAR / HOLD MONTH>STR HOLDS CHAR / HOLD S>D #S #>
  ] SLITERAL TYPE
;

: .VERSION
  CR ." IKForth v1.0"
  CR ." Copyright (C) 1999-2016 Illya Kysil"
;

: .PLATFORM
  CR ." Platform: " PLATFORM? TYPE
;

:NONAME
  .VERSION .COMPILED CR .PLATFORM CR .ENV-INFO
; STARTUP-CHAIN CHAIN.ADD

:NONAME
  CR ." Bye..." CR
; SHUTDOWN-CHAIN CHAIN.ADD

0 VALUE GLOBAL-INIT-FLAG

: STARTUP-INCLUDED
  CR ." Loading startup include" CR
  CATCH( SF @ #SF @ 2DUP TYPE CR INCLUDED )CATCH
  CASE
    0 OF
\ no errors
    ENDOF
\    2 OF
\ ignore file not found exception
\    ENDOF
    DUP
    CR .EXCEPTION
    CR REPORT-SOURCE
  ENDCASE
;

: PROCESS-ARGS
  ARGC 1 =
  IF
    STARTUP-INCLUDED
  ELSE
    BEGIN
      SHIFT-ARG
      NEXT-ARG
    WHILE
      CR ." Evaluating argument: " CR 2DUP TYPE CR
      CATCH( EVALUATE )CATCH
      CASE
        0 OF
\ no errors
        ENDOF
\        2 OF
\ ignore file not found exception
\        ENDOF
        DUP .EXCEPTION
      ENDCASE
    REPEAT
  THEN
;

:NONAME
  INIT-USER
  DECIMAL
  GLOBAL-INIT-FLAG 0=
  IF
    1 TO GLOBAL-INIT-FLAG
    STARTUP-CHAIN CHAIN.EXECUTE>
    PROCESS-ARGS
  THEN
  DECIMAL
  QUIT
; IS MAIN

REPORT-NEW-NAME !