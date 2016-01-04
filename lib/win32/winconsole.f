\
\  winconsole.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\

CR .( Loading WINCONSOLE definitions )

CREATE-REPORT @
CREATE-REPORT OFF

BASE @

DECIMAL

0 VALUE STDIN
0 VALUE STDOUT
0 VALUE STDERR

:NONAME STD_INPUT_HANDLE  GetStdHandle TO STDIN
        STD_OUTPUT_HANDLE GetStdHandle TO STDOUT
        STD_ERROR_HANDLE  GetStdHandle TO STDERR ;
DUP STARTUP-CHAIN CHAIN.ADD EXECUTE

USER NumberOfConsoleInputEvents 1 CELLS USER-ALLOC

: WIN-CONSOLE-EKEY? ( -- flag ) \ 93 FACILITY EXT
\ If a keyboard event is available, return true. Otherwise return false.
\ The event shall be returned by the next execution of EKEY.
\ After EKEY? returns with a value of true, subsequent executions of EKEY?
\ prior to the execution of KEY, KEY? or EKEY also return true,
\ referring to the same event.
  NumberOfConsoleInputEvents STDIN GetNumberOfConsoleInputEvents DROP
  NumberOfConsoleInputEvents @ 0<>
;

USER INPUT_RECORD 20 ( /INPUT_RECORD) USER-ALLOC

: ControlKeysMask ( -- u )
\ ������� ����� ����������� ������ ��� ���������� ������������� �������.
  INPUT_RECORD ( Event dwControlKeyState ) 16 + @
;

USER NumberOfRecordsRead 1 CELLS USER-ALLOC

DECIMAL

: WIN-CONSOLE-EKEY ( -- u ) \ 93 FACILITY EXT
\ ������� ���� ������������ ������� u. ����������� ������������ �������
\ ������� �� ����������.
\ � ������ ����������
\ byte  value
\    0  AsciiChar
\    2  ScanCod
\    3  KeyDownFlag
  NumberOfRecordsRead 1 INPUT_RECORD STDIN ReadConsoleInput DROP INPUT_RECORD
  DUP  ( EventType ) W@ KEY_EVENT <> IF DROP 0 EXIT THEN
  DUP  ( Event AsciiChar       ) 14 + W@
  OVER ( Event wVirtualScanCode) 12 + W@  16 LSHIFT OR
  OVER ( Event bKeyDown        ) 04 + C@  24 LSHIFT OR
  NIP
;

HEX

: WIN-CONSOLE-EKEY>CHAR ( u -- u false | char true ) \ 93 FACILITY EXT
\ ���� ������������ ������� u ������������� ������� - ������� ������ �
\ "������". ����� u � "����".
  DUP    FF000000 AND  0=   IF FALSE    EXIT THEN
  DUP    000000FF AND  DUP  IF NIP TRUE EXIT THEN DROP
  FALSE
;

: EKEY>SCAN ( u -- scan flag )
\ ������� ����-��� �������, ��������������� ������������� ������� u
\ flag=true - ������� ������. flag=false - ��������.
  DUP  10 RSHIFT  000000FF AND
  SWAP FF000000 AND 0<>
;

DECIMAL

VARIABLE PENDING-CHAR \ ���������� ���� -> ���������� ����������, �� USER

: WIN-CONSOLE-KEY? ( -- flag ) \ 94 FACILITY
\ ���� ������ ��������, ������� "������". ����� "����". ���� ������������
\ ������������ ������� ��������, ��� ������������� � ������ ����������.
\ ������ ����� ��������� ��������� ����������� KEY.
\ ����� ���� ��� KEY? ���������� �������� "������", ��������� ����������
\ KEY? �� ���������� KEY ��� EKEY ����� ���������� "������" ��� ������������
\ ������������ �������.
  PENDING-CHAR @ 0 > IF TRUE EXIT THEN
  BEGIN
    EKEY?
  WHILE
    EKEY  EKEY>CHAR
    IF PENDING-CHAR ! TRUE EXIT THEN
    DROP
  REPEAT FALSE
;

: WIN-CONSOLE-KEY ( -- char ) \ 94
\ ������� ���� ������ char. ������������ �������, �� ���������������
\ ��������, ������������� � ����� �� ��������.
\ ����� ���� ������� ��� ����������� �������. �������, ����������� �� KEY,
\ �� ������������ �� �������.
\ ���������, ��������� ����������� ��������� ����������� ��������,
\ ������� �� ���������.
  PENDING-CHAR @ 0 >
  IF PENDING-CHAR @ -1 PENDING-CHAR ! EXIT THEN
  BEGIN
    EKEY EKEY>CHAR 0=
  WHILE
    DROP
  REPEAT
;

' WIN-CONSOLE-EKEY?     IS EKEY?
' WIN-CONSOLE-EKEY      IS EKEY
' WIN-CONSOLE-EKEY>CHAR IS EKEY>CHAR
' WIN-CONSOLE-KEY?      IS KEY?
' WIN-CONSOLE-KEY       IS KEY

BASE !

CREATE-REPORT !
