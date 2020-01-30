#!/bin/sh
set -eux
#-----------------------------------------------------
cwd=`pwd`
source ../../../machine-setup.sh > /dev/null 2>&1

export LIBNAME=ip
export VER=v3.0.0
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
#     Biuld ip v3 library
#

rm -rf ./ip ../../incmod/ip_${VER}_* ../../libs/${LIBNAME}_${VER}/libip_${VER}_*.a

mkdir -p ../../incmod/ip_${VER}_4 ../../incmod/ip_${VER}_8 ../../incmod/ip_${VER}_d
mkdir -p ../../libs/${LIBNAME}_${VER}

if [ $target = wcoss_cray ]; then
  ./make_ip_lib_wcoss-cray.sh ifort.setup
  cp ip/${VER}/intel/libip_${VER}_*.a ../../libs/${LIBNAME}_${VER}/.
  cp ip/${VER}/intel/include/ip_${VER}_4/* ../../incmod/ip_${VER}_4/.
  cp ip/${VER}/intel/include/ip_${VER}_8/* ../../incmod/ip_${VER}_8/.
  cp ip/${VER}/intel/include/ip_${VER}_d/* ../../incmod/ip_${VER}_d/.
else
  ./make_ip_lib.sh ifort.setup
  cp ip/${VER}/libip_${VER}_*.a ../../libs/${LIBNAME}_${VER}/.
  cp ip/${VER}/include/ip_${VER}_4/* ../../incmod/ip_${VER}_4/.
  cp ip/${VER}/include/ip_${VER}_8/* ../../incmod/ip_${VER}_8/.
  cp ip/${VER}/include/ip_${VER}_d/* ../../incmod/ip_${VER}_d/.
fi

rm -rf ip

#
#     Create modulefile
#
cd ../../
lwd=`pwd`
cd $cwd
mkdir -p $lwd/modulefiles/$LIBNAME
cat modulefile.template | sed s:_CWD_:$lwd:g > $lwd/modulefiles/$LIBNAME/$VER

exit
