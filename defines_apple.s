; http://apple2.org.za/gswv/a2zine/GS.WorldView/Resources/GS.TECH.INFO/AppleSoft/

; configuration
CONFIG_11 := 1
CONFIG_IO_MSB := 1 ; all I/O has bit #7 set
CONFIG_PRINT_CR := 1 ; print CR when line end reached
CONFIG_SAFE_NAMENOTFOUND := 1
CONFIG_SCRTCH_ORDER := 3
; INPUTBUFFER > $0100

; zero page
ZP_START = $0D
ZP_HOLE = $3D

JMPADRS = DSCLEN + 1
LOWTRX = LOWTR

GORESTART       := $0000
GOSTROUT        := $0003
GOAYINT         := $0006
GOGIVEAYF       := $0008

USR				:= $000A

POSX            := $0050
Z17             := $0051
Z18             := $0052
LINNUM          := $0053

TXPSV           := $0053
INPUTBUFFER     := $0200
INPUTBUFFERX    := $0200

MONRDKEY        := $FD0C
MONCOUT         := $FDED

; constants
STACK_TOP		:= $F8
SPACE_FOR_GOSUB := $36
CRLF_1 := CR
CRLF_2 := $80

; memory layout
RAMSTART2	:= $2A00

; monitor functions
LF689			:= $F689
LF800			:= $F800
LF819			:= $F819
LF828			:= $F828
LF864			:= $F864
TEX				:= $FB2F
LFB40			:= $FB40
LFD0C			:= $FD0C
LFD6A			:= $FD6A
LFECD			:= $FECD
LFEFD			:= $FEFD

