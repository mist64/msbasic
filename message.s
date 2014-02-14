; global messages: "error", "in", "ready", "break"

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
        .byte   0

.ifndef KBD
QT_IN:
        .byte   " IN "
        .byte   $00
.endif

.ifdef KBD
		.byte	$54,$D2 ; ???
OKPRT:
		jsr     PRIMM
        .byte   CR,CR,">>",CR,LF
		.byte	0
        rts
        nop
.else
 .ifndef AIM65
QT_OK:
  .ifdef CONFIG_CBM_ALL
		.byte   CR,LF,"READY.",CR,LF
  .else
    .ifdef APPLE
		; binary patch!
        .byte   CR,0,0,"K",CR,LF
    .else
		.byte   CR,LF,"OK",CR,LF
    .endif
  .endif
		.byte	0
 .endif
.endif
QT_BREAK:

.ifdef KBD
		.byte	CR,LF," Brk"
        .byte   0
        .byte   $54,$D0 ; ???
.elseif .def(MICROTAN) || .def(AIM65)
		.byte CR,LF," BREAK"
        .byte   0
.else
		.byte CR,LF,"BREAK"
        .byte   0
.endif
