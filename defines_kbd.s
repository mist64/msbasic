CONFIG_SCRTCH_ORDER := 1
CONFIG_SMALL := 1
CBM2_KBD := 1
KIM_KBD := 1
CONFIG_11 := 1
CONFIG_11_NOAPPLE := 1
CONFIG_SAFE_NAMENOTFOUND := 1
; INPUTBUFFER > $0100

ZP_START = $15

Z00             := $0700
L0001           := $0001
L0002           := $0002
GOWARM          := $0003
GOSTROUT        := $0006
GOGIVEAYF       := $0008

USR             := $000A
Z15             := $000D
Z16             := $0010
Z17             := $06FC;$000F
Z18             := $06FD;$0010
LINNUM          := $0013;11
TXPSV           := $0049
INPUTBUFFER     := $0700
INPUTBUFFERX    := $0700
CHARAC          := $0006;5B
ENDCHR          := $0007;5C
EOLPNTR         := $0008;5D
DIMFLG          := $0009;5E
VALTYP          := $000A;5F
DATAFLG         := $000B;60
SUBFLG          := $000C;61
INPUTFLG        := $000D;62
CPRMASK         := $000E;63
Z14             := $000F;64                        ; Ctrl+O flag

JMPADRS         := $0093;A1
LOWTRX          := $0094;AA                        ; $AB also EXPSGN?

RNDSEED			:= $00D4

L0207           := $0207
L020A           := $020A
;L2A13           := $2A0A
MONRDKEY        := $FFEB
MONCOUT         := $FDFA
MONISCNTC       := $FFF1
LOAD            := $FFF4
SAVE            := $FFF7

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

