#!/bin/sh
if [ "$#" -ne 1 ]; then
	echo "Musisz podać ścieżkę w której zostaną zapisane biblioteki BLAS"
	exit 1
fi
if [ ! -d "$1" ]; then
	echo "$1 musi być zapisywalny"
	exit 2
fi
URL=http://www.netlib.org/lapack/lapack-3.4.2.tgz
SOURCES=/tmp/blas/sources/lapack-3.4.2
if [ ! -d /tmp/blas/sources/lapack-3.4.2 ]; then
	mkdir /tmp/blas
	mkdir /tmp/blas/sources
	wget $URL -O /tmp/blas/lapack.tar.gz
	echo "UNPACKING"
	tar -zxvf /tmp/blas/lapack.tar.gz -C /tmp/blas/sources > ../logs/blas_tar.log
fi
BASEPATH=$SOURCES
DATAPATH=./data


if [ -f $BASEPATH/librefblas.a ]; then
	echo "CLEAN BLAS"
	make clean -C $BASEPATH/BLAS > ../logs/blas_clean.log
fi

echo "LD_LIBRARY_PATH=[$LD_LIBRARY_PATH]"
BC_LD=$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/nz/export/ae/sysroot/spu/generic/x86_64-generic-linux-gnu/lib:$LD_LIBRARY_PATH

CURRENTDIR=`pwd`
cd $BASEPATH/BLAS/SRC
echo "COMPILING..."
/nz/export/ae/sysroot/spu/bin/gfortran -fPIC -O3 -c *.f   > $CURRENTDIR/logs/blas_compile.log
echo "PACKING..."
/nz/export/ae/sysroot/spu/bin/ar rv ../../librefblas.a *.o   > $CURRENTDIR/logs/blas_ar.log

cd $CURRENTDIR

if [ ! -f $BASEPATH/librefblas.a ]; then
	echo "ERROR WHILE COMPILE BLAS"
	exit 3
fi


echo "Copy DIRS"
STATIC=$1/static
DYNAMIC=$1/shared
if [ ! -d $STATIC ]; then
	echo "CREATING STATIC DIR LIBS"
	mkdir $STATIC
fi
if [ ! -d $DYNAMIC ]; then
	echo "CREATING SHARED DIR LIBS"
	mkdir $DYNAMIC
fi

echo "CREATING SHARED LIBS"
mkdir $BASEPATH/libcblas
mkdir $BASEPATH/libblas

CURRENTDIR=`pwd`
cd $BASEPATH/libblas
/nz/export/ae/sysroot/spu/bin/ar xv $BASEPATH/librefblas.a   > $CURRENTDIR/logs/blas_ar2.log
/nz/export/ae/sysroot/spu/bin/gcc -shared -o $DYNAMIC/librefblas.so *.o  > $CURRENTDIR/logs/blas_shared.log

echo "CREATING STATIC LIBS"
cp $BASEPATH/librefblas.a $STATIC/librefblas.a

 
rm -rf /tmp/blas
exit 0