; configuration
CONFIG_2A := 1

CONFIG_NULL := 1
CONFIG_PRINT_CR := 1 ; print CR when line end reached
CONFIG_SAFE_NAMENOTFOUND := 1
CONFIG_SCRTCH_ORDER := 1
CONFIG_PEEK_SAVE_LINNUM := 1
CONFIG_SMALL_ERROR := 1

; zero page
ZP_START1 = $00
ZP_START2 = $18
ZP_START3 = $0d
ZP_START4 = $66

;extra ZP variables
USR             := $0A
TXPSV			:= LASTOP
ZD3             := $D3
ZD4             := $D4

GET      := IQERR
COS      := USR1
SIN      := USR1
TAN      := USR1
ATN      := USR1

; inputbuffer
INPUTBUFFER     := $001E

; constants
STACK_TOP		:= $FE
SPACE_FOR_GOSUB := $3E
NULL_MAX		:= $F0
CRLF_1 := CR
CRLF_2 := LF
WIDTH			:= 72
WIDTH2			:= 56

; memory layout
RAMSTART2	:= $0200

; monitor functions
ASCNIB   := $8275
INSTAT   := $8386
MONRDKEY := $8A1B
MONCOUT  := $8A47
ACCESS   := $8B86
L8C78    := $8C78
DUMPT    := $8E87

P3L      := $A64A
P3H      := P3L+1
P2L      := $A64C
P2H      := P2L+1
P1L      := $A64E