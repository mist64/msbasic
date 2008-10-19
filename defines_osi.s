; configuration
CONFIG_10A := 1

CONFIG_DATAFLG := 1
CONFIG_NULL := 1
CONFIG_PRINT_CR := 1 ; print CR when line end reached
CONFIG_SCRTCH_ORDER := 3
CONFIG_SMALL := 1

; zero page
ZP_START1 = $00
ZP_START2 = $0D
ZP_START3 = $5B
ZP_START4 = $65

;extra ZP variables
USR             := $000A

; constants
STACK_TOP		:= $FC
SPACE_FOR_GOSUB := $33
NULL_MAX		:= $0A
WIDTH			:= 72
WIDTH2			:= 56

; memory layout
RAMSTART2		:= $0300

; magic memory locations
L0200           := $0200

; monitor functions
MONRDKEY        := $FFEB
MONCOUT         := $FFEE
MONISCNTC       := $FFF1
LOAD            := $FFF4
SAVE            := $FFF7
