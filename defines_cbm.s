.ifdef CBM1
;USR				:= $0000
;Z00             := $0000
INPUTBUFFERX    := $0000
;L0001           := $0001
;L0002           := $0002
;GOWARM          := $0003
Z03				:= $0003 ; same
GOSTROUT        := $0006
GOGIVEAYF       := $0008

;Z15             := $0004
Z16             := $0005
Z17             := $0006
Z18             := $0007
LINNUM          := $0008
TXPSV			:= $0008
INPUTBUFFER     := $000A

;CHARAC          := $005A
;ENDCHR          := $005B
EOLPNTR         := $005C
DIMFLG          := $005D
VALTYP          := $005E
DATAFLG         := $0060
SUBFLG          := $0061
INPUTFLG        := $0062
CPRMASK         := $0063
Z14             := $0064                        ; Ctrl+O flag
TEMPPT          := $0065
LASTPT          := $0066
TEMPST			:= $0068
INDEX           := $0071
DEST            := $0073
RESULT          := $0075
RESULT_LAST     := $0079
TXTTAB          := $007A
VARTAB          := $007C
ARYTAB          := $007E
STREND          := $0080
FRETOP          := $0082
FRESPC          := $0084
MEMSIZ          := $0086
CURLIN          := $0088
OLDLIN          := $008A
OLDTEXT         := $008C
Z8C             := $008E
DATPTR          := $0090
INPTR           := $0092
VARNAM          := $0094
VARPNT          := $0096
FORPNT          := $0098
LASTOP          := $009A
CPRTYP          := $009C
FNCNAM          := $009D
TEMP3           := $009D; ; same
DSCPTR          := $009F
DSCLEN          := $00A2
JMPADRS         := $00A3
Z52				:= $00A4;
LENGTH			:= $00A4
ARGEXTENSION    := $00A5 ; overlap with JMPADRS! (same on c64)
TEMP1           := $00A6
HIGHDS          := $00A7
HIGHTR          := $00A9
TEMP2			:= $00AB
INDX            := $00AC
TMPEXP          := $00AC ; same
EXPON           := $00AD
LOWTR           := $00AE                        ; $9D also EXPSGN
LOWTRX          := $00AE                        ; $9D also EXPSGN
EXPSGN			:= $00AF
FAC             := $00B0
FAC_LAST        := $00B4
FACSIGN         := $00B5
SERLEN          := $00B6
SHIFTSIGNEXT    := $00B7
ARG             := $00B8
ARG_LAST        := $00BC
ARGSIGN         := $00BD
STRNG1          := $00BE                        ; TODO: also SGNCPR
FACEXTENSION	:= $00BF
STRNG2          := $00C0
CHRGET          := $00C2
CHRGOT          := $00C8
TXTPTR          := $00C9
L00CF			:= $00CF
RNDSEED			:= $00DA
Z96				:= $020C
.else
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

TOKEN_GOTO		:= $89
TOKEN_GOSUB		:= $8D
TOKEN_REM		:= $8F
TOKEN_PRINT		:= $99
TOKEN_TAB		:= $A3
TOKEN_TO		:= $A4
TOKEN_FN		:= $A5
TOKEN_SPC		:= $A6
TOKEN_THEN		:= $A7
TOKEN_NOT		:= $A8
TOKEN_STEP		:= $A9
TOKEN_PLUS		:= $AA
TOKEN_MINUS		:= $AB
TOKEN_GREATER	:= $B1
TOKEN_EQUAL		:= $B2
TOKEN_SGN		:= $B4
TOKEN_LEFTSTR	:= $C8



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

