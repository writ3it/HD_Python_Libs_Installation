#!/bin/sh

if [ "$#" -lt 1 ]; then
	echo "PARAM 1 Musisz podać ścieżkę w której zostaną zapisane biblioteki LAPACK"
fi
if [ "$#" -lt 2 ]; then
	echo "PARAM 2 Musisz podać ścieżkę do statycznej bibliteki CBLAS (libcblas.a)"
fi
if [ "$#" -lt 3 ]; then
	echo "PARAM 3 Musisz podać ścieżkę do statycznej bibliteki BLAS (librefblas.a)"
fi

if [ "$#" -ne 3 ]; then
	echo "./create_lapack_libs.sh [PARAM 1] [PARAM 2] [PARAM 3]"
	exit 1
fi
CBLAS=$2
BLAS=$3
OUTPUT=$1

if [ ! -d $OUTPUT ]; then
	echo "$OUTPUT musi być zapisywalny"
	exit 2
fi

if [ ! -f $BLAS ]; then
	echo "$BLAS nie istnieje"
	exit 2
fi

if [ ! -d $OUTPUT/shared ]; then
	mkdir $OUTPUT/shared
fi

if [ ! -d $OUTPUT/static ]; then
	mkdir $OUTPUT/static
fi
BASEPATH=./data
URL=http://www.netlib.org/lapack/lapack-3.4.2.tgz
SOURCES=/tmp/blas/sources/lapack-3.4.2
if [ ! -d $SOURCES ]; then
	mkdir /tmp/blas
	mkdir /tmp/blas/sources
	wget $URL -O /tmp/blas/lapack.tar.gz
	echo "UNPACKING"
	tar -zxvf /tmp/blas/lapack.tar.gz -C /tmp/blas/sources > ../logs/lapack_tar.log
else
	echo "LAPACK EXISTS IN $SOURCES"
fi
if [ ! -d $SOURCES ]; then
	echo "ERROR IN DOWNLOAD LAPACK"
	exit 3
fi
yes | cp $BASEPATH/make.inc.lapack $SOURCES/make.inc
sed -i -e "s@{BLAS_PATH}@$BLAS@g" $SOURCES/make.inc
sed -i -e "s@{CBLAS_PATH}@$CBLAS@g" $SOURCES/make.inc
echo "LD_LIBRARY_PATH=[$LD_LIBRARY_PATH]"
BC_LD=$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/nz/export/ae/sysroot/spu/generic/x86_64-generic-linux-gnu/lib:$LD_LIBRARY_PATH
echo "NEW LD_LIBRARY_PATH=[$LD_LIBRARY_PATH]"

if [ -f $SOURCES/liblapack.a ]; then
	echo "CLEAN LAPACK"
	make clean -C $SOURCES > ../logs/lapack_clean.log
fi
echo "COMPILE"
make lapacklib -C $SOURCES > ../logs/lapack_log.log

if [ ! -f $SOURCES/liblapack.a ]; then
	echo "ERROR WHILE COMPILE LAPACK"
	exit 3
fi
CURRENTDIR=`pwd`
mkdir $SOURCES/liblapack
cd $SOURCES/liblapack
/nz/export/ae/sysroot/spu/bin/ar xv ../liblapack.a > $CURRENTDIR/logs/lapack_ar2.log
/nz/export/ae/sysroot/spu/bin/gcc -shared -o $OUTPUT/shared/liblapack.so *.o > $CURRENTDIR/logs/lapack_shared.log
cp $SOURCES/liblapack.a $OUTPUT/static/liblapack.a
exit 0
