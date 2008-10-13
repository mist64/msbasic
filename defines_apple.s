CONFIG_11 := 1
CBM2_APPLE := 1
CONFIG_SAFE_NAMENOTFOUND := 1
CBM2_KIM_APPLE := 1 ; OUTDO difference
CBM1_APPLE := 1
CBM_APPLE := 1
KIM_APPLE := 1
CONFIG_SCRTCH_ORDER := 1
CONFIG_PRINT_CR := 1 ; print CR when line end reached
CONFIG_IO_MSB := 1 ; IO is 7 bit, MSB may be randomly set
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

MONRDKEY        := $FD0C
MONCOUT         := $FDED

STACK_TOP		:= $F8
SPACE_FOR_GOSUB := $36

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

L0008 := $08
L0006 := $06
L000A := $0A
L00A4 := $A4
