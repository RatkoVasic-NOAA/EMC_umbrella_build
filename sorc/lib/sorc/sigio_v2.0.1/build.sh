#!/bin/sh
set -eux
#-----------------------------------------------------
cwd=`pwd`
source ../../../machine-setup.sh > /dev/null 2>&1

export LIBNAME=sigio
export VER=v2.0.1
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
#     Build sigio library
#

rm -rf sigio_v2.0.1

./make_sigio_lib.sh ifort.setup


mkdir -p ../../libs/${LIBNAME}_${VER}
cp ${LIBNAME}_${VER}/libsigio_${VER}.a ../../libs/${LIBNAME}_${VER}/libsigio_${VER}_4.a
mkdir -p ../../incmod/${LIBNAME}_${VER}_4
cp ${LIBNAME}_${VER}/incmod/${LIBNAME}_${VER}/sigio_*.mod ../../incmod/${LIBNAME}_${VER}_4

rm -rf ${LIBNAME}_${VER}

#
#     Create modulefile
#
cd ../../
lwd=`pwd`
cd $cwd
mkdir -p $lwd/modulefiles/$LIBNAME
cat modulefile.template | sed s:_CWD_:$lwd:g > $lwd/modulefiles/$LIBNAME/$VER

exit
