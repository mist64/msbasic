; http://apple2.org.za/gswv/a2zine/GS.WorldView/Resources/GS.TECH.INFO/AppleSoft/

CONFIG_11 := 1
CONFIG_IO_MSB := 1 ; all I/O has bit #7 set
CONFIG_PRINT_CR := 1 ; print CR when line end reached
CONFIG_SAFE_NAMENOTFOUND := 1
CONFIG_SCRTCH_ORDER := 3
; INPUTBUFFER > $0100

CRLF_1 := CR
CRLF_2 := $80

ZP_START1 = $0D
ZP_START = $3D

JMPADRS = DSCLEN + 1
LOWTRX = LOWTR

GORESTART       := $0000
GOSTROUT        := $0003
GOAYINT         := $0006
GOGIVEAYF       := $0008

USR				:= $000A

;CHARAC          := $000D
;ENDCHR          := $000E
;EOLPNTR         := $000F
;DIMFLG          := $0010
;VALTYP          := $0011
;DATAFLG         := $0013
;SUBFLG          := $0014
;INPUTFLG        := $0015
;CPRMASK         := $0016
;Z14             := $0017                        ; Ctrl+O flag

POSX            := $0050
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

