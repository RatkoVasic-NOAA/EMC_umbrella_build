#!/bin/sh
set -eux
#-----------------------------------------------------
cwd=`pwd`
source ../../../machine-setup.sh > /dev/null 2>&1
module use ../../modulefiles

export LIBNAME=nemsiogfs
export VER=v2.0.1
export INC='incmod'
export LIBDIR='../../'
export FCOMP=ifort
export FCFLAGS='-O3 -FR -I$(NEMSIO_INC)'

if [ $target = wcoss_cray ]; then
  export FCFLAGS='-O3 -FR -I$(NEMSIO_INC) -axCore-AVX2 -craype-verbose'
  export FCOMP=ftn
  module load PrgEnv-intel
  module load craype-sandybridge
  module load nemsio-intel/2.2.3
elif [ $target = "wcoss" ]; then
  module load ics/12.1
  module load nemsio/v2.2.3
elif [ $target = "theia" ]; then
  module load intel/14.0.2
  module load nemsio/v2.2.3
elif [ $target = "gaea" ]; then
  module load nemsio/v2.2.3
elif [ $target = "jet" ]; then
  module load intel/12.1.4
  module load nemsio/v2.2.3
fi
make clean
make

mkdir -p ../../libs/${LIBNAME}_${VER}
mv ../../libnemsiogfs_${VER}.a ../../libs/${LIBNAME}_${VER}/.

#Create modulefile
cd ../../
lwd=`pwd`
cd $cwd
mkdir -p $lwd/modulefiles/$LIBNAME
cat modulefile.template | sed s:_CWD_:$lwd:g > $lwd/modulefiles/$LIBNAME/$VER

exit
