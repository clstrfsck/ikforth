;******************************************************************************
;
;  source.asm
;  IKForth
;
;  Copyright (C) 1999-2016 Illya Kysil
;
;******************************************************************************
;
;******************************************************************************

;  6.2.2218 SOURCE-ID
;  Identifies the input source as follows:
;
;  SOURCE-ID       Input source
;  -1              String (via EVALUATE)
;   0              User input device
;  >0              File handle
                        $CODE   'SOURCE-ID',$SOURCE_ID,VEF_USUAL

                        PUSHDS  <DWORD [EDI + VAR_SOURCE_ID]>
                        $NEXT

;  SOURCE-ID!
                        $CODE   'SOURCE-ID!',$SOURCE_ID_STORE,VEF_USUAL

                        POPDS   <DWORD [EDI + VAR_SOURCE_ID]>
                        $NEXT

;  6.1.2216 SOURCE
;  c-addr is the address of, and u is the number of characters in
;  the input buffer.
;  D: -- c-addr u
                        $NONAME $_SOURCE

                        XT_$FILE_LINE
                        CFETCH  $HASH_FILE_LINE
                        $END_COLON

                        $DEFER  'SOURCE',$SOURCE,$_SOURCE

;   (REPORT-SOURCE)
;   D: c-addr u line-u -- 
                        $COLON  '(REPORT-SOURCE)',$PREPORT_SOURCE
                        $WRITE  'LINE# H# '
                        XT_$HOUT8
                        $WRITE  '  '
                        XT_$TYPE
                        $END_COLON

                        $COLON  'REPORT-REFILL',$REPORT_REFILL
                        XT_$REFILL_SOURCE
                        XT_$2FETCH
                        CFETCH  $INCLUDE_LINE_NUM
                        XT_$PREPORT_SOURCE
                        $END_COLON

                        $COLON  'REPORT-SOURCE',$REPORT_SOURCE
                        XT_$INTERPRET_TEXT
                        CFETCH  $HASH_INTERPRET_TEXT
                        CFETCH  $ERROR_LINE_NUM
                        XT_$PREPORT_SOURCE
                        $END_COLON

                        $COLON  'REPORT-SOURCE!',$REPORT_SOURCE_STORE
                        XT_$SOURCE
                        XT_$REFILL_SOURCE
                        XT_$2STORE
                        CFETCH  $INCLUDE_LINE_NUM
                        CSTORE  $ERROR_LINE_NUM
                        $END_COLON

;  11.6.1.2090 READ-LINE
;  (S c-addr u1 fileid -- u2 flag ior )
                        $DEFER  'READ-LINE',$READ_LINE,$_READ_LINE

;  6.2.2125 REFILL
;  D: -- flag
                        $DEFER  'REFILL',$REFILL,$REFILL_FILE

                        $DEFER  '(SAVE-INPUT)',$PSAVE_INPUT,$SAVE_INPUT_FILE

                        $COLON  'SAVE-INPUT',$SAVE_INPUT
                        XT_$PSAVE_INPUT
                        MATCH   =TRUE, DEBUG {
                           $TRACE_STACK 'SAVE-INPUT',12
                        }
                        $END_COLON

                        $COLON  'RESTORE-INPUT',$RESTORE_INPUT
                        MATCH   =TRUE, DEBUG {
                           $TRACE_STACK 'RESTORE-INPUT-A',12
                        }
                        XT_$1SUB
                        XT_$SWAP
                        XT_$CATCH
                        MATCH   =TRUE, DEBUG {
                           $TRACE_STACK 'RESTORE-INPUT-B',1
                        }
                        $END_COLON

                        $DEFER  '(RESET-INPUT)',$PRESET_INPUT,$RESET_INPUT_FILE

                        $COLON  'RESET-INPUT',$RESET_INPUT
                        XT_$PRESET_INPUT
                        $END_COLON

;  INPUT>R
                        $COLON  'INPUT>R',$INPUT_TO_R,VEF_COMPILE_ONLY

                        XT_$RFROM
                        XT_$SAVE_INPUT
                        MATCH   =TRUE, DEBUG {
                           $TRACE_STACK 'INPUT>R',12
                        }
                        XT_$N_TO_R
                        XT_$TOR
                        $END_COLON

;  R>INPUT
                        $COLON  'R>INPUT',$R_TO_INPUT,VEF_COMPILE_ONLY

                        XT_$RFROM
                        XT_$N_R_FROM
                        MATCH   =TRUE, DEBUG {
                           $TRACE_STACK 'R>INPUT',12
                        }
                        XT_$RESTORE_INPUT
                        XT_$DROP
                        XT_$TOR
                        $END_COLON

