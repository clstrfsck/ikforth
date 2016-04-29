\
\  winconsole.4th
\
\  Copyright (C) 1999-2016 Illya Kysil
\

REQUIRES" sysdict/console.4th"
REQUIRES" sysdict/x86-windows/kernel32.4th"

CR .( Loading WINCONSOLE definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

0 VALUE STDIN
0 VALUE STDOUT
0 VALUE STDERR

:NONAME STD_INPUT_HANDLE  GetStdHandle TO STDIN
        STD_OUTPUT_HANDLE GetStdHandle TO STDOUT
        STD_ERROR_HANDLE  GetStdHandle TO STDERR ;
DUP STARTUP-CHAIN CHAIN.ADD EXECUTE

: WIN-AT-XY (S x y -- )
  16 LSHIFT OR STDOUT SetConsoleCursorPosition DROP
;

\ 10.6.2.1307 EKEY? ( -- flag )
\ If a keyboard event is available, return true. Otherwise return false.
\ The event shall be returned by the next execution of EKEY.
\
\ After EKEY? returns with a value of true, subsequent executions of EKEY?
\ prior to the execution of KEY, KEY? or EKEY also return true, referring to the same event.
: WIN-CONSOLE-EKEY? ( -- flag )
  0 SP@ STDIN GetNumberOfConsoleInputEvents DROP
  0<>
;

USER INPUT_RECORD 20 ( /INPUT_RECORD) USER-ALLOC

\ Return control keys state from last keyboard event
: CONTROL-STATE (S -- u )
  INPUT_RECORD ( Event dwControlKeyState ) 16 + @
;

\ Return implementation specific key scan code and pressed/released state.
\ Flag is true if key is pressed.
: EKEY>SCAN (S u -- scan flag )
  DUP 0x10 RSHIFT 0x000000FF AND
  SWAP 0xFF000000 AND 0<>
;

\ 10.6.2.1305 EKEY ( -- u )
\ Receive one keyboard event u.
\ The encoding of keyboard events is implementation defined.
\ In this implementation
\ byte  value
\    0  AsciiChar
\    2  ScanCod
\    3  KeyDownFlag
: WIN-CONSOLE-EKEY ( -- u ) \ 93 FACILITY EXT
  0 SP@ 1 INPUT_RECORD STDIN ReadConsoleInput DROP DROP
  INPUT_RECORD
  DUP  ( EventType ) W@ KEY_EVENT <> IF DROP 0 EXIT THEN
  DUP  ( Event AsciiChar       ) 14 + W@
  OVER ( Event wVirtualScanCode) 12 + W@  16 LSHIFT OR
  OVER ( Event bKeyDown        ) 04 + C@  24 LSHIFT OR
  NIP
;

\ 10.6.2.1306 EKEY>CHAR ( u -- u false | char true )
\ If the keyboard event u corresponds to a character in the implementation-defined
\ character set, return that character and true. Otherwise return u and false.
: WIN-CONSOLE-EKEY>CHAR ( u -- u false | char true )
  DUP 0xFF000000 AND 0=  IF FALSE    EXIT THEN
  DUP 0x000000FF AND DUP IF NIP TRUE EXIT THEN DROP
  FALSE
;

\ 10.6.2.1306.40 EKEY>FKEY ( x -- u flag )
\ If the keyboard event x corresponds to a keypress in the implementation-defined
\ special key set, return that key's id u and true. Otherwise return x and false.
: WIN-CONSOLE-EKEY>FKEY ( u -- u false | char true )
  DUP 0x00FF0000 AND 0<>
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
: WIN-CONSOLE-KEY? ( -- flag )
  PENDING-CHAR @ 0 > IF TRUE EXIT THEN
  BEGIN
    EKEY?
  WHILE
    EKEY EKEY>CHAR
    IF PENDING-CHAR ! TRUE EXIT THEN
    DROP
  REPEAT FALSE
;

\ 6.1.1750 KEY ( -- char )
\ Receive one character char, a member of the implementation-defined character set.
\ Keyboard events that do not correspond to such characters are discarded until a valid
\ character is received, and those events are subsequently unavailable.
\ All standard characters can be received. Characters received by KEY are not displayed.
\ Any standard character returned by KEY has the numeric value specified in
\ 3.1.2.1 Graphic characters. Programs that require the ability to receive control
\ characters have an environmental dependency.
: WIN-CONSOLE-KEY ( -- char )
  PENDING-CHAR @ 0 >
  IF PENDING-CHAR @ -1 PENDING-CHAR ! EXIT THEN
  BEGIN
    EKEY EKEY>CHAR 0=
  WHILE
    DROP
  REPEAT
;

CREATE CSBI CONSOLE_SCREEN_BUFFER_INFO STRUCT-SIZEOF ALLOT

: WIN-ERASE-CHAR
  CSBI STDOUT GetConsoleScreenBufferInfo 0<>
  IF
    CSBI CONSOLE_SCREEN_BUFFER_INFO.dwCursorPosition DUP
    COORD.X W@ 0=
    IF
      CSBI CONSOLE_SCREEN_BUFFER_INFO.srWindow SMALL_RECT.Right W@
      SWAP COORD.Y W@ 1-
    ELSE
      DUP  COORD.X W@ 1-
      SWAP COORD.Y W@
    THEN
    2DUP AT-XY SPACE AT-XY
  THEN
;

\ 6.1.0695 ACCEPT
\ (S c-addr +n1 -- +n2 )
\ Receive a string of at most +n1 characters.
\ An ambiguous condition exists if +n1 is zero or greater than 32,767.
\ Display graphic characters as they are received.
\ A program that depends on the presence or absence of non-graphic characters in the string
\ has an environmental dependency.
\ The editing functions, if any, that the system performs in order to construct the string are implementation-defined.
\
\ Input terminates when an implementation-defined line terminator is received.
\ When input terminates, nothing is appended to the string, and the display is maintained in an implementation-defined way.
\
\ +n2 is the length of the string stored at c-addr.
: WIN-ACCEPT (S c-addr +n1 -- +n2 )
  DUP 0=
  OVER 0< OR
  OVER 32767 > OR
  IF EXC-INVALID-NUM-ARGUMENT THROW THEN
  >R 0
  BEGIN
    KEY DUP                \ c-addr n key key
    CASE
      32 127 <OF<          \ graphics characters
        OVER R@ <
        IF
          DUP EMIT
          ROT C!+ SWAP 1+
        THEN
        FALSE
      ENDOF
      4 OF                 \ Ctrl+D
        EXC-USER-INTERRUPT THROW
      ENDOF
      8 OF                 \ Ctrl+H or Backspace
        DROP DUP
        0>
        IF
          CONSOLE-BACKSPACE
          1- SWAP [ 1 CHARS ] LITERAL - SWAP
        THEN
        FALSE
      ENDOF
      13 OF                \ Ctrl+M or Enter
        DROP
        TRUE
      ENDOF
      27 OF
        DROP
        BEGIN
          \ drop all characters till the end of ESCape sequence
          KEY >R
          \DEBUG R@ H.2 SPACE
          R@ 'z' <=
          R@ 'a' >= AND
          R@ 'Z' <=
          R@ 'A' >= AND
          OR R> DROP
        UNTIL
        FALSE
      ENDOF
      FALSE SWAP
    ENDCASE
  UNTIL
  SWAP R> 2DROP
;

\ 10.6.1.2005 PAGE
\ (S -- )
\ Move to another page for output. Actual function depends on the output device.
\ On a terminal, PAGE clears the screen and resets the cursor position to the upper left corner.
\ On a printer, PAGE performs a form feed.
: WIN-PAGE (S -- )
  CSBI STDOUT GetConsoleScreenBufferInfo DROP
  0 SP@ 0
  CSBI CONSOLE_SCREEN_BUFFER_INFO.dwSize DUP COORD.X W@ SWAP COORD.Y W@ *
  BL STDOUT FillConsoleOutputCharacter DROP DROP
  0 0 AT-XY
;

\ 10.6.2.1325 EMIT?
\ (S -- flag )
\ flag is true if the user output device is ready to accept data and the execution
\ of EMIT in place of EMIT? would not have suffered an indefinite delay.
\ If the device status is indeterminate, flag is true.
: WIN-EMIT? (S -- flag )
  TRUE
;

: WINCONSOLE-INIT
  ['] WIN-ERASE-CHAR        IS CONSOLE-BACKSPACE
  ['] WIN-AT-XY             IS AT-XY
  ['] WIN-CONSOLE-EKEY?     IS EKEY?
  ['] WIN-CONSOLE-EKEY      IS EKEY
  ['] WIN-CONSOLE-EKEY>CHAR IS EKEY>CHAR
  ['] WIN-CONSOLE-EKEY>FKEY IS EKEY>FKEY
  ['] WIN-CONSOLE-KEY?      IS KEY?
  ['] WIN-CONSOLE-KEY       IS KEY
  ['] WIN-ACCEPT            IS ACCEPT
  ['] WIN-PAGE              IS PAGE
  ['] WIN-EMIT?             IS EMIT?
;

ONLY TERMINIT DEFINITIONS

SYNONYM WINCONSOLE-INIT WINCONSOLE-INIT

ONLY FORTH DEFINITIONS

REPORT-NEW-NAME !