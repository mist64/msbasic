KIM_KBD := 1
CONFIG_11 := 1
CONFIG_11A := 1
CONFIG_SAFE_NAMENOTFOUND := 1
CBM2_KIM_APPLE := 1 ; OUTDO difference
KIM_APPLE := 1
CBM2_MICROTAN := 1
KBD_MICROTAN := 1
KIM_MICROTAN := 1
APPLE_MICROTAN := 1

CONFIG_2 := 1

CONFIG_NULL := 1
CONFIG_PRINT_CR := 1 ; print CR when line end reached

CRLF_1 := $0D
CRLF_2 := $0A

ZP_START = $85

JMPADRS = DSCLEN + 1
LOWTRX = LOWTR

Z00             := $0017
L0001           := $0001
L0002           := $0002
GOWARM          := $001A
GOSTROUT        := $001D
GOGIVEAYF       := $001F

CHARAC          := $000A+$1A
ENDCHR          := $000B+$1A
EOLPNTR         := $000C+$1A
DIMFLG          := $000D+$1A
VALTYP          := $000E+$1A
DATAFLG         := $0010+$1A
SUBFLG          := $0011+$1A
INPUTFLG        := $0012+$1A
CPRMASK         := $0013+$1A
Z14             := $0014+$1A                        ; Ctrl+O flag
Z15             := $0015+$1A
POSX            := $0016+$1A
Z17             := $0017+$1A
Z18             := $0018+$1A
LINNUM          := $0019+$1A
TXPSV           := $00BA
INPUTBUFFER     := $001B+$1A
INPUTBUFFERX    := $0000

L1800           := $1800
L1873           := $1873
MONRDKEY        := $1E5A
MONCOUT         := $1EA0

STACK_TOP		:= $FE
SPACE_FOR_GOSUB := $3E
NULL_MAX		:= $F0 ; probably different in original version; the image I have seems to be modified; see PDF


RAMSTART2 := $AAAA
USR := $AAAA
SAVE := $AAAA
LOAD := $AAAA
LE21C := $AAAA
LC3F0 := $AAAA
LE219 := $AAAA
LE21F := $AAAA

LFDFA := $FDFA
LFE73 := $FE73
LFE75 := $FE75
L000A := $0A