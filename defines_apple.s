CONFIG_11 := 1
CBM2_APPLE := 1
CONFIG_SAFE_NAMENOTFOUND := 1
CBM2_KIM_APPLE := 1 ; OUTDO difference
CBM1_APPLE := 1
CBM_APPLE := 1
KIM_APPLE := 1
CONFIG_SCRTCH_ORDER := 1
CONFIG_PRINT_CR := 1 ; print CR when line end reached
; INPUTBUFFER > $0100

ZP_START = $55

JMPADRS = DSCLEN + 1
LOWTRX = LOWTR

Z00             := $0000
L0001           := $000B
GOWARM          := $0003
GOSTROUT        := $0006
GOGIVEAYF       := $0008

USR				:= $000A
CHARAC          := $000D
ENDCHR          := $000E
EOLPNTR         := $000F
DIMFLG          := $0010
VALTYP          := $0011
DATAFLG         := $0013
SUBFLG          := $0014
INPUTFLG        := $0015
CPRMASK         := $0016
Z14             := $0017                        ; Ctrl+O flag
Z15             := $0018
Z16             := $0050
Z17             := $0051
Z18             := $0052
LINNUM          := $0053
TXPSV           := $0053
INPUTBUFFER     := $0200
INPUTBUFFERX    := $0200

L1800           := $1800
L1873           := $1873
MONRDKEY        := $FD0C
MONCOUT         := $FDED

STACK_TOP		:= $F8
SPACE_FOR_GOSUB := $36
NUM_TOKENS		:= $1C
MAX_EXPON = 10

RAMSTART3	:= $2A00
RAMSTART2	:= $2A00
LF689 := $F689
LF800 := $F800
LF819 := $F819
LF828 := $F828
LF864 := $F864
TEX		:= $FB2F
LFB40 := $FB40
LFD0C	:= $FD0C
LFD6A := $FD6A
LFECD	:= $FECD
LFEFD	:= $FEFD

L0D28	:= $AAAA
L000A	:= $000A
L123C	:= $AAAA
L2AAA := $AAAA
L2A52 := $AAAA
L2AA3 := $AAAA
L1008 := $AAAA
L2A6D := $AAAA
L2A68 := $AAAA
L0008 := $08
L0006 := $06
L1F20 := $AAAA
L00A4 := $A4
L1751 := $AAAA
L2198 := $AAAA
L13D7 := $AAAA
