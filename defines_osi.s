CONFIG_SMALL := 1
CONFIG_SCRTCH_ORDER := 1
CONFIG_NULL := 1
CONFIG_PRINT_CR := 1 ; print CR when line end reached
CONFIG_DATAFLAG := 1

ZP_START = $65

JMPADRS = DSCLEN + 1
LOWTRX = LOWTR

Z00             := $0000
L0001           := $0001
L0002           := $0002
GOWARM          := $0003
GOSTROUT        := $0006
GOGIVEAYF       := $0008

USR             := $000A
Z15             := $000D
Z16             := $000E
Z17             := $000F
Z18             := $0010
LINNUM          := $0011
TXPSV           := $0011
INPUTBUFFER     := $0013
INPUTBUFFERX    := $0000
CHARAC          := $005B
ENDCHR          := $005C
EOLPNTR         := $005D
DIMFLG          := $005E
VALTYP          := $005F
DATAFLG         := $0060
SUBFLG          := $0061
INPUTFLG        := $0062
CPRMASK         := $0063
Z14             := $0064                        ; Ctrl+O flag

RNDSEED			:= $00D4

L0207           := $0207
L020A           := $020A
L2A13           := $2A0A
MONRDKEY        := $FFEB
MONCOUT         := $FFEE
MONISCNTC       := $FFF1
LOAD            := $FFF4
SAVE            := $FFF7

STACK_TOP		:= $FC
SPACE_FOR_GOSUB := $33
NUM_TOKENS		:= $1C
NULL_MAX		:= $0A
MAX_EXPON = 10

RAMSTART3		:= $0300
RAMSTART2		:= $0300