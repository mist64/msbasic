; configuration
CONFIG_11 := 1
CONFIG_11A := 1

CONFIG_MONCOUT_DESTROYS_Y := 1
CONFIG_NULL := 1
CONFIG_PRINT_CR := 1 ; print CR when line end reached
CONFIG_ROR_WORKAROUND := 1
CONFIG_SAFE_NAMENOTFOUND := 1
CONFIG_SCRTCH_ORDER := 2

; zero page
ZP_START0 = $00
ZP_START1 = $0A
ZP_START2 = $63

JMPADRS = DSCLEN + 1
LOWTRX = LOWTR

Z15             := $0015
POSX            := $0016
Z17             := $0017
Z18             := $0018
LINNUM          := $0019

INPUTBUFFER     := $001B

TXPSV           := $0019
INPUTBUFFERX    := $0000

; magic memory locations
L1800           := $1800
L1873           := $1873

; monitor functions
MONRDKEY        := $1E5A
MONCOUT         := $1EA0

; constants
STACK_TOP		:= $FC
SPACE_FOR_GOSUB := $36
NULL_MAX		:= $F2 ; probably different in original version; the image I have seems to be modified; see PDF
CRLF_1 := CR
CRLF_2 := LF

