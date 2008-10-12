; ----------------------------------------------------------------------------
; Macros

; htasc - set the hi bit on the last byte of a string for termination
.macro htasc str
	.repeat	.strlen(str)-1,I
		.byte	.strat(str,I)
	.endrep
	.byte	.strat(str,.strlen(str)-1) | $80
.endmacro

.macro keyword_addr key, vec, token
        .segment "VECTORS"
		.addr	vec
        .segment "KEYWORDS"
		htasc	key
		define_token token
.endmacro

.macro define_token token
        .segment "DUMMY"
		.ifnblank token
			token := <(*-DUMMY_START)+$80
		.endif
		.res 1
.endmacro

.macro keyword_rts key, vec, token
        .segment "VECTORS"
		.word	vec-1
        .segment "KEYWORDS"
		htasc	key
		define_token token
.endmacro

.macro keyword key, token
		.segment "KEYWORDS"
		htasc	key
		define_token token
.endmacro

;.macro define_token name
;        .segment "VECTORS"
;		name := <(*-TOKEN_ADDRESS_TABLE)/2+$80
;.endmacro

.macro define_token_init
		.segment "DUMMY"
DUMMY_START:
.endmacro
