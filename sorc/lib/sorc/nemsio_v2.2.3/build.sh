#!/bin/sh
set -eux
#-----------------------------------------------------
cwd=`pwd`
source ../../../machine-setup.sh > /dev/null 2>&1

export LIBNAME=nemsio
export VER=v2.2.3

if [ $target = wcoss_cray ]; then
  export FCOMP=ftn
  module load PrgEnv-intel
  module load craype-sandybridge
elif [ $target = "wcoss" ]; then
  export FCOMP=mpiifort
  module load ics/12.1
elif [ $target = "theia" ]; then
  export FCOMP=mpiifort
  module load intel/15.1.133 impi/5.0.3.048
elif [ $target = "gaea" ]; then
  export FCOMP=ftn
elif [ $target = "jet" ]; then
  export FCOMP=mpiifort
  module load intel/12.1.4
  module load impi/5.1.1.109
fi

#
#     Build NMESIO library
#
export LIBDIR='.'
export INC='incmod'
export FFLAGS='-O -g'
export AR='ar'
export ARFLAGS='-rvu'
export RM='rm'

make clean
make

mkdir -p ../../libs/${LIBNAME}_${VER}
cp libnemsio_v2.2.3.a ../../libs/${LIBNAME}_${VER}/.
mkdir -p ../../incmod/${LIBNAME}_${VER}
cp incmod/${LIBNAME}_${VER}/*.mod ../../incmod/${LIBNAME}_${VER}
make clean

#
#     Create modulefile
#
cd ../../
lwd=`pwd`
cd $cwd
mkdir -p $lwd/modulefiles/$LIBNAME
cat modulefile.template | sed s:_CWD_:$lwd:g > $lwd/modulefiles/$LIBNAME/$VER

exit
