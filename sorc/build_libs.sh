#!/bin/sh
set -eux

source ./machine-setup.sh > /dev/null 2>&1
cwd=`pwd`

# --------------------------------------------------------------
#
# Clean lib directory (libraries, modulefiles and incmod)
#
# --------------------------------------------------------------

cd $cwd/lib
rm -rf libs/* incmod/* modulefiles/* ext_libs/*

# --------------------------------------------------------------
#
# First independent libraries:
#
# --------------------------------------------------------------

for lib in \
    bacio_v2.0.2         \
    bufr_v10.2.5         \
    bufr_v11.0.1         \
    crtm_v2.0.6          \
    crtm_v2.2.3          \
    g2tmpl_v1.3.0        \
    gfsio_v1.1.0         \
    ip_v2.0.0            \
    ip_v3.0.0            \
    landsfcutil_v2.1.0   \
    nemsio_v2.2.3        \
    sfcio_v1.0.0         \
    sigio_v2.0.1         \
    sp_v2.0.2            \
    w3nco_v2.0.6
do
 cd $cwd/lib/sorc/$lib
 ./build.sh
 cd $cwd
done

# --------------------------------------------------------------
#
# Third party libraries needed for G2 and G2C:
#
# --------------------------------------------------------------

for lib in \
    jasper_v1.900.1      \
    png_v1.2.44          \
    z_v1.2.6
do
 cd $cwd/lib/sorc/$lib
 ./build.sh
 cd $cwd
done

# --------------------------------------------------------------
#
# Libraries depending on previously installed libs:
#
# --------------------------------------------------------------

for lib in \
    w3emc_v2.2.0         \
    nemsiogfs_v2.0.1     \
    g2c_v1.5.0           \
    g2_v3.1.0
do
 cd $cwd/lib/sorc/$lib
 ./build.sh
 cd $cwd
done

# --------------------------------------------------------------
#
# Install individual 3rd party libraries (hdf5, netcdf, ESMF, ...)
#
# --------------------------------------------------------------

for lib in \
    xmlparse_v2.0.0 \
    hdf5_v1.8.18    \
    netcdf_v3.6.3   \
    netcdf_v4.4.1.1 \
    netcdf_v4.4.4   \
    esmf_v7.1.0r
do
 cd $cwd/lib/sorc/$lib
 ./build.sh
 cd $cwd
done

exit
