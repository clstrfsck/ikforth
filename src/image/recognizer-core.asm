;******************************************************************************
;
;  recognizer-core.asm
;  IKForth
;
;  Copyright (C) 2016 Illya Kysil
;
;******************************************************************************
;  Core RECOGNIZERs
;******************************************************************************

                $NONAME     R_FAIL_OP
                CTHROW      -13
                CW          $EXIT

                $RTABLE     'R:FAIL',R_FAIL,R_FAIL_OP,R_FAIL_OP,R_FAIL_OP

;  R>INT
;  R:TABLE -- XT-INTERPRET
                $COLON      'R>INT',R2INT
                CW          $FETCH
                CW          $EXIT

;  R>COMP
;  R:TABLE -- XT-COMPILE
                $COLON      'R>COMP',R2COMP
                CW          $CELLADD, $FETCH
                CW          $EXIT

;  R>POST
;  R:TABLE -- XT-POSTPONE
                $COLON      'R>POST',R2POST
                CW          $CELLADD, $CELLADD,$FETCH
                CW          $EXIT

;  DO-RECOGNIZER
;  c-addr len rec-id -- i*x R:TABLE | R:FAIL
                $COLON      'DO-RECOGNIZER',DO_RECOGNIZER
                CW          $DUP, $TOR, $FETCH
DO_REC_LOOP:
                ; S: c-addr len rec-count
                CW          $DUP
                CQBR        DO_REC_LOOP_EXIT
                CW          $DUP, $CELLS, $RFETCH, $ADD, $FETCH
                ; S: c-addr len rec-count rec-xt R: rec-id
                CW          $2OVER, $2TOR, $SWAP, $1SUB, $TOR
                ; S: c-addr len rec-xt R: rec-id c-addr len rec-count'
                CW          $EXECUTE
                CW          $DUP, R_FAIL, $NOEQ
                CQBR        DO_REC_LOOP_CONT
                CW          $2RFROM, $2DROP, $2RFROM, $2DROP
                ; S: R:TABLE
                CW          $EXIT
DO_REC_LOOP_CONT:
                CW          $DROP, $RFROM, $2RFROM, $ROT
                CBR         DO_REC_LOOP
DO_REC_LOOP_EXIT:
                CW          $DROP, $2DROP, $RFROM, $DROP, R_FAIL
                CW          $EXIT

                $RTABLE     'R:NOT-FOUND',R_NOT_FOUND,$NOOP,$NOOP,$NOOP

;  REC:NOT-FOUND
;  ( addr len -- R:NOT-FOUND )
;  imm-flag - one (1) if the definition is immediate, minus-one (-1) otherwise.
                $COLON      'REC:NOT-FOUND',REC_NOT_FOUND
                CW          $INTERPRET_WORD_NOT_FOUND
                CW          R_NOT_FOUND
                CW          $EXIT

                $CREATE     'CORE-RECOGNIZER',CORE_RECOGNIZER
                CC          3
                ; ATTENTION - the first recognizer in the list will be executed last by DO-RECOGNIZER
                CW          REC_NOT_FOUND
                CW          REC_NUM
                CW          REC_WORD

                $VALUE      'FORTH-RECOGNIZER',FORTH_RECOGNIZER,PFA_CORE_RECOGNIZER + IMAGE_BASE