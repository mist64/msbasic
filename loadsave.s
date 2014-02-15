.segment "CODE"

.ifdef APPLE
.include "apple_loadsave.s"
.endif
.ifdef KIM
.include "kim_loadsave.s"
.endif
.ifdef MICROTAN
.include "microtan_loadsave.s"
.endif
.ifdef AIM65
.include "aim65_loadsave.s"
.endif
.ifdef SYM1
.include "sym1_loadsave.s"
.endif