#!/bin/sh
set -eux
#-----------------------------------------------------
cwd=`pwd`
source ../../../machine-setup.sh > /dev/null 2>&1

export LIBNAME=ip
export VER=v2.0.0
export FCMP=ifort

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

#
#     Generate a list of object files that corresponds to the
#     list of Fortran ( .f90 ) files in the current directory
#
OBJS=""
for i in *.f
do
  obj=$(basename $i .f)
  OBJS="$OBJS ${obj}.o"
done
#
#     Remove make file, if it exists.  May need a new make file
#     with an updated object file list.
#
if [ -f make.libip ] 
then
  rm -f make.libip
fi
#
#     Generate a new make file ( make.libip), with the updated object list,
#     from this HERE file.
#
cat > make.libip << EOF
SHELL=/bin/sh

.SUFFIXES:
.SUFFIXES: .f90 .f .a

\$(LIB):	\$(LIB)( ${OBJS} )

.f90.a:
	\$(FCMP) -c \$(FFLAGS) \$<
	ar -ruv \$(AFLAGS) \$@ \$*.o
	rm -f \$*.o

.f.a:
	\$(FCMP) -c \$(FFLAGS) \$<
	ar -ruv \$(AFLAGS) \$@ \$*.o
	rm -f \$*.o

EOF
#
#     Read information about compiler and options
#
. ./makefile.conf

mkdir -p ../../libs/${LIBNAME}_${VER}

#
#     Update 4-byte version of libip_4.a
#
export LIB="../../libs/${LIBNAME}_${VER}/libip_${VER}_4.a"
export FCMP
export AFLAGS
export FFLAGS=$FFLAGS_4
make -f make.libip
#
#     Update 8-byte version of libip_8.a
#
export LIB="../../libs/${LIBNAME}_${VER}/libip_${VER}_8.a"
export FCMP
export AFLAGS
export FFLAGS=$FFLAGS_8
make -f make.libip
#
#     Update Double Precision (Size of Real 8-byte and default Integer) version
#     of libip_d.a
#
export LIB="../../libs/${LIBNAME}_${VER}/libip_${VER}_d.a"
export FCMP
export AFLAGS
export FFLAGS=$FFLAGS_D
make -f make.libip

rm -f make.libip

#
#     Create modulefile
#
cd ../../
lwd=`pwd`
cd $cwd
mkdir -p $lwd/modulefiles/$LIBNAME
cat modulefile.template | sed s:_CWD_:$lwd:g > $lwd/modulefiles/$LIBNAME/$VER

exit
