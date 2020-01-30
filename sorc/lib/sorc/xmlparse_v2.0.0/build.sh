#!/bin/sh
set -eux
#-----------------------------------------------------
cwd=`pwd`
source ../../../machine-setup.sh > /dev/null 2>&1

export LIBNAME=xmlparse
export VER=v2.0.0
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
LOCAL_EXTERN=${lwd}/ext_libs
###########################################################
tar xf xmlparse_v2.0.0.tar.gz
cd xmlparse_v2.0.0
###########################################################
./configure --prefix=$LOCAL_EXTERN FCFLAGS="-O2"
make all
make install
mv $LOCAL_EXTERN/xmlparse-2.0.0 $LOCAL_EXTERN/${LIBNAME}_${VER}
###########################################################
cd $cwd
ls -l
rm -rf xmlparse_v2.0.0
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
