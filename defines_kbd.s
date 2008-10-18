; configuration
CONFIG_2B := 1

CONFIG_NO_POKE := 1
CONFIG_NO_READ_Y_IS_ZERO_HACK := 1
CONFIG_SAFE_NAMENOTFOUND := 1
CONFIG_SCRTCH_ORDER := 3
CONFIG_SMALL := 1

; zero page
ZP_START1 = $00
ZP_START2 = $0F
ZP_START3 = $06
ZP_START4 = $15

; extra/override ZP variables
TXPSV           := $0049
JMPADRS         := $0093
LOWTRX          := $0094                        ; $AB also EXPSGN?
Z96				:= $0096
Z17             := $06FC
Z18             := $06FD

; inputbuffer
INPUTBUFFER     := $0700

; constants
STACK_TOP		:= $FE
SPACE_FOR_GOSUB := $49
CRLF_1 := LF
CRLF_2 := CR

; magic memory locations
L06FE			:= $06FE
L6874			:= $6874

; memory layout
RAMSTART2		:= $0300
CONST_MEMSIZ	:= $3FFF

; monitor functions
MONCOUT         := $FDFA
LC000			:= $C000
LC009			:= $C009
LDE24			:= $DE24
PRIMM			:= $DE42
LDE48			:= $DE48
LDE53			:= $DE53
LDE7F			:= $DE7F
LDE8C			:= $DE8C


