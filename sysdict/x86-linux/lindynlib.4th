PURPOSE: lindynlib definitions
LICENSE: Unlicense since 1999 by Illya Kysil

REQUIRES" sysdict/dynlib.4th"

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

:NONAME
   0=  IF
      CR ." Failed to load: "
      DYNLIB-PATH@ TYPE CR
   ELSE
      DROP
   THEN
; IS DYNLIB-INIT-CHECK

REPORT-NEW-NAME !
