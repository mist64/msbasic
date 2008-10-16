KIM_KBD := 1
CONFIG_11 := 1
CONFIG_11A := 1
CONFIG_SAFE_NAMENOTFOUND := 1
CBM2_KIM_APPLE := 1 ; OUTDO difference
KIM_APPLE := 1
CONFIG_NULL := 1
CONFIG_PRINT_CR := 1 ; print CR when line end reached
CONFIG_ROR_WORKAROUND := 1
CONFIG_MONCOUT_DESTROYS_Y := 1
.define CONFIG_SCRTCH_ORDER 2

CRLF_1 := $0D
CRLF_2 := $0A

ZP_START = $63

JMPADRS = DSCLEN + 1
LOWTRX = LOWTR

GORESTART       := $0000
L0001           := $0001
L0002           := $0002
GOSTROUT        := $0003
GOAYINT         := $0006
GOGIVEAYF       := $0008

CHARAC          := $000A
ENDCHR          := $000B
EOLPNTR         := $000C
DIMFLG          := $000D
VALTYP          := $000E
DATAFLG         := $0010
SUBFLG          := $0011
INPUTFLG        := $0012
CPRMASK         := $0013
Z14             := $0014                        ; Ctrl+O flag
Z15             := $0015
POSX            := $0016
Z17             := $0017
Z18             := $0018
LINNUM          := $0019
TXPSV           := $0019
INPUTBUFFER     := $001B
INPUTBUFFERX    := $0000

L1800           := $1800
L1873           := $1873
MONRDKEY        := $1E5A
MONCOUT         := $1EA0

STACK_TOP		:= $FC
SPACE_FOR_GOSUB := $36
NULL_MAX		:= $F2 ; probably different in original version; the image I have seems to be modified; see PDF

