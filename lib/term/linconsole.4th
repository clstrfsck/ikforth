\
\  linconsole.4th
\
\  Copyright (C) 2016 Illya Kysil
\

REQUIRES" src/kernel/console.4th"
REQUIRES" lib/linux/libc.4th"
REQUIRES" lib/linux/libreadline.4th"
REQUIRES" lib/term/linterm-ekey.4th"

CR .( Loading linconsole definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

: tcsetattr-execute (S i*x xt xt-attr-mutator -- j*x )
   (G Execute xt with termios attributes modified by xt-attr-mutator )
   (G xt-attr-mutator stack effect: termios-addr -- )
   SIZEOF_STRUCT_TERMIOS 2 * ALLOCATE THROW >R
   R@ STDIN _tcgetattr DROP
   R@ DUP SIZEOF_STRUCT_TERMIOS + DUP >R SIZEOF_STRUCT_TERMIOS MOVE
   R@ SWAP EXECUTE
   R> TCSANOW STDIN _tcsetattr DROP
   CATCH
   R@ TCSANOW STDIN _tcsetattr DROP
   R> FREE THROW THROW
;

: and! (S x addr -- )
   (G *addr &= x )
   SWAP OVER @ AND SWAP !
;

: key?-tcattr (S termios-addr -- )
   (G Modify termios flags as suitable for KEY? )
   ICANON INVERT OVER OFFSETOF_C_LFLAG + and!
   ECHO   INVERT OVER OFFSETOF_C_LFLAG + and!
   OFFSETOF_C_CC +
   VMIN  CHARS OVER + 0 SWAP C!
   VTIME CHARS OVER + 0 SWAP C!
   DROP
;

: key-tcattr (S termios-addr -- )
   (G Modify termios flags as suitable for KEY )
   ICANON INVERT OVER OFFSETOF_C_LFLAG + AND!
   ECHO   INVERT OVER OFFSETOF_C_LFLAG + AND!
   OFFSETOF_C_CC +
   VMIN  CHARS OVER + 1 SWAP C!
   VTIME CHARS OVER + 0 SWAP C!
   DROP
;

VARIABLE PENDING-CHAR

\ 10.6.1.1755 KEY? ( -- flag )
\ If a character is available, return true. Otherwise, return false.
\ If non-character keyboard events are available before the first valid character,
\ they are discarded and are subsequently unavailable.
\ The character shall be returned by the next execution of KEY.
\
\ After KEY? returns with a value of true, subsequent executions of KEY?
\ prior to the execution of KEY or EKEY also return true, without discarding keyboard events.
: LIN-CONSOLE-KEY?
   PENDING-CHAR @ 0<> ?DUP IF   EXIT   THEN
   [:
      0 SP@ 1 CHARS STDIN READ-FILE THROW 0<> SWAP PENDING-CHAR !
   ;]
   ['] key?-tcattr
   tcsetattr-execute
;

\ 6.1.1750 KEY ( -- char )
\ Receive one character char, a member of the implementation-defined character set.
\ Keyboard events that do not correspond to such characters are discarded until a valid
\ character is received, and those events are subsequently unavailable.
\ All standard characters can be received. Characters received by KEY are not displayed.
\ Any standard character returned by KEY has the numeric value specified in
\ 3.1.2.1 Graphic characters. Programs that require the ability to receive control
\ characters have an environmental dependency.
: LIN-CONSOLE-KEY
   PENDING-CHAR @ ?DUP IF   0 PENDING-CHAR ! EXIT   THEN
   [:
      BEGIN
         0 SP@ 1 CHARS STDIN READ-FILE THROW
         1 <
      WHILE
      REPEAT
   ;]
   ['] key-tcattr
   tcsetattr-execute
;

: LIN-ACCEPT-READLINE
   (S c-addr +n1 -- +n2 )
   \ Receive a string of at most +n1 characters.
   DUP 0=
   OVER 0< OR
   OVER 32767 > OR
   IF   EXC-INVALID-NUM-ARGUMENT THROW   THEN
   0 libc-readline
   ?DUP IF
      DUP >R
      \ c-addr +n1 z-addr
      ZCOUNT
      \ c-addr +n1 z-addr z-count
      2SWAP ROT MIN
      DUP >R CMOVE R> R>
      \ +n2 z-addr
      libc-free
   ELSE
      2DROP 0
   THEN
;

\ 10.6.2.1325 EMIT?
\ (S -- flag )
\ flag is true if the user output device is ready to accept data and the execution
\ of EMIT in place of EMIT? would not have suffered an indefinite delay.
\ If the device status is indeterminate, flag is true.
: LIN-EMIT? (S -- flag )
   TRUE
;

: LINCONSOLE-INIT
\   ['] LIN-ERASE-CHAR        IS CONSOLE-BACKSPACE
\   ['] LIN-AT-XY             IS AT-XY
   ['] LIN-CONSOLE-KEY?      IS EKEY?
   ['] term-ekey             IS EKEY
   ['] term-ekey>char        IS EKEY>CHAR
   ['] term-ekey>fkey        IS EKEY>FKEY
   ['] LIN-CONSOLE-KEY?      IS KEY?
   ['] LIN-CONSOLE-KEY       IS KEY
   ['] LIN-ACCEPT-READLINE   IS ACCEPT
\   ['] LIN-PAGE              IS PAGE
   ['] LIN-EMIT?             IS EMIT?
;

ONLY TERMINIT DEFINITIONS

SYNONYM LINCONSOLE-INIT LINCONSOLE-INIT

ONLY FORTH DEFINITIONS

REPORT-NEW-NAME !