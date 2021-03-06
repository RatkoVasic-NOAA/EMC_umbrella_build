	INTEGER FUNCTION IGETPRM ( CPRMNM )

C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C
C SUBPROGRAM:    IGETPRM
C   PRGMMR: ATOR             ORG: NP12       DATE: 2014-12-04
C
C ABSTRACT:  THIS FUNCTION RETURNS THE VALUE ASSOCIATED WITH A
C   SPECIFIED PARAMETER.
C
C PROGRAM HISTORY LOG:
C 2014-12-04  J. ATOR    -- ORIGINAL AUTHOR
C
C USAGE:    IGETPRM ( CPRMNM )
C   INPUT ARGUMENT LIST:
C     CPRMNM   - CHARACTER*(*): PARAMETER 
C                  'MXMSGL' = MAXIMUM LENGTH (IN BYTES) OF A BUFR
C                             MESSAGE
C                  'MAXSS'  = MAXIMUM NUMBER OF DATA VALUES IN AN
C                             UNCOMPRESSED BUFR SUBSET
C                  'MXCDV'  = MAXIMUM NUMBER OF DATA VALUES THAT CAN BE
C                             WRITTEN INTO A COMPRESSED BUFR SUBSET
C                  'MXLCC'  = MAXIMUM LENGTH (IN BYTES) OF A CHARACTER
C                             STRING THAT CAN BE WRITTEN INTO A
C                             COMPRESSED BUFR SUBSET
C                  'MXCSB'  = MAXIMUM NUMBER OF SUBSETS THAT CAN BE
C                             WRITTEN INTO A COMPRESSED BUFR MESSAGE
C                  'NFILES' = MAXIMUM NUMBER OF BUFR FILES THAT CAN BE
C                             ACCESSED FOR READING OR WRITING AT ANY
C                             ONE TIME
C                  'MAXTBA' = MAXIMUM NUMBER OF ENTRIES IN INTERNAL BUFR
C                             TABLE A PER BUFR FILE
C                  'MAXTBB' = MAXIMUM NUMBER OF ENTRIES IN INTERNAL BUFR
C                             TABLE B PER BUFR FILE
C                  'MAXTBD' = MAXIMUM NUMBER OF ENTRIES IN INTERNAL BUFR
C                             TABLE D PER BUFR FILE
C                  'MAXMEM' = MAXIMUM NUMBER OF BYTES THAT CAN BE USED
C                             TO STORE BUFR MESSAGES IN INTERNAL MEMORY
C                  'MAXMSG' = MAXIMUM NUMBER OF BUFR MESSAGES THAT CAN
C                             BE STORED IN INTERNAL MEMORY
C                  'MXDXTS' = MAXIMUM NUMBER OF DICTIONARY TABLES THAT
C                             CAN BE STORED FOR USE WITH BUFR MESSAGES
C                             IN INTERNAL MEMORY
C                  'MXMTBB' = MAXIMUM NUMBER OF MASTER TABLE B ENTRIES
C                  'MXMTBD' = MAXIMUM NUMBER OF MASTER TABLE D ENTRIES
C                  'MAXCD'  = MAXIMUM NUMBER OF CHILD DESCRIPTORS IN A
C                             TABLE D DESCRIPTOR SEQUENCE DEFINITION
C                  'MAXJL'  = MAXIMUM NUMBER OF ENTRIES IN THE INTERNAL
C                             JUMP/LINK TABLE
C                  'MXS01V' = MAXIMUM NUMBER OF DEFAULT SECTION 0 OR
C                             SECTION 1 VALUES THAT CAN BE OVERWRITTEN
C                             WITHIN AN OUTPUT BUFR MESSAGE
C
C   OUTPUT ARGUMENT LIST:
C     IGETPRM  - INTEGER: VALUE ASSOCIATED WITH CPRMNM
C                  -1 = UNKNOWN CPRNMN
C
C REMARKS:
C    THIS ROUTINE CALLS:        ERRWRT
C    THIS ROUTINE IS CALLED BY: ARALLOCC STSEQ
C                               Also called by application programs.
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN
C   MACHINE:  PORTABLE TO ALL PLATFORMS
C
C$$$

	USE MODV_MAXSS
	USE MODV_NFILES
	USE MODV_MXMSGL
	USE MODV_MXDXTS
	USE MODV_MAXMSG
	USE MODV_MAXMEM
	USE MODV_MAXTBA
	USE MODV_MAXTBB
	USE MODV_MAXTBD
	USE MODV_MAXJL
	USE MODV_MXCDV
	USE MODV_MXLCC
	USE MODV_MXCSB
	USE MODV_MXMTBB
	USE MODV_MXMTBD
	USE MODV_MAXCD
	USE MODV_MXS01V

	INCLUDE	'bufrlib.prm'

	CHARACTER*(*)	CPRMNM
	CHARACTER*64	ERRSTR

C-----------------------------------------------------------------------
C-----------------------------------------------------------------------

	IF ( CPRMNM .EQ. 'MAXSS' ) THEN
	    IGETPRM = MAXSS
	ELSE IF ( CPRMNM .EQ. 'NFILES' ) THEN
	    IGETPRM = NFILES
	ELSE IF ( CPRMNM .EQ. 'MXMSGL' ) THEN
	    IGETPRM = MXMSGL
	ELSE IF ( CPRMNM .EQ. 'MXDXTS' ) THEN
	    IGETPRM = MXDXTS
	ELSE IF ( CPRMNM .EQ. 'MAXMSG' ) THEN
	    IGETPRM = MAXMSG
	ELSE IF ( CPRMNM .EQ. 'MAXMEM' ) THEN
	    IGETPRM = MAXMEM
	ELSE IF ( CPRMNM .EQ. 'MAXTBA' ) THEN
	    IGETPRM = MAXTBA
	ELSE IF ( CPRMNM .EQ. 'MAXTBB' ) THEN
	    IGETPRM = MAXTBB
	ELSE IF ( CPRMNM .EQ. 'MAXTBD' ) THEN
	    IGETPRM = MAXTBD
	ELSE IF ( CPRMNM .EQ. 'MAXJL' ) THEN
	    IGETPRM = MAXJL
	ELSE IF ( CPRMNM .EQ. 'MXCDV' ) THEN
	    IGETPRM = MXCDV
	ELSE IF ( CPRMNM .EQ. 'MXLCC' ) THEN
	    IGETPRM = MXLCC
	ELSE IF ( CPRMNM .EQ. 'MXCSB' ) THEN
	    IGETPRM = MXCSB
	ELSE IF ( CPRMNM .EQ. 'MXMTBB' ) THEN
	    IGETPRM = MXMTBB
	ELSE IF ( CPRMNM .EQ. 'MXMTBD' ) THEN
	    IGETPRM = MXMTBD
	ELSE IF ( CPRMNM .EQ. 'MAXCD' ) THEN
	    IGETPRM = MAXCD
	ELSE IF ( CPRMNM .EQ. 'MXS01V' ) THEN
	    IGETPRM = MXS01V
	ELSE
	    IGETPRM = -1
	    CALL ERRWRT('++++++++++++++++++WARNING+++++++++++++++++++')
	    ERRSTR = 'BUFRLIB: IGETPRM - UNKNOWN INPUT PARAMETER '//
     .		CPRMNM
	    CALL ERRWRT(ERRSTR)
	    CALL ERRWRT('++++++++++++++++++WARNING+++++++++++++++++++')
	ENDIF

	RETURN
	END
