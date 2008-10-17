.if .def(cbmbasic1)
CBM1 := 1
.include "defines_cbm.s"
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
.include "defines_cbm.s"
.elseif .def(kbdbasic)
KBD := 1
.include "defines_kbd.s"
.elseif .def(microtan)
MICROTAN := 1
.include "defines_microtan.s"
.endif

.ifdef CONFIG_SMALL
BYTES_FP		:= 4
.else
BYTES_FP		:= 5
.endif

.ifdef APPLE
BYTES_PER_ELEMENT := 6 ; ???
.else
BYTES_PER_ELEMENT := BYTES_FP
.endif
BYTES_PER_VARIABLE := BYTES_FP+2
MANTISSA_BYTES	:= BYTES_FP-1
BYTES_PER_FRAME := 2*BYTES_FP+8
FOR_STACK1		:= 2*BYTES_FP+5
FOR_STACK2		:= BYTES_FP+4

.ifdef CBM1
MAX_EXPON = 12
.else
MAX_EXPON = 10
.endif

STACK           := $0100

CR=13
LF=10
