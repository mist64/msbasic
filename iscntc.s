.segment "CODE"
; ----------------------------------------------------------------------------
; SEE IF CONTROL-C TYPED
; ----------------------------------------------------------------------------
.ifndef CONFIG_CBM_ALL
.include "cbm_iscntc.s"
.endif
.ifdef KBD
.include "kbd_iscntc.s"
.endif
.ifdef OSI
.include "osi_iscntc.s"
.endif
.ifdef APPLE
.include "apple_iscntc.s"
.endif
.ifdef KIM
.include "kim_iscntc.s"
.endif
.ifdef MICROTAN
.include "microtan_iscntc.s"
.endif
.ifdef AIM65
.include "aim65_iscntc.s"
.endif
.ifdef SYM1
.include "sym1_iscntc.s"
.endif
;!!! runs into "STOP"