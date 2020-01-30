#!/bin/sh
set -eux
#-----------------------------------------------------
cwd=`pwd`
source ../../../machine-setup.sh > /dev/null 2>&1
module use ../../modulefiles

export LIBNAME=esmf
export VER=v7.1.0r
export FC=ifort
export cc=icc

if [ $target = wcoss_cray ]; then
  export ESMF_COMM=mpi
  export ESMF_OS=Unicos
  module load PrgEnv-intel
  module load craype-sandybridge
  module load netcdf/v4.4.4.1
  module load hdf5/v1.8.18
  module load xt-lsfhpc/9.1.3
elif [ $target = "wcoss" ]; then
  module load ics/12.1
  module load netcdf/v4.4.4.1
  module load hdf5/v1.8.18
  export ESMF_OS=Linux
  export ESMF_COMM=intelmpi
elif [ $target = "theia" ]; then
  module load intel/14.0.2
  module load impi/5.1.2.150
  module load netcdf/v4.4.4.1
  module load hdf5/v1.8.18
  export ESMF_OS=Linux
  export ESMF_COMM=intelmpi
elif [ $target = "gaea" ]; then
  export ESMF_COMM=mpi
  export ESMF_OS=Unicos
  module load xt-lsfhpc/9.1.3
  module load netcdf/v4.4.4.1
  module load hdf5/v1.8.18
elif [ $target = "jet" ]; then
  module load intel/12.1.4
  module load mvapich2/1.8
  module load netcdf/v4.4.4.1
  module load hdf5/v1.8.18
  export ESMF_OS=Linux
  export ESMF_COMM=mpich2
fi

###########################################################
cd ../../
lwd=`pwd`
cd $cwd
LOCAL_EXTERN=${lwd}/ext_libs/${LIBNAME}_${VER}
mkdir -p $LOCAL_EXTERN
rm -rf $LOCAL_EXTERN/*
###########################################################
tar xf esmf_7_1_0r_src.tar.gz
cd esmf
#####
cp ../common.mk ./build/.
#####
###########################################################
export ESMF_INSTALL_PREFIX=$LOCAL_EXTERN
export ESMF_DIR=`pwd`
export ESMF_COMPILER=intel
export ESMF_SITE=default
export ESMF_INSTALL_MODDIR=mod
export ESMF_INSTALL_BINDIR=bin
export ESMF_INSTALL_LIBDIR=lib
export ESMF_NETCDF=split
export NETCDF_DIR=$NETCDF
export ESMF_NETCDF_INCLUDE=$NETCDF_DIR/include
export ESMF_NETCDF_LIBPATH=$NETCDF_DIR/lib
export ESMF_F90COMPILEOPTS="-fp-model source"
export ESMF_CXXCOMPILEOPTS="-fp-model source"
###########################################################
gmake clean
gmake -j4 lib
gmake install
cd $cwd
rm -rf esmf
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
