.ifdef CBM1
USR				:= $0000
Z00             := $0000
INPUTBUFFERX    := $0000
L0001           := $0001
L0002           := $0002
GOWARM          := $0003
Z03				:= $0003 ; same
GOSTROUT        := $0006
GOGIVEAYF       := $0008

Z15             := $0004
Z16             := $0005
Z17             := $0006
Z18             := $0007
LINNUM          := $0008
TXPSV			:= $0008
INPUTBUFFER     := $000A

CHARAC          := $005A
ENDCHR          := $005B
EOLPNTR         := $005C
DIMFLG          := $005D
VALTYP          := $005E
DATAFLG         := $0060
SUBFLG          := $0061
INPUTFLG        := $0062
CPRMASK         := $0063
Z14             := $0064                        ; Ctrl+O flag
Z96				:= $020C
.else
USR				:= $0000
Z00             := $0000
L0001           := $0001
L0002           := $0002
GOWARM          := $0003
Z15             := $0004
CHARAC          := $005A-82-5
ENDCHR          := $005B-82-5
EOLPNTR         := $005C-82-5
DIMFLG          := $005D-82-5
VALTYP          := $005E-82-5
DATAFLG         := $0060-82-5
SUBFLG          := $0061-82-5
INPUTFLG        := $0062-82-5
CPRMASK         := $0063-82-5
Z14             := $0064-82-5                        ; Ctrl+O flag

Z17             := $0006
GOSTROUT        := $0006
Z18             := $0007
GOGIVEAYF       := $0008
Z03				:= $000E;3 ; same
LINNUM          := $0011;0008
Z96 := $00E8-82
Z16 := $0118-82
TXPSV = LASTOP

INPUTBUFFER     := $0200;00A
INPUTBUFFERX    := $0200
.endif

BYTES_PER_FRAME := $12
.ifdef CBM1
SPACE_FOR_GOSUB := $36
STACK_TOP		:= $FC
.else
SPACE_FOR_GOSUB := $3E
STACK_TOP		:= $FA
.endif
FOR_STACK1		:= $0F
FOR_STACK2		:= $09
NUM_TOKENS		:= $23
NULL_MAX		:= $0A
BYTES_PER_ELEMENT := 5
BYTES_PER_VARIABLE := 7
BYTES_FP		:= 5
MANTISSA_BYTES	:= BYTES_FP-1
.ifdef CBM1
MAX_EXPON = 12
.else
MAX_EXPON = 10
.endif

RAMSTART2		:= $0400
RAMSTART3		:= $0400


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

LE7F3	:= $E7F3

MONCOUT	:= CHROUT
MONRDKEY := GETIN


.ifdef CBM1
ENTROPY = $9044
.else
ENTROPY = $E844
.endif

