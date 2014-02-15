.segment "EXTRA"

.ifdef KIM
.include "kim_extra.s"
.endif

.ifdef CONFIG_CBM1_PATCHES
.include "cbm1_patches.s"
.endif

.ifdef KBD
.include "kbd_extra.s"
.endif

.ifdef APPLE
.include "apple_extra.s"
.endif

.ifdef MICROTAN
.include "microtan_extra.s"
.endif

.ifdef AIM65
.include "aim65_extra.s"
.endif

.ifdef SYM1
        .byte   0,0,0
.endif