; Microsoft BASIC for 6502

.debuginfo +

.setcpu "6502"
.macpack longbranch

.include "defines.s"
.include "macros.s"
.include "zeropage.s"

.include "header.s"
.include "token.s"
.include "error.s"
.include "message.s"
.include "memory.s"
.include "program.s"
.include "flow.s"
.include "misc1.s"
.include "print.s"
.include "input.s"
.include "eval.s"
.include "var.s"
.include "array.s"
.include "misc2.s"
.include "string.s"
.include "misc3.s"
.ifndef KBD
.include "poke.s"
.endif
.include "float.s"
.include "chrget.s"
.include "rnd.s"
.include "trig.s"
.include "init.s"
