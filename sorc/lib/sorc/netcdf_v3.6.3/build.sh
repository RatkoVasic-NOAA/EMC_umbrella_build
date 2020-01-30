#!/bin/sh
set -eux
#-----------------------------------------------------
cwd=`pwd`
source ../../../machine-setup.sh > /dev/null 2>&1

export LIBNAME=netcdf
export VER=v3.6.3
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

###########################################################
cd ../../
lwd=`pwd`
cd $cwd
LOCAL_EXTERN=${lwd}/ext_libs/${LIBNAME}_${VER}
mkdir -p $LOCAL_EXTERN
rm -rf $LOCAL_EXTERN/*
###########################################################
tar xf netcdf-3.6.3.tar.gz
cd netcdf-3.6.3
###########################################################
./configure --prefix=$LOCAL_EXTERN --disable-shared --disable-docs-install
make all
make install
cd $cwd
rm -rf netcdf-3.6.3
###########################################################
cp fake.f $LOCAL_EXTERN/lib/.
cd $LOCAL_EXTERN/lib
$FC -c  fake.f -o fake.o
ar -ruv fake.a fake.o
ln -s fake.a libnetcdff.a
cd $cwd
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
