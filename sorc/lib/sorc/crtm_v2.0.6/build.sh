#!/bin/sh
set -eux
#-----------------------------------------------------
cwd=`pwd`
source ../../../machine-setup.sh > /dev/null 2>&1

export LIBNAME=crtm
export VER=v2.0.6
export FCMP=ifort
export CCMP=icc
export LIB_TEMP=${LIBNAME}_${VER}

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
# Repository site:
# svn co https://svnemc.ncep.noaa.gov/projects/crtm/releases/REL-2.0.6_nofix
###########################################################
tar xf REL-2.0.6_nofix.tar.gz
cd REL-2.0.6_nofix
###########################################################
rm -rf ../../../incmod/$LIB_TEMP ../../../libs/${LIBNAME}_${VER}/lib${LIB_TEMP}.a
. configure/ifort.setup
make
make install
###########################################################
 mkdir -p ../../../libs/${LIBNAME}_${VER}
 mv lib/libCRTM.a ../../../libs/${LIBNAME}_${VER}/lib${LIB_TEMP}.a
 mkdir -p ../../../incmod/$LIB_TEMP
 mv include/*.mod ../../../incmod/$LIB_TEMP
###########################################################
cd $cwd
rm -rf REL-2.0.6_nofix
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
