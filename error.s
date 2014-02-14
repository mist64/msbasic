init_error_table

.ifdef CONFIG_SMALL_ERROR
define_error ERR_NOFOR, "NF"
define_error ERR_SYNTAX, "SN"
define_error ERR_NOGOSUB, "RG"
define_error ERR_NODATA, "OD"
define_error ERR_ILLQTY, "FC"
define_error ERR_OVERFLOW, "OV"
define_error ERR_MEMFULL, "OM"
define_error ERR_UNDEFSTAT, "US"
define_error ERR_BADSUBS, "BS"
define_error ERR_REDIMD, "DD"
define_error ERR_ZERODIV, "/0"
define_error ERR_ILLDIR, "ID"
define_error ERR_BADTYPE, "TM"
define_error ERR_STRLONG, "LS"
define_error ERR_FRMCPX, "ST"
define_error ERR_CANTCONT, "CN"
define_error ERR_UNDEFFN, "UF"
.else
define_error ERR_NOFOR, "NEXT WITHOUT FOR"
define_error ERR_SYNTAX, "SYNTAX"
define_error ERR_NOGOSUB, "RETURN WITHOUT GOSUB"
define_error ERR_NODATA, "OUT OF DATA"
define_error ERR_ILLQTY, "ILLEGAL QUANTITY"
.ifdef CBM1
	.byte 0,0,0,0,0
.endif
define_error ERR_OVERFLOW, "OVERFLOW"
define_error ERR_MEMFULL, "OUT OF MEMORY"
define_error ERR_UNDEFSTAT, "UNDEF'D STATEMENT"
define_error ERR_BADSUBS, "BAD SUBSCRIPT"
define_error ERR_REDIMD, "REDIM'D ARRAY"
define_error ERR_ZERODIV, "DIVISION BY ZERO"
define_error ERR_ILLDIR, "ILLEGAL DIRECT"
define_error ERR_BADTYPE, "TYPE MISMATCH"
define_error ERR_STRLONG, "STRING TOO LONG"
.ifdef CONFIG_FILE
  .ifdef CBM1
define_error ERR_BADDATA, "BAD DATA"
  .else
define_error ERR_BADDATA, "FILE DATA"
  .endif
.endif
define_error ERR_FRMCPX, "FORMULA TOO COMPLEX"
define_error ERR_CANTCONT, "CAN'T CONTINUE"
define_error ERR_UNDEFFN, "UNDEF'D FUNCTION"
.endif