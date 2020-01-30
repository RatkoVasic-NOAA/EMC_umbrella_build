#!/bin/sh
set -eux
#-----------------------------------------------------
cwd=`pwd`
source ../../../machine-setup.sh > /dev/null 2>&1

export LIBNAME=g2tmpl
export VER=v1.3.0
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
#     Build g2tmpl library
#

rm -rf   ../../incmod/${LIBNAME}_${VER} ../../libs/${LIBNAME}_${VER}/libg2tmpl_${VER}.a
mkdir -p ../../incmod/${LIBNAME}_${VER} ../../libs/${LIBNAME}_${VER}
make -f Makefile
mv ../../libg2tmpl_${VER}.a ../../libs/${LIBNAME}_${VER}/libg2tmpl_${VER}.a

#
#     Create modulefile
#
cd ../../
lwd=`pwd`
cd $cwd
mkdir -p $lwd/modulefiles/$LIBNAME
cat modulefile.template | sed s:_CWD_:$lwd:g > $lwd/modulefiles/$LIBNAME/$VER

exit
