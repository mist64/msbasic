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
ZP_START2 = $10
ZP_START3 = $06
ZP_START4 = $5E

;extra ZP variables
USR             := $03
TXPSV			:= LASTOP

NULL            := IQERR

; inputbuffer
INPUTBUFFER     := $0016

;extra stack
STACK2          := $0200

; constants
STACK_TOP		:= $FD
SPACE_FOR_GOSUB := $44
NULL_MAX		:= $F2
CRLF_1 := CR
CRLF_2 := LF
WIDTH			:= 20
WIDTH2			:= 10

; memory layout
RAMSTART2	:= $0211

; monitor functions
PRIFLG := $A411
INFLG  := $A412
OUTFLG := $A413
DRA2   := $A480
DRB2   := $A482

DU13   := $E520
PSLS   := $E7DC
LOAD   := $E848
WHEREO := $E871
OUTPUT := $E97A
INALL  := $E993
OUTALL := $E9BC
CRCK   := $EA24
GETKEY := $EC40
GETKY  := $EC43
ROONEK := $ECEF
CUREAD := $FE83