; ----------------------------------------------------------------------------
; Macros

; htasc - set the hi bit on the last byte of a string for termination
.macro htasc str
	.repeat	.strlen(str)-1,I
		.byte	.strat(str,I)
	.endrep
	.byte	.strat(str,.strlen(str)-1) | $80
.endmacro
