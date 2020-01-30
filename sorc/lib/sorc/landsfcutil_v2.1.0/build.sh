#!/bin/sh
set -eux
#-----------------------------------------------------
cwd=`pwd`
source ../../../machine-setup.sh > /dev/null 2>&1

export LIBNAME=landsfcutil
export VER=v2.1.0
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
#     Build landsfcutil library
#

mkdir -p ../../incmod/landsfcutil_${VER}_4
mkdir -p ../../incmod/landsfcutil_${VER}_d
mkdir -p ../../libs/${LIBNAME}_${VER}

if [ $target = wcoss_cray ]; then
  ./make_landsfcutil_lib_wcoss-cray.sh ifort.setup
  cp landsfcutil/$VER/intel/*.a ../../libs/${LIBNAME}_${VER}/.
  cp landsfcutil/$VER/intel/include/landsfcutil_${VER}_4/*.mod ../../incmod/landsfcutil_${VER}_4
  cp landsfcutil/$VER/intel/include/landsfcutil_${VER}_d/*.mod ../../incmod/landsfcutil_${VER}_d
else
  ./make_landsfcutil_lib.sh ifort.setup
  cp landsfcutil/$VER/*.a ../../libs/${LIBNAME}_${VER}/.
  cp landsfcutil/$VER/include/landsfcutil_${VER}_4/*.mod ../../incmod/landsfcutil_${VER}_4
  cp landsfcutil/$VER/include/landsfcutil_${VER}_d/*.mod ../../incmod/landsfcutil_${VER}_d
fi

rm -rf landsfcutil

#
#     Create modulefile
#
cd ../../
lwd=`pwd`
cd $cwd
mkdir -p $lwd/modulefiles/$LIBNAME
cat modulefile.template | sed s:_CWD_:$lwd:g > $lwd/modulefiles/$LIBNAME/$VER

exit
