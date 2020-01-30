#!/bin/sh
set -eux
#-----------------------------------------------------
cwd=`pwd`
source ../../../machine-setup.sh > /dev/null 2>&1

export LIBNAME=sp
export VER=v2.0.2
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
#     Build sp library
#

./makelibsp.sh_Linux

mkdir -p ../../libs/${LIBNAME}_${VER}
mv ../../libsp_v2.0.2_4.a ../../libs/${LIBNAME}_${VER}/.
mv ../../libsp_v2.0.2_8.a ../../libs/${LIBNAME}_${VER}/.
mv ../../libsp_v2.0.2_d.a ../../libs/${LIBNAME}_${VER}/.

#
#     Create modulefile
#
cd ../../
lwd=`pwd`
cd $cwd
mkdir -p $lwd/modulefiles/$LIBNAME
cat modulefile.template | sed s:_CWD_:$lwd:g > $lwd/modulefiles/$LIBNAME/$VER

exit
