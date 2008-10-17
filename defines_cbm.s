; common:
CONFIG_CBM_ALL := 1

CONFIG_FILE := 1; support PRINT#, INPUT#, GET#, CMD
CONFIG_NO_CR := 1; terminal doesn't need explicit CRs on line ends
CONFIG_NO_LINE_EDITING := 1; support for "@", "_", BEL etc.
CONFIG_SCRTCH_ORDER := 2

.ifdef CBM1
CONFIG_BUG_GET_ERROR := 1; treat GET error like READ error
CONFIG_CBM1_PATCHES := 1 ; ** don't turn off! **
CONFIG_DATAFLAG := 1
CONFIG_INPUTBUFFER_ORDER := 1 ; ldx/ldy or ldy/ldx
CONFIG_PRINTNULLS := 1; whether PRINTNULLS does anything
CONFIG_SPC_IS_CRSR_RIGHT := 1; always print CRSR RIGHT for SPC() (otherwise only for screen output)
.else
CONFIG_11 := 1
CONFIG_11A := 1
CONFIG_2 := 1
CONFIG_2A := 1

CONFIG_DATAFLAG := 1
CONFIG_EASTER_EGG := 1
CONFIG_NO_READ_Y_IS_ZERO_HACK := 1
CONFIG_PEEK_SAVE_LINNUM := 1
; INPUTBUFFER > $0100
.endif


CRLF_1 := CR
CRLF_2 := LF

.ifdef CBM1
ZP_START1 = $5A
ZP_START = $00

JMPADRS = DSCLEN + 1
LOWTRX = LOWTR

USR				:= $0000
GORESTART       := $0000
INPUTBUFFERX    := $0000
Z03				:= $0003 ; same

Z15             := $0004
POSX            := $0005
LINNUM          := $0008
TXPSV			:= $0008
INPUTBUFFER     := $000A

;CHARAC          := $005A
;ENDCHR          := $005B
;EOLPNTR         := $005C
;DIMFLG          := $005D
;VALTYP          := $005E
;DATAFLG         := $0060
;SUBFLG          := $0061
;INPUTFLG        := $0062
;CPRMASK         := $0063
;Z14             := $0064                        ; Ctrl+O flag

Z96				:= $020C

NULL_MAX		:= $0A
.else

ZP_START1 = $03
ZP_START = $05

JMPADRS = DSCLEN + 1
LOWTRX = LOWTR

USR				:= $0000
GORESTART       := $0000

;CHARAC          := $005A-82-5
;ENDCHR          := $005B-82-5
;EOLPNTR         := $005C-82-5
;DIMFLG          := $005D-82-5
;VALTYP          := $005E-82-5
;DATAFLG         := $0060-82-5
;SUBFLG          := $0061-82-5
;INPUTFLG        := $0062-82-5
;CPRMASK         := $0063-82-5
;Z14             := $0064-82-5                        ; Ctrl+O flag

Z03				:= $000E;3 ; same
LINNUM          := $0011;0008

Z96 := $00E8-82
POSX := $0118-82
TXPSV = LASTOP

INPUTBUFFER     := $0200;00A
INPUTBUFFERX    := $0200
.endif

.ifdef CBM1
SPACE_FOR_GOSUB := $36
STACK_TOP		:= $FC
.else
SPACE_FOR_GOSUB := $3E
STACK_TOP		:= $FA
.endif

RAMSTART2		:= $0400


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

; for CBM1
LE7F3	:= $E7F3

MONCOUT	:= CHROUT
MONRDKEY := GETIN


.ifdef CBM1
ENTROPY = $9044
.else
ENTROPY = $E844
.endif

