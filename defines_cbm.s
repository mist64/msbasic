; configuration
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

.ifdef CBM1
; zero page
ZP_START0 = $00
ZP_START0A = $04
ZP_START1 = $5A
ZP_START2 = $65

JMPADRS = DSCLEN + 1
LOWTRX = LOWTR

USR				:= $0000

;GORESTART       := $0000

;Z15             := $0004
;POSX            := $0005
;LINNUM          := $0008
;INPUTBUFFER     := $000A

TXPSV			:= $0008
INPUTBUFFERX    := $0000

Z03				:= $0003
Z96				:= $020C

NULL_MAX		:= $0A
.else

; zero page
ZP_START0 = $00
ZP_START0A = $0E
ZP_START1 = $03
ZP_START2 = $13

JMPADRS = DSCLEN + 1
LOWTRX = LOWTR

USR				:= GORESTART ; XXX

;LINNUM          := $0011

Z03				:= $000E
Z96				:= $0096

; override
POSX			:= $00C6

TXPSV = LASTOP

CONFIG_NO_INPUTBUFFER_ZP := 1
CONFIG_INPUTBUFFER_0200 := 1

INPUTBUFFER     := $0200
INPUTBUFFERX    := $0200
.endif

; constants
.ifdef CBM1
SPACE_FOR_GOSUB := $36
STACK_TOP		:= $FC
.else
SPACE_FOR_GOSUB := $3E
STACK_TOP		:= $FA
.endif
CRLF_1 := CR
CRLF_2 := LF

RAMSTART2		:= $0400


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


.ifdef CBM1
ENTROPY = $9044
.else
ENTROPY = $E844
.endif

