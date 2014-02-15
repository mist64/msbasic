.segment "CODE"
ISCNTC:
        jsr     INSTAT
        bcc     RET1
      
        lda     #$03
        cmp     #$03
;!!! runs into "STOP"