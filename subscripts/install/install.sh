#!/bin/sh
INSTALL_DIR=$1
CURRENT_DIR=`pwd`
if [ ! -d $1 ]; then
	echo "Nie podano ścieżki instalacji"
	exit 1;
fi
# BLAS
read -p "Pytanie 2: Czy kompilować BLAS? [y - zgoda/n - wyjście/s - pomiń]: " choice
case "$choice" in
	y|Y ) cd ./subscripts/ && ./create_blas_libs.sh "$INSTALL_DIR" && cd $CURRENT_DIR ;;
	n|N ) echo "EXIT"; exit 1;;
	s|S ) echo "BLAS pomięty" ;;
	* ) echo "invalid"; exit 1 ;;
esac
if [ "$?" -ne 0 ]; then
	echo "COŚ POSZŁO NIE TAK Exit code: $?"
	exit 1;
fi

# LAPACK
read -p "Pytanie 3: Czy kompilować LAPACK? [y - zgoda/n - wyjście/s - pomiń]: " choice
case "$choice" in
	y|Y ) cd ./subscripts/ && ./create_lapack_libs.sh "$INSTALL_DIR" "$INSTALL_DIR/static/libcblas.a" "$INSTALL_DIR/static/librefblas.a" && cd $CURRENT_DIR ;;
	n|N ) echo "EXIT"; exit 1;;
	s|S ) echo "LAPACK pomięty" ;;
	* ) echo "invalid"; exit 1 ;;
esac
if [ "$?" -ne 0 ]; then
	echo "COŚ POSZŁO NIE TAK Exit code: $?"
	exit 1;
fi

# PIP
read -p "Pytanie 5: Czy instalować PIP ? [y - zgoda/n - wyjście/s - pomiń]: " choice
case "$choice" in
	y|Y ) ./install_pip.sh; cd $CURRENT_DIR ;;
	n|N ) echo "EXIT"; exit 1;;
	s|S ) echo "PIP pomięty" ;;
	* ) echo "invalid"; exit 1 ;;
esac
if [ "$?" -ne 0 ]; then
	echo "COŚ POSZŁO NIE TAK Exit code: $?"
	exit 1;
fi

# SETUPTOOLS
read -p "Pytanie 6: Czy instalować setuptools i wheel? [y - zgoda/n - wyjście/s - pomiń]: " choice
case "$choice" in
	y|Y ) ./install_setuptools.sh; cd $CURRENT_DIR ;;
	n|N ) echo "EXIT"; exit 1;;
	s|S ) echo "SETUPTOOLS pomięty" ;;
	* ) echo "invalid"; exit 1 ;;
esac
if [ "$?" -ne 0 ]; then
	echo "COŚ POSZŁO NIE TAK Exit code: $?"
	exit 1;
fi

# FIX PYTHON
export MYPY=/tmp/pymod/python/2.6/spu/bin
read -p "Pytanie 7: Czy utworzyć zmodowany (fix) pythona? [y - zgoda/n - wyjście/s - pomiń]: " choice
case "$choice" in
	y|Y ) cd ./subscripts; ./create_fixed_python_env.sh; cd $CURRENT_DIR ;;
	n|N ) echo "EXIT"; exit 1;;
	s|S ) echo "FIX PYTHON pomięty" ;;
	* ) echo "invalid"; exit 1 ;;
esac
if [ "$?" -ne 0 ]; then
	echo "COŚ POSZŁO NIE TAK Exit code: $?"
	exit 1;
fi

# NUMPY
read -p "Pytanie 8: Czy kompilować NUMPY? [y - zgoda/n - wyjście/s - pomiń]: " choice
case "$choice" in
	y|Y ) cd ./subscripts; ./create_numpy_libs.sh "$INSTALL_DIR" "$INSTALL_DIR/shared"; cd $CURRENT_DIR; ;;
	n|N ) echo "EXIT"; exit 1;;
	s|S ) echo "NUMPY COMPILE pomięty" ;;
	* ) echo "invalid"; exit 1 ;;
esac
if [ "$?" -ne 0 ]; then
	echo "COŚ POSZŁO NIE TAK Exit code: $?"
	exit 1;
fi

