CONFIG_DATAFLAG := 1
CONFIG_NULL := 1
CONFIG_PRINT_CR := 1 ; print CR when line end reached
CONFIG_SCRTCH_ORDER := 3
CONFIG_SMALL := 1

CRLF_1 := CR
CRLF_2 := LF

ZP_START1 = $5B
ZP_START = $00

JMPADRS = DSCLEN + 1
LOWTRX = LOWTR

GORESTART       := $0000
GOSTROUT        := $0003
GOAYINT         := $0006
GOGIVEAYF       := $0008

USR             := $000A
Z15             := $000D
POSX            := $000E
Z17             := $000F
Z18             := $0010
LINNUM          := $0011
TXPSV           := $0011
INPUTBUFFER     := $0013
INPUTBUFFERX    := $0000

L0207           := $0207
L020A           := $020A
MONRDKEY        := $FFEB
MONCOUT         := $FFEE
MONISCNTC       := $FFF1
LOAD            := $FFF4
SAVE            := $FFF7

STACK_TOP		:= $FC
SPACE_FOR_GOSUB := $33
NULL_MAX		:= $0A

RAMSTART2		:= $0300