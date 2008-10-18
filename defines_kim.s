; configuration
CONFIG_11A := 1

CONFIG_MONCOUT_DESTROYS_Y := 1
CONFIG_NULL := 1
CONFIG_PRINT_CR := 1 ; print CR when line end reached
CONFIG_RAM := 1
CONFIG_ROR_WORKAROUND := 1
CONFIG_SAFE_NAMENOTFOUND := 1
CONFIG_SCRTCH_ORDER := 2

; zero page
ZP_START1 = $00
ZP_START2 = $15
ZP_START3 = $0A
ZP_START4 = $63

; constants
STACK_TOP		:= $FC
SPACE_FOR_GOSUB := $36
NULL_MAX		:= $F2 ; probably different in original version; the image I have seems to be modified; see PDF
WIDTH			:= 72
WIDTH2			:= 56

; magic memory locations
L1800           := $1800
L1873           := $1873

; monitor functions
MONRDKEY        := $1E5A
MONCOUT         := $1EA0

