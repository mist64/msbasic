.if .def(cbmbasic1)
CBM1 := 1
.include "defines_cbm1.s"
.elseif .def(osi)
OSI := 1
.include "defines_osi.s"
.elseif .def(applesoft)
APPLE := 1
.include "defines_apple.s"
.elseif .def(kb9)
KIM := 1
.include "defines_kim.s"
.elseif .def(cbmbasic2)
CBM2 := 1
.include "defines_cbm2.s"
.elseif .def(kbdbasic)
KBD := 1
.include "defines_kbd.s"
.elseif .def(microtan)
MICROTAN := 1
.include "defines_microtan.s"
.elseif .def(aim65)
AIM65 := 1
.include "defines_aim65.s"
.elseif .def(sym1)
SYM1 := 1
.include "defines_sym1.s"
.endif

.ifdef CONFIG_2C
CONFIG_2B := 1
.endif
.ifdef CONFIG_2B
CONFIG_2A := 1
.endif
.ifdef CONFIG_2A
CONFIG_2 := 1
.endif
.ifdef CONFIG_2
CONFIG_11A := 1
.endif
.ifdef CONFIG_11A
CONFIG_11 := 1
.endif
.ifdef CONFIG_11
CONFIG_10A := 1
.endif

.ifdef CONFIG_SMALL
BYTES_FP		:= 4
CONFIG_SMALL_ERROR := 1
.else
BYTES_FP		:= 5
.endif

.ifndef BYTES_PER_ELEMENT
BYTES_PER_ELEMENT := BYTES_FP
.endif
BYTES_PER_VARIABLE := BYTES_FP+2
MANTISSA_BYTES	:= BYTES_FP-1
BYTES_PER_FRAME := 2*BYTES_FP+8
FOR_STACK1		:= 2*BYTES_FP+5
FOR_STACK2		:= BYTES_FP+4

.ifndef MAX_EXPON
MAX_EXPON = 10
.endif

STACK           := $0100
.ifndef STACK2
STACK2          := STACK
.endif

.ifdef INPUTBUFFER
  .if INPUTBUFFER >= $0100
CONFIG_NO_INPUTBUFFER_ZP := 1
  .endif
  .if INPUTBUFFER = $0200
CONFIG_INPUTBUFFER_0200 := 1
  .endif
.endif
INPUTBUFFERX = INPUTBUFFER & $FF00

CR=13
LF=10

.ifndef CRLF_1
CRLF_1 := CR
CRLF_2 := LF
.endif



