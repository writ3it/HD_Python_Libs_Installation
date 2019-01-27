#!/bin/sh
NUMPYURL='https://files.pythonhosted.org/packages/1d/94/3ad9a865f1b0853f952eaa9878c59371ac907b768fe789547f573a6c9b39/numpy-1.10.4.tar.gz'
NUMPYDIR="numpy-1.10.4"

if [ "$#" -lt 1 ]; then
	echo "PARAM 1 Musisz podać ścieżkę w której zostaną zapisane biblioteki NUMPY"
fi
if [ "$#" -lt 2 ]; then
	echo "PARAM 2 Musisz podać ścieżkę do katalogu z bibliotekami liblapack.so oraz librefblas.so"
fi

 
if [ "$#" -ne 2 ]; then
	echo "./create_numpy_libs.sh [PARAM 1] [PARAM 2]"
	exit 1
fi
BLAS_PATH=$2/librefblas.so
LAPACK_PATH=$2/liblapack.so
OUTPUT=$1
LIB_PATH=$2


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

if [ ! -d $OUTPUT/numpy ]; then
	mkdir $OUTPUT/numpy
fi
OUTPUT=$OUTPUT/numpy

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
if [ ! -f $WORKDIR/numpy.tar.gz ]; then
	echo "DOWNLOADING numpy $NUMPYDIR"
	wget $NUMPYURL --no-check-certificate -O $WORKDIR/numpy.tar.gz
else 
	echo "NUMPY DOWNLOADED"
fi
NUMPYSOURCES=$WORKDIR/sources/$NUMPYDIR
CURRENTIDR=`pwd`
if [ ! -d $WORKDIR/sources/$NUMPYDIR/build ]; then
	if [ -d $WORKDIR/sources ]; then
		echo "KASOWANIE POPRZEDNICH ŹRÓDEŁ"
		rm -rf $WORKDIR/sources
	fi
	mkdir $WORKDIR/sources
	echo "UNPACKING" 
	tar -zxvf $WORKDIR/numpy.tar.gz -C $WORKDIR/sources > ../logs/numpy_tar.log
	yes | cp ./data/site.cfg.numpy $NUMPYSOURCES/site.cfg
	sed -i -e "s@{LIBRARY_DIRS}@$LIB_PATH@g" $NUMPYSOURCES/site.cfg
	
	echo "BUILDING"
	cd $NUMPYSOURCES
	$MYPY/python setup.py build --fcompiler=gfortran > $CURRENTIDR/logs/numpy_build.log
else
	cd $NUMPYSOURCES 
	echo "COMPILE EXISTS"
fi
mkdir $OUTPUT/package
echo "INSTALLING"
mkdir $OUTPUT/package/lib64/python2.6/site-packages
$MYPY/python setup.py install --prefix=$OUTPUT/package > $CURRENTIDR/logs/numpy_install.log