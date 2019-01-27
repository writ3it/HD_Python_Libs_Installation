#!/bin/sh
SCIPYURL='https://files.pythonhosted.org/packages/22/41/b1538a75309ae4913cdbbdc8d1cc54cae6d37981d2759532c1aa37a41121/scipy-0.18.1.tar.gz'
SCIPYDIR="scipy-0.18.1"

if [ "$#" -lt 1 ]; then
	echo "PARAM 1 Musisz podać ścieżkę w której zostaną zapisane biblioteki SCIPY"
fi
if [ "$#" -lt 2 ]; then
	echo "PARAM 2 Musisz podać ścieżkę do katalogu z bibliotekami liblapack.so oraz librefblas.so"
fi

if [ "$#" -lt 3 ]; then
	echo "PARAM 3 Musisz podać ścieżkę do katalogu paczek numpy (site-packages)"
fi


if [ "$#" -ne 3 ]; then
	echo "./create_SCIPY_libs.sh [PARAM 1] [PARAM 2] [PARAM 3]"
	exit 1
fi
BLAS_PATH=$2/librefblas.so
LAPACK_PATH=$2/liblapack.so
OUTPUT=$1
LIB_PATH=$2
NUMPY_INSTALL_DIR=$3

if [ ! -d $OUTPUT ]; then
	echo "$OUTPUT musi być zapisywalny"
	exit 2
fi

if [ ! -f $BLAS_PATH ]; then
	echo "$BLAS_PATH nie istnieje"
	exit 2
fi

if [ ! -f $LAPACK_PATH ]; then
	echo "$LAPACK_PATH nie istnieje"
	exit 2
fi

if [ ! -d $OUTPUT/SCIPY ]; then
	mkdir $OUTPUT/SCIPY
fi
OUTPUT=$OUTPUT/SCIPY

echo "LD_LIBRARY_PATH=[$LD_LIBRARY_PATH]"
export LD_LIBRARY_PATH=$LIB_PATH:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/nz/export/ae/sysroot/spu/generic/x86_64-generic-linux-gnu/lib/:$LD_LIBRARY_PATH
export BLAS=$BLAS_PATH
export LAPACK=$LAPACK_PATH
echo "NEW LD_LIBRARY_PATH=[$LD_LIBRARY_PATH]"
echo "PATH=[$PATH]"
export PATH="/nz/export/ae/sysroot/spu/bin/:$PATH"
echo "NEW PATH=[$PATH]"
echo "NEW BLAS=[$BLAS]"
echo "NEW LAPACK=[$LAPACK]"
WORKDIR=$OUTPUT
if [ ! -f $WORKDIR/SCIPY.tar.gz ]; then
	echo "DOWNLOADING SCIPY $SCIPYDIR"
	wget $SCIPYURL --no-check-certificate -O $WORKDIR/SCIPY.tar.gz
else 
	echo "SCIPY DOWNLOADED"
fi
SCIPYSOURCES=$WORKDIR/sources/$SCIPYDIR
CURRENTIDR=`pwd`
if [ ! -d $WORKDIR/sources/$SCIPYDIR/build ]; then
	if [ -d $WORKDIR/sources ]; then
		echo "KASOWANIE POPRZEDNICH ŹRÓDEŁ"
		rm -rf $WORKDIR/sources
	fi
	mkdir $WORKDIR/sources
	echo "UNPACKING" 
	tar -zxvf $WORKDIR/SCIPY.tar.gz -C $WORKDIR/sources > ../logs/scipy_tar.log
	yes | cp ./data/setup.py.scipy $SCIPYSOURCES/setup.py
	sed -i -e "s@{NUMPY_PACKAGES_PATH}@$NUMPY_INSTALL_DIR@g" $SCIPYSOURCES/setup.py
	echo "BUILDING"
	cd $SCIPYSOURCES
	CFLAGS="-march=i686" $MYPY/python setup.py build --fcompiler=gfortran > $CURRENTIDR/../logs/scipy_build.log
else
	cd $SCIPYSOURCES 
	echo "COMPILE EXISTS"
fi
echo "INSTALL"
mkdir $OUTPUT/package
$MYPY/python setup.py install --prefix=$OUTPUT/package > $CURRENTIDR/../logs/scipy_install.log