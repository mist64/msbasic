; configuration
; oldest known version, no CONFIG_n

CONFIG_CBM_ALL := 1
CONFIG_CBM1_PATCHES := 1 ; ** don't turn off! **

CONFIG_DATAFLG := 1
CONFIG_FILE := 1; support PRINT#, INPUT#, GET#, CMD
CONFIG_NO_CR := 1; terminal doesn't need explicit CRs on line ends
CONFIG_NO_LINE_EDITING := 1; support for "@", "_", BEL etc.
CONFIG_PRINTNULLS := 1; whether PRINTNULLS does anything
CONFIG_SCRTCH_ORDER := 2

; zero page
ZP_START1 = $00
ZP_START2 = $04
ZP_START3 = $5A
ZP_START4 = $65

; extra ZP variables
CURDVC			:= $0003
TISTR			:= $0200
Z96				:= $020C
USR				:= GORESTART

; constants
SPACE_FOR_GOSUB := $36
STACK_TOP		:= $FC
NULL_MAX		:= $0A
MAX_EXPON		:= 12 ; XXX override

RAMSTART2		:= $0400

; magic memory locations
ENTROPY = $9044

; monitor functions
OPEN	:= $FFC0
CLOSE	:= $FFC3
CHKIN	:= $FFC6
CHKOUT	:= $FFC9
CLRCH	:= $FFCC
CHRIN	:= $FFCF
CHROUT	:= $FFD2
LOAD	:= $FFD5
SAVE	:= $FFD8
VERIFY	:= $FFDB
SYS		:= $FFDE
ISCNTC	:= $FFE1
GETIN	:= $FFE4
CLALL	:= $FFE7
LE7F3	:= $E7F3; for CBM1
MONCOUT	:= CHROUT
MONRDKEY := GETIN