# NUMPY install
read -p "Pytanie 9: Czy instalować NUMPY? [y - zgoda/n - wyjście/s - pomiń]: " choice
case "$choice" in
	y|Y ) cd ./subscripts; ./install_python_libs.sh install "$INSTALL_DIR/shared" "$INSTALL_DIR/numpy/package"; cd $CURRENT_DIR; ;;
	n|N ) echo "EXIT"; exit 1;;
	s|S ) echo "NUMPY INSTALL pomięty" ;;
	* ) echo "invalid"; exit 1 ;;
esac
if [ "$?" -ne 0 ]; then
	echo "COŚ POSZŁO NIE TAK Exit code: $?"
	exit 1;
fi


# SCIPY
read -p "Pytanie 10: Czy kompilować SCIPY? [y - zgoda/n - wyjście/s - pomiń]: " choice
case "$choice" in
	y|Y ) cd ./subscripts; ./create_scipy_libs.sh "$INSTALL_DIR" "$INSTALL_DIR/shared" "$INSTALL_DIR/numpy/package/lib/python2.6/site-packages"; cd $CURRENT_DIR; ;;
	n|N ) echo "EXIT"; exit 1;;
	s|S ) echo "SCIPY COMPILE pomięty" ;;
	* ) echo "invalid"; exit 1 ;;
esac
if [ "$?" -ne 0 ]; then
	echo "COŚ POSZŁO NIE TAK Exit code: $?"
	exit 1;
fi

# SCIPY install
read -p "Pytanie 11: Czy instalować SCIPY? [y - zgoda/n - wyjście/s - pomiń]: " choice
case "$choice" in
	y|Y ) cd ./subscripts; ./install_python_libs.sh install "$INSTALL_DIR/shared" "$INSTALL_DIR/SCIPY/package"; cd $CURRENT_DIR; ;;
	n|N ) echo "EXIT"; exit 1;;
	s|S ) echo "SCIPY INSTALL pomięty" ;;
	* ) echo "invalid"; exit 1 ;;
esac
if [ "$?" -ne 0 ]; then
	echo "COŚ POSZŁO NIE TAK Exit code: $?"
	exit 1;
fi

# SKLEARN
read -p "Pytanie 12: Czy kompilować SKLEARN? [y - zgoda/n - wyjście/s - pomiń]: " choice
case "$choice" in
	y|Y ) cd ./subscripts; ./create_sklearn_libs.sh "$INSTALL_DIR" "$INSTALL_DIR/shared" "$INSTALL_DIR/numpy/package/lib/python2.6/site-packages" "$INSTALL_DIR/SCIPY/package/lib/python2.6/site-packages"; cd $CURRENT_DIR; ;;
	n|N ) echo "EXIT"; exit 1;;
	s|S ) echo "SKLEARN COMPILE pomięty" ;;
	* ) echo "invalid"; exit 1 ;;
esac
if [ "$?" -ne 0 ]; then
	echo "COŚ POSZŁO NIE TAK Exit code: $?"
	exit 1;
fi

# SKLEARN install
read -p "Pytanie 13: Czy instalować SKLEARN? [y - zgoda/n - wyjście/s - pomiń]: " choice
case "$choice" in
	y|Y ) cd ./subscripts; ./install_python_libs.sh install "$INSTALL_DIR/shared" "$INSTALL_DIR/sklearn/package"; cd $CURRENT_DIR; ;;
	n|N ) echo "EXIT"; exit 1;;
	s|S ) echo "SKLEARN INSTALL pomięty" ;;
	* ) echo "invalid"; exit 1 ;;
esac
if [ "$?" -ne 0 ]; then
	echo "COŚ POSZŁO NIE TAK Exit code: $?"
	exit 1;
fi

# FIX zlib
read -p "Pytanie 4: Czy naprawić ZLIB w PYTHON ? [y - zgoda/n - wyjście/s - pomiń]: " choice
case "$choice" in
	y|Y ) cd ./subscripts/ && ./fix_zlib.sh; cd $CURRENT_DIR ;;
	n|N ) echo "EXIT"; exit 1;;
	s|S ) echo "Naprawa zlib pominięta" ;;
	* ) echo "invalid"; exit 1 ;;
esac
if [ "$?" -ne 0 ]; then
	echo "COŚ POSZŁO NIE TAK Exit code: $?"
	exit 1;
fi
