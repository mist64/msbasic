.feature org_per_seg

.zeropage

.ifdef ZP_START0
.org ZP_START0
.endif

.ifdef ZP_START0
GORESTART:
	.res 3
  .ifndef CONFIG_NO_EXTRA_GO_PTRS
GOSTROUT:
	.res 3
GOAYINT:
	.res 2
GOGIVEAYF:
	.res 2
  .endif
.endif

.ifdef ZP_START1
.org ZP_START1
.endif

CHARAC:
	.res 1
ENDCHR:
	.res 1
EOLPNTR:
	.res 1
DIMFLG:
	.res 1
VALTYP:
.ifdef CONFIG_SMALL
	.res 1
.else
	.res 2
.endif
DATAFLG:
	.res 1
SUBFLG:
	.res 1
INPUTFLG:
	.res 1
CPRMASK:
	.res 1
Z14:
	.res 1

.ifdef ZP_HOLE2
.res ZP_HOLE2
.endif

TEMPPT:
	.res 1
LASTPT:
	.res 2
TEMPST:
	.res 9
INDEX:
	.res 2
DEST:
	.res 2
RESULT:
	.res BYTES_FP
RESULT_LAST = RESULT + BYTES_FP-1
TXTTAB:
	.res 2
VARTAB:
	.res 2
ARYTAB:
	.res 2
STREND:
	.res 2
FRETOP:
	.res 2
FRESPC:
	.res 2
MEMSIZ:
	.res 2
CURLIN:
	.res 2
OLDLIN:
	.res 2
OLDTEXT:
	.res 2
Z8C:
	.res 2
DATPTR:
	.res 2
INPTR:
	.res 2
VARNAM:
	.res 2
VARPNT:
	.res 2
FORPNT:
	.res 2
LASTOP:
	.res 2
CPRTYP:
	.res 1
FNCNAM:
TEMP3:
	.res 2
DSCPTR:
.ifdef CONFIG_SMALL
		.res 2
.else
		.res 3
.endif
DSCLEN:
	.res 2
Z52:
	.res 1
ARGEXTENSION:
.ifndef CONFIG_SMALL
	.res 1
.endif
TEMP1:
	.res 1
HIGHDS:
	.res 2
HIGHTR:
	.res 2
.ifndef CONFIG_SMALL
TEMP2:
	.res 1
.endif
INDX:
TMPEXP:
.ifdef CONFIG_SMALL
TEMP2:
.endif
	.res 1
EXPON:
	.res 1
LOWTR:
	.res 1
EXPSGN:
	.res 1
FAC:
	.res BYTES_FP
FAC_LAST = FAC + BYTES_FP-1
FACSIGN:
	.res 1
SERLEN:
	.res 1
SHIFTSIGNEXT:
	.res 1
ARG:
	.res BYTES_FP
ARG_LAST = ARG + BYTES_FP-1
ARGSIGN:
	.res 1
STRNG1:
	.res 2
SGNCPR = STRNG1
FACEXTENSION = STRNG1+1
STRNG2:
	.res 2
CHRGET:
TXTPTR = <(GENERIC_TXTPTR-GENERIC_CHRGET + CHRGET)
CHRGOT = <(GENERIC_CHRGOT-GENERIC_CHRGET + CHRGET)
CHRGOT2 = <(GENERIC_CHRGOT2-GENERIC_CHRGET + CHRGET)
RNDSEED = <(GENERIC_RNDSEED-GENERIC_CHRGET + CHRGET)


