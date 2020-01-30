#!/bin/sh
set -eux
#-----------------------------------------------------
cwd=`pwd`
source ../../../machine-setup.sh > /dev/null 2>&1
module use ../../modulefiles
module load sigio/v2.0.1

export LIBNAME=w3emc
export VER=v2.2.0
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
#     Build w3emc library
#

rm -rf ../../libs/${LIBNAME}_${VER}/libw3emc_${VER}* ../../incmod/w3emc_${VER}*
./make_w3emc_lib.sh ifort.setup

mkdir -p ../../libs/${LIBNAME}_${VER}
cp w3emc/${VER}/libw3emc_${VER}_*.a ../../libs/${LIBNAME}_${VER}/.
mkdir -p ../../incmod/w3emc_${VER}_4/.
mkdir -p ../../incmod/w3emc_${VER}_8/.
mkdir -p ../../incmod/w3emc_${VER}_d/.
cp w3emc/${VER}/incmod/w3emc_${VER}_4/*.mod ../../incmod/w3emc_${VER}_4/.
cp w3emc/${VER}/incmod/w3emc_${VER}_8/*.mod ../../incmod/w3emc_${VER}_8/.
cp w3emc/${VER}/incmod/w3emc_${VER}_d/*.mod ../../incmod/w3emc_${VER}_d/.
rm -rf w3emc

#
#     Create modulefile
#
cd ../../
lwd=`pwd`
cd $cwd
mkdir -p $lwd/modulefiles/$LIBNAME
cat modulefile.template | sed s:_CWD_:$lwd:g > $lwd/modulefiles/$LIBNAME/$VER

exit
