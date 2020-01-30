#!/bin/sh
set -eux
#-----------------------------------------------------
cwd=`pwd`
source ../../../machine-setup.sh > /dev/null 2>&1

export LIBNAME=z
export VER=v1.2.6

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
LOCAL_EXTERN=${lwd}/ext_libs
###########################################################
tar xf zlib-1.2.6.tar.gz
cd zlib-1.2.6
###########################################################
./configure --prefix=$cwd/zlib-1.2.6
make test
###########################################################
mkdir -p $LOCAL_EXTERN/${LIBNAME}_${VER}/incmod
cp zlib.h zconf.h $LOCAL_EXTERN/${LIBNAME}_${VER}/incmod/.
mkdir -p $LOCAL_EXTERN/${LIBNAME}_${VER}/libs
cp libz.a $LOCAL_EXTERN/${LIBNAME}_${VER}/libs/.
###########################################################
cd $cwd
rm -rf zlib-1.2.6
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
