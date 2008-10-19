; Microsoft BASIC for 6502
;
; This is a single integrated assembly source tree that can generate any of seven different
; versions of Microsoft BASIC for 6502.
;
; By running ./make.sh, this will generate all versions and compare them to the original
; files byte by byte.
;
; The CC65 compiler suite is need to build this project.
;
; These are the first eight (knows) versions of Microsoft BASIC for 6502:
;
; Name                 Release   MS Version    ROM   9digit  INPUTBUFFER   extensions   comment
;---------------------------------------------------------------------------------------------------
; Commodore BASIC 1     1977                    Y      Y          ZP          CBM
; OSI BASIC             1977     1.0 REV 3.2    Y      N          ZP            -        CONFIG_10A
; AppleSoft I           1977     1.1            N      Y        $0200         Apple      CONFIG_11
; KIM BASIC             1977     1.1            N      Y          ZP            -        CONFIG_11A
; AppleSoft II          1978                    Y      Y        $0200         Apple      CONFIG_2
; Commodore BASIC 2     1979                    Y      Y        $0200          CBM       CONFIG_2A
; KBD BASIC             1980                    Y      N        $0700          KBD       CONFIG_2B
; MicroTAN              1980                    Y      Y          ZP            -        CONFIG_2C
;
; (Note that this assembly source cannot (yet) build AppleSoft II.)
;
; This lists the versions in the order in which they were forked from the Microsoft source base.
; Commodore BASIC 1, as used on the original PET is the oldest known version of Microsoft BASIC
; for 6502. It contains some additions to Microsoft's version, like Commodore-style file I/O.
;
; The CONFIG_n defines specify what Microsoft-version the OEM version is based on.  

; CONFIG_CBM1_PATCHES				jump out into CBM1's binary patches instead of doing the right thing inline
; CONFIG_CBM_ALL					add all Commodore-specific additions except file I/O
; CONFIG_DATAFLG					?
; CONFIG_EASTER_EGG					include the CBM2 "MICROSOFT!" easter egg
; CONFIG_FILE						support Commodore PRINT#, INPUT#, GET#, CMD
; CONFIG_IO_MSB						all I/O has bit #7 set
; CONFIG_MONCOUT_DESTROYS_Y			Y needs to be preserved when calling MONCOUT 	
; CONFIG_NO_CR						terminal doesn't need explicit CRs on line ends
; CONFIG_NO_LINE_EDITING			disable support for Microsoft-style "@", "_", BEL etc.
; CONFIG_NO_POKE					don't support PEEK, POKE and WAIT
; CONFIG_NO_READ_Y_IS_ZERO_HACK		don't do a ver volatile trick that saves one byte
; CONFIG_NULL						support for the NULL statement
; CONFIG_PEEK_SAVE_LINNUM			preserve LINNUM on a PEEK
; CONFIG_PRINTNULLS					whether PRINTNULLS does anything
; CONFIG_PRINT_CR					print CR when line end reached
; CONFIG_RAM						optimizations for RAM version of BASIC, only use on 1.x
; CONFIG_ROR_WORKAROUND				use workaround for buggy 6502s from 1975/1976; doesn't work with CONFIG_SMALL!
; CONFIG_SAFE_NAMENOTFOUND			check both bytes of the caller's address in NAMENOTFOUND
; CONFIG_SCRTCH_ORDER				where in the init code to call SCRTCH
; CONFIG_SMALL						use 6 digit FP instead of 9 digit, use 2 character error messages, don't have GET

.debuginfo +

.setcpu "6502"
.macpack longbranch

.include "defines.s"
.include "macros.s"
.include "zeropage.s"

.include "header.s"
.include "token.s"
.include "error.s"
.include "message.s"
.include "memory.s"
.include "program.s"
.include "flow1.s"
.include "loadsave.s"
.include "flow2.s"
.include "misc1.s"
.include "print.s"
.include "input.s"
.include "eval.s"
.include "var.s"
.include "array.s"
.include "misc2.s"
.include "string.s"
.include "misc3.s"
.include "poke.s"
.include "float.s"
.include "chrget.s"
.include "rnd.s"
.include "trig.s"
.include "init.s"
.include "extra.s"
