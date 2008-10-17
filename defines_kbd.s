CONFIG_11 := 1
CONFIG_11A := 1
CONFIG_2 := 1
CONFIG_2A := 1
CONFIG_2B := 1

CONFIG_NO_POKE := 1
CONFIG_NO_READ_Y_IS_ZERO_HACK := 1
CONFIG_SAFE_NAMENOTFOUND := 1
CONFIG_SCRTCH_ORDER := 3
CONFIG_SMALL := 1
; INPUTBUFFER > $0100

CRLF_1 := LF
CRLF_2 := CR

ZP_START1 = $6
ZP_START = $05


POSX            := $0010
Z17             := $06FC;$000F
Z18             := $06FD;$0010
LINNUM          := $0013;11
TXPSV           := $0049
INPUTBUFFER     := $0700
INPUTBUFFERX    := $0700

;CHARAC          := $0006;5B
;ENDCHR          := $0007;5C
;EOLPNTR         := $0008;5D
;DIMFLG          := $0009;5E
;VALTYP          := $000A;5F
;DATAFLG         := $000B;60
;SUBFLG          := $000C;61
;INPUTFLG        := $000D;62
;CPRMASK         := $000E;63
;Z14             := $000F;64                        ; Ctrl+O flag

JMPADRS         := $0093;A1
LOWTRX          := $0094;AA                        ; $AB also EXPSGN?
Z96				:= $0096

L06FE			:= $06FE

MONCOUT         := $FDFA

STACK_TOP		:= $FE
SPACE_FOR_GOSUB := $49

CONST_MEMSIZ	:= $3FFF

RAMSTART2		:= $0300

LC000	= $C000
LC009	= $C009
LDE24	= $DE24
LDE42	= $DE42 ; PRIMM ?
LDE48	= $DE48
LDE53	= $DE53
LDE7F	= $DE7F
LDE8C	= $DE8C

L6874	= $6874

