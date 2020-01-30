#!/bin/sh
set -eux
#-----------------------------------------------------
cwd=`pwd`
source ../../../machine-setup.sh > /dev/null 2>&1
module use ../../modulefiles

export LIBNAME=netcdf
export VER=v4.4.4.1
export FC=ifort
export cc=icc

if [ $target = wcoss_cray ]; then
  export FCMP=ftn
  module load PrgEnv-intel
  module load craype-sandybridge
  module load hdf5/v1.8.18
  module load netcdf/v4.4.4.1
elif [ $target = "wcoss" ]; then
  module load ics/12.1
  module load hdf5/v1.8.18
  module load netcdf/v4.4.4.1
elif [ $target = "theia" ]; then
  module load intel/14.0.2
  module load hdf5/v1.8.18
  module load netcdf/v4.4.4.1
elif [ $target = "gaea" ]; then
  module load hdf5/v1.8.18
  module load netcdf/v4.4.4.1
elif [ $target = "jet" ]; then
  module load intel/12.1.4
  module load hdf5/v1.8.18
  module load netcdf/v4.4.4.1
fi

export CPPFLAGS="$HDF5_INCLUDE_OPTS -I$NETCDF/include"
export LDFLAGS="$HDF5_LINK_OPTS -L$NETCDF/lib"

###########################################################
cd ../../
lwd=`pwd`
cd $cwd
LOCAL_EXTERN=${lwd}/ext_libs/${LIBNAME}_${VER}
if [ ! -d $LOCAL_EXTERN ]; then echo "Build first netcdf_v4.4.1.1!" ; exit 9 ; fi
###########################################################
tar xf netcdf-fortran-4.4.4.tar.gz
cd netcdf-fortran-4.4.4
#####
cp ../configure .
#####
###########################################################
./configure --prefix=$LOCAL_EXTERN  --disable-shared
make all
make install
cd $cwd
rm -rf netcdf-fortran-4.4.4
###########################################################

exit
