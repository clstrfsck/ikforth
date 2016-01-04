\
\  kernel32.f
\
\  Copyright (C) 1999-2001 Illya Kysil
\

CR .( Loading KERNEL32 definitions )

CREATE-REPORT @
CREATE-REPORT OFF

DLLImport KERNEL32.DLL "kernel32.dll"

Int32DLLEntry GlobalAlloc        KERNEL32.DLL GlobalAlloc
Int32DLLEntry GlobalFree         KERNEL32.DLL GlobalFree
Int32DLLEntry GlobalReAlloc      KERNEL32.DLL GlobalReAlloc

VoidDLLEntry  GetSystemTime      KERNEL32.DLL GetSystemTime
VoidDLLEntry  GetLocalTime       KERNEL32.DLL GetLocalTime

VoidDLLEntry  FlushFileBuffers   KERNEL32.DLL FlushFileBuffers

VoidDLLEntry  FillMemory         KERNEL32.DLL RtlFillMemory
VoidDLLEntry  ZeroMemory         KERNEL32.DLL RtlZeroMemory

Int32DLLEntry IsBadCodePtr       KERNEL32.DLL IsBadCodePtr
Int32DLLEntry IsBadReadPtr       KERNEL32.DLL IsBadReadPtr
Int32DLLEntry IsBadWritePtr      KERNEL32.DLL IsBadWritePtr
Int32DLLEntry IsBadStringPtrA    KERNEL32.DLL IsBadStringPtrA
Int32DLLEntry IsBadStringPtrW    KERNEL32.DLL IsBadStringPtrW

DEFER IsBadStringPtr
' IsBadStringPtrA IS IsBadStringPtr

Int32DLLEntry GetStdHandle       KERNEL32.DLL GetStdHandle

Int32DLLEntry AreFileApisANSI    KERNEL32.DLL AreFileApisANSI
VoidDLLEntry  SetFileApisToANSI  KERNEL32.DLL SetFileApisToANSI
VoidDLLEntry  SetFileApisToOEM   KERNEL32.DLL SetFileApisToOEM

Int32DLLEntry DeleteFileA        KERNEL32.DLL DeleteFileA
Int32DLLEntry DeleteFileW        KERNEL32.DLL DeleteFileW

DEFER DeleteFile
' DeleteFileA IS DeleteFile

Int32DLLEntry MoveFileA          KERNEL32.DLL MoveFileA
Int32DLLEntry MoveFileW          KERNEL32.DLL MoveFileW

DEFER MoveFile
' MoveFileA IS MoveFile

Int32DLLEntry GetFileAttributesA KERNEL32.DLL GetFileAttributesA
Int32DLLEntry GetFileAttributesW KERNEL32.DLL GetFileAttributesW

DEFER GetFileAttributes
' GetFileAttributesA IS GetFileAttributes

Int32DLLEntry GetFileSize        KERNEL32.DLL GetFileSize

VoidDLLEntry  ExitProcess        KERNEL32.DLL ExitProcess

Int32DLLEntry GetCommandLineA    KERNEL32.DLL GetCommandLineA
Int32DLLEntry GetCommandLineW    KERNEL32.DLL GetCommandLineW

DEFER GetCommandLine
' GetCommandLineA IS GetCommandLine

Int32DLLEntry lstrlenA           KERNEL32.DLL lstrlenA
Int32DLLEntry lstrlenW           KERNEL32.DLL lstrlenW

DEFER lstrlen
' lstrlenA IS lstrlen

Int32DLLEntry ReadConsoleInputA  KERNEL32.DLL ReadConsoleInputA
Int32DLLEntry ReadConsoleInputW  KERNEL32.DLL ReadConsoleInputW

DEFER ReadConsoleInput
' ReadConsoleInputA IS ReadConsoleInput

VoidDLLEntry WriteConsoleA  KERNEL32.DLL WriteConsoleA
VoidDLLEntry WriteConsoleW  KERNEL32.DLL WriteConsoleW

DEFER WriteConsole
' WriteConsoleA IS WriteConsole

Int32DLLEntry GetNumberOfConsoleInputEvents KERNEL32.DLL GetNumberOfConsoleInputEvents

CREATE-REPORT !
