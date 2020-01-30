#!/bin/sh
set -eux
#-----------------------------------------------------
cwd=`pwd`
source ../../../machine-setup.sh > /dev/null 2>&1

export LIBNAME=sfcio
export VER=v1.0.0
export FCMP=ifort

if [ $target = wcoss_cray ]; then
  export FCMP=ftn
  module load PrgEnv-intel
  module load craype-sandybridge
elif [ $target = "wcoss" ]; then
  module load ics/12.1
elif [ $target = "theia" ]; then
  module load intel/15.1.133
elif [ $target = "gaea" ]; then
  :
elif [ $target = "jet" ]; then
  module load intel/12.1.4
fi

#
#     Build sfcio library
#

export FCS=$FCMP
make -f makefile_4

mkdir -p ../../libs/${LIBNAME}_${VER}
cp libsfcio_${VER}_4.a ../../libs/${LIBNAME}_${VER}/.
mkdir -p ../../incmod/${LIBNAME}_${VER}_4
cp sfcio_module.mod ../../incmod/${LIBNAME}_${VER}_4

rm -f libsfcio_${VER}_4.a sfcio_module.mod

#
#     Create modulefile
#
cd ../../
lwd=`pwd`
cd $cwd
mkdir -p $lwd/modulefiles/$LIBNAME
cat modulefile.template | sed s:_CWD_:$lwd:g > $lwd/modulefiles/$LIBNAME/$VER

exit
