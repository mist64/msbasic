; htasc - set the hi bit on the last byte of a string for termination
; (by Tom Greene)
.macro htasc str
	.repeat	.strlen(str)-1,I
		.byte	.strat(str,I)
	.endrep
	.byte	.strat(str,.strlen(str)-1) | $80
.endmacro

; For every token, a byte gets put into segment "DUMMY".
; This way, we count up with every token. The DUMMY segment
; doesn't get linked into the binary.
.macro init_token_tables
        .segment "VECTORS"
TOKEN_ADDRESS_TABLE:
        .segment "KEYWORDS"
TOKEN_NAME_TABLE:
		.segment "DUMMY"
DUMMY_START:
.endmacro

; optionally define token symbol
; count up token number
.macro define_token token
        .segment "DUMMY"
		.ifnblank token
			token := <(*-DUMMY_START)+$80
		.endif
		.res 1; count up in any case
.endmacro

; lay down a keyword, optionally define a token symbol
.macro keyword key, token
		.segment "KEYWORDS"
		htasc	key
		define_token token
.endmacro

; lay down a keyword and an address (RTS style),
; optionally define a token symbol
.macro keyword_rts key, vec, token
        .segment "VECTORS"
		.word	vec-1
		keyword key, token
.endmacro

; lay down a keyword and an address,
; optionally define a token symbol
.macro keyword_addr key, vec, token
        .segment "VECTORS"
		.addr	vec
		keyword key, token
.endmacro

.macro count_tokens
        .segment "DUMMY"
		NUM_TOKENS := <(*-DUMMY_START)
.endmacro

.macro init_error_table
        .segment "ERROR"
ERROR_MESSAGES:
.endmacro

.macro define_error error, msg
        .segment "ERROR"
		error := <(*-ERROR_MESSAGES)
		htasc msg
.endmacro

;---------------------------------------------
; set the MSB of every byte of a string
.macro asc80 str
	.repeat	.strlen(str),I
		.byte	.strat(str,I)+$80
	.endrep
.endmacro

