#!/bin/sh
set -eux
#-----------------------------------------------------
cwd=`pwd`
source ../../../machine-setup.sh > /dev/null 2>&1

export LIBNAME=bacio
export VER=v2.0.2
export FCMP=ifort
export CCMP=icc

if [ $target = wcoss_cray ]; then
  export FCMP=ftn
  module load PrgEnv-intel
  module load craype-sandybridge
elif [ $target = "wcoss" ]; then
  module load ics/12.1
elif [ $target = "theia" ]; then
  module load intel/14.0.2
elif [ $target = "gaea" ]; then
  :
elif [ $target = "jet" ]; then
  module load intel/12.1.4
fi

if [ -f make.bacio ] ;  then
  rm -f make.bacio
fi
#
#     Generate a make file ( make.bacio) from this HERE file.
#
cat > make.bacio << EOF
SHELL=/bin/sh

\$(LIB):	\$(LIB)( bacio.o baciof.o bafrio.o byteswap.o chk_endianc.o)

\$(LIB)(bacio.o):       bacio.c clib.h
	\${CCMP} -c \$(CFLAGS) bacio.c
	ar -rv \$(AFLAGS) \$(LIB) bacio.o

\$(LIB)(baciof.o):   baciof.f
	\${FCMP} -c \$(FFLAGS) baciof.f
	ar -rv \$(AFLAGS) \$(LIB) baciof.o 

\$(LIB)(bafrio.o):   bafrio.f
	\${FCMP} -c \$(FFLAGS) bafrio.f
	ar -rv \$(AFLAGS) \$(LIB) bafrio.o 

\$(LIB)(byteswap.o):       byteswap.c 
	\${CCMP} -c \$(CFLAGS) byteswap.c
	ar -rv \$(AFLAGS) \$(LIB) byteswap.o

\$(LIB)(chk_endianc.o):       chk_endianc.f 
	\${FCMP} -c \$(FFLAGS) chk_endianc.f
	ar -rv \$(AFLAGS) \$(LIB) chk_endianc.o
	rm -f baciof.o bafrio.o bacio.o *.mod byteswap.o chk_endianc.o

EOF

mkdir -p ../../libs/${LIBNAME}_${VER}

#
#     Update 4-byte version of libbacio_4.a
#
export LIB="../../libs/${LIBNAME}_${VER}/libbacio_${VER}_4.a"

export FFLAGS=" -O3 -xHOST -traceback"
export AFLAGS=" "
export CFLAGS=" -O3 -DUNDERSCORE -DLINUX"
make -f make.bacio
#
#     Update 8-byte version of libbacio_8.a
#
export LIB="../../libs/${LIBNAME}_${VER}/libbacio_${VER}_8.a"

export FFLAGS=" -O3 -i8 -r8 -xHOST -traceback"
export AFLAGS=" "
export CFLAGS=" -O3 -DUNDERSCORE -DLINUX"
make -f make.bacio

 rm -f make.bacio

#
#     Create modulefile
#
cd ../../
lwd=`pwd`
cd $cwd
mkdir -p $lwd/modulefiles/$LIBNAME
cat modulefile.template | sed s:_CWD_:$lwd:g > $lwd/modulefiles/$LIBNAME/$VER

exit
