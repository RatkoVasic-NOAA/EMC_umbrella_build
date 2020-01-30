#!/bin/sh
set -eux
#-----------------------------------------------------
cwd=`pwd`
source ../../../machine-setup.sh > /dev/null 2>&1

export LIBNAME=bufr
export VER=v11.0.1
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

#
#     Compile BUFR library
#
export COMP=intel
rm -f ../../libs/${LIBNAME}_${VER}/libbufr_${VER}_*.a
cp makebufrlib.sh_$target makebufrlib.sh
./makebufrlib.sh
mkdir -p ../../libs/${LIBNAME}_${VER}
mv ../../intel/*.a ../../libs/${LIBNAME}_${VER}/.
rm -rf ../../intel makebufrlib.sh

#
#     Create modulefile
#
cd ../../
lwd=`pwd`
cd $cwd
mkdir -p $lwd/modulefiles/$LIBNAME
cat modulefile.template | sed s:_CWD_:$lwd:g > $lwd/modulefiles/$LIBNAME/$VER

exit
