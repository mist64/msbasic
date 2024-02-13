; Inspired by https://github.com/beneater/msbasic

; TODO implement

LOAD:
                rts

SAVE:
                rts


; On return, carry flag indicates whether a key was pressed
; If a key was pressed, the key value will be in the A register
;
; Modifies: flags, A
MONRDKEY:
CHRIN:
;                lda     ACIA_STATUS
;                and     #$08
;                beq     @no_keypressed
;                lda     ACIA_DATA
;                jsr     CHROUT			; echo
;                sec
;                rts
;@no_keypressed:
                clc
                rts


; Output a character (from the A register)
;
; Modifies: flags
MONCOUT:
CHROUT:
;                pha
;                sta     ACIA_DATA
;                lda     #$FF
;@txdelay:       dec
;                bne     @txdelay
;                pla
                rts

; TODO set up reset vector

;.segment "RESETVEC"
;                .word   $0F00           ; NMI vector
;                .word   RESET           ; RESET vector
;                .word   $0000           ; IRQ vector

