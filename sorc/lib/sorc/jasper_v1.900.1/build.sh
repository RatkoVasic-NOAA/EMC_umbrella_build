#!/bin/sh
set -eux
#-----------------------------------------------------
cwd=`pwd`
source ../../../machine-setup.sh > /dev/null 2>&1

export LIBNAME=jasper
export VER=v1.900.1

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
tar xf jasper-1.900.1.tar.gz
cd jasper-1.900.1
###########################################################
./configure --prefix=$cwd/jasper-1.900.1
make
make install
###########################################################
mkdir -p $LOCAL_EXTERN/${LIBNAME}_${VER}/incmod
mv include/${LIBNAME}/* $LOCAL_EXTERN/${LIBNAME}_${VER}/incmod/.
mkdir -p $LOCAL_EXTERN/${LIBNAME}_${VER}/libs
mv lib/* $LOCAL_EXTERN/${LIBNAME}_${VER}/libs/.
###########################################################
cd $cwd
rm -rf jasper-1.900.1
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
