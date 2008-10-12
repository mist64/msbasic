Z00             := $0000
L0001           := $0001
L0002           := $0002
GOWARM          := $0003
GOSTROUT        := $0006
GOGIVEAYF       := $0008

CHARAC          := $000A
ENDCHR          := $000B
EOLPNTR         := $000C
DIMFLG          := $000D
VALTYP          := $000E
DATAFLG         := $0010
SUBFLG          := $0011
INPUTFLG        := $0012
CPRMASK         := $0013
Z14             := $0014                        ; Ctrl+O flag
Z15             := $0015
Z16             := $0016
Z17             := $0017
Z18             := $0018
LINNUM          := $0019
TXPSV           := $0019
INPUTBUFFER     := $001B
INPUTBUFFERX    := $0000

L1800           := $1800
L1873           := $1873
MONRDKEY        := $1E5A
MONCOUT         := $1EA0

STACK_TOP		:= $FC
BYTES_PER_FRAME := $12
SPACE_FOR_GOSUB := $36
FOR_STACK1		:= $0F
FOR_STACK2		:= $09
NUM_TOKENS		:= $1D
NULL_MAX		:= $F2 ; probably different in original version; the image I have seems to be modified; see PDF
BYTES_PER_ELEMENT := 5
BYTES_PER_VARIABLE := 7
BYTES_FP		:= 5
MANTISSA_BYTES	:= BYTES_FP-1
MAX_EXPON = 10

