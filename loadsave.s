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
