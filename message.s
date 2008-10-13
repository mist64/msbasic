.segment "CODE"

QT_ERROR:
.ifdef KBD
        .byte   " err"
.else
.ifdef APPLE
        .byte   " ERR"
		.byte	$07,$07
.else
        .byte   " ERROR"
.endif
.endif
        .byte   $00
.ifndef KBD
QT_IN:
        .byte   " IN "
        .byte   $00
QT_OK:
.ifdef APPLE
        .byte   $0D,$00,$00
        .byte   "K"
.else
		.byte   $0D,$0A
.ifdef CONFIG_CBM_ALL
        .byte   "READY."
.else
        .byte   "OK"
.endif
.endif
        .byte   $0D,$0A,$00
.else
		.byte	$54,$D2 ; ???
OKPRT:
		jsr     LDE42
        .byte   $0D,$0D
        .byte   ">>"
        .byte   $0D,$0A,$00
        rts
        nop
.endif
QT_BREAK:
.ifdef KBD
		.byte	$0D,$0A
        .byte   " Brk"
        .byte   $00
        .byte   $54,$D0 ; ???
.else
		.byte $0D,$0A
.ifdef MICROTAN
		.byte   " "
.endif
        .byte   "BREAK"
        .byte   $00
.endif
