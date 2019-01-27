#!/bin/sh
sklearnURL='https://files.pythonhosted.org/packages/40/91/ec319f8ddad10539440192ac0ed6f445eda57472f370e66a70bdaf90003d/scikit-learn-0.16.1.tar.gz'
sklearnDIR="scikit-learn-0.16.1"

if [ "$#" -lt 1 ]; then
	echo "PARAM 1 Musisz podać ścieżkę w której zostaną zapisane biblioteki sklearn"
fi
if [ "$#" -lt 2 ]; then
	echo "PARAM 2 Musisz podać ścieżkę do katalogu z bibliotekami liblapack.so oraz librefblas.so"
fi

if [ "$#" -lt 3 ]; then
	echo "PARAM 3 Musisz podać ścieżkę do katalogu paczek numpy (site-packages)"
fi
if [ "$#" -lt 4 ]; then
	echo "PARAM 3 Musisz podać ścieżkę do katalogu paczek scipy (site-packages)"
fi


if [ "$#" -ne 4 ]; then
	echo "./create_sklearn_libs.sh [PARAM 1] [PARAM 2] [PARAM 3] [PARAM 4]"
	exit 1
fi
BLAS_PATH=$2/librefblas.so
LAPACK_PATH=$2/liblapack.so
OUTPUT=$1
LIB_PATH=$2
NUMPY_INSTALL_DIR=$3
sklearn_INSTALL_DIR=$4

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

if [ ! -d $OUTPUT/sklearn ]; then
	mkdir $OUTPUT/sklearn
fi
OUTPUT=$OUTPUT/sklearn

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
if [ ! -f $WORKDIR/sklearn.tar.gz ]; then
	echo "DOWNLOADING sklearn $sklearnDIR"
	wget $sklearnURL --no-check-certificate -O $WORKDIR/sklearn.tar.gz
else 
	echo "sklearn DOWNLOADED"
fi
sklearnSOURCES=$WORKDIR/sources/$sklearnDIR
CURRENTIDR=`pwd`
if [ ! -d $WORKDIR/sources/$sklearnDIR/build ]; then
	if [ -d $WORKDIR/sources ]; then
		echo "KASOWANIE POPRZEDNICH ŹRÓDEŁ"
		rm -rf $WORKDIR/sources
	fi
	mkdir $WORKDIR/sources
	echo "UNPACKING"
	tar -zxvf $WORKDIR/sklearn.tar.gz -C $WORKDIR/sources > ../logs/sklearn_tar.log
	yes | cp ./data/setup.py.sklearn $sklearnSOURCES/setup.py
	sed -i -e "s@{NUMPY_PACKAGES_PATH}@$NUMPY_INSTALL_DIR@g" $sklearnSOURCES/setup.py
	sed -i -e "s@{SCIPY_PACKAGES_PATH}@$sklearn_INSTALL_DIR@g" $sklearnSOURCES/setup.py
	
	echo "BUILD"
	cd $sklearnSOURCES
	CFLAGS="-march=i686" $MYPY/python setup.py build --fcompiler=gfortran > $CURRENTIDR/../logs/sklearn_build.py
else
	cd $sklearnSOURCES 
	echo "COMPILE EXISTS"
fi
echo "INSTALL"
mkdir $OUTPUT/package
$MYPY/python setup.py install --prefix=$OUTPUT/package > $CURRENTIDR/../logs/sklearn_install.py