#!/bin/sh
set -eux
#-----------------------------------------------------
cwd=`pwd`
source ../../../machine-setup.sh > /dev/null 2>&1
module use ../../modulefiles
module load hdf5/v1.8.18

export LIBNAME=netcdf
export VER=v4.4.4.1
export FC=ifort
export cc=icc

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

export CPPFLAGS=$HDF5_INCLUDE_OPTS
export LDFLAGS=$HDF5_LINK_OPTS

###########################################################
cd ../../
lwd=`pwd`
cd $cwd
LOCAL_EXTERN=${lwd}/ext_libs/${LIBNAME}_${VER}
mkdir -p $LOCAL_EXTERN
rm -rf $LOCAL_EXTERN/*
###########################################################
tar xf netcdf-c-4.4.1.1.tar.gz
cd netcdf-c-4.4.1.1
###########################################################
./configure --prefix=$LOCAL_EXTERN  --disable-shared --disable-dap
make all
make install
cd $cwd
rm -rf netcdf-c-4.4.1.1
###########################################################

#
#     Create modulefile
#
cd ../../
lwd=`pwd`
cd $cwd
mkdir -p $lwd/modulefiles/$LIBNAME
cat modulefile.template | sed s:_CWD_:$lwd:g > $lwd/modulefiles/$LIBNAME/$VER

exit
