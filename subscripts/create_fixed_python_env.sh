#!/bin/sh
CURRENTDIR=`pwd`
mkdir /tmp/pymod
cd /tmp/pymod
cp -r /nz/export/ae/languages/python .

cd python/2.6/spu/lib/python2.6
mv hashlib.py hashlib.py.back
cp $CURRENTDIR/data/hashlib.py hashlib.py
if [ "${#MYPY}" -eq 0 ]; then
	echo "Added $MYPY to .bashrc use source ~/.bashrc"
	echo "export MYPY=/tmp/pymod/python/2.6/spu/bin" >> ~/.bashrc
	source ~/.bashrc
else 
	if [ ! -d $MYPY ]; then
		echo "Added $MYPY to .bashrc use source /export/home/nz/.bashrc"
		echo "export MYPY=/tmp/pymod/python/2.6/spu/bin" >> ~/.bashrc
		source ~/.bashrc
	else 
		echo "MYPY exists"
	fi
fi
echo "Jak chcesz $MYPY na koncie nz to dodaj do .bashrc ;)"
echo "Po instalacji zrób source ~/.bashrc jeżeli masz taką potrzebę."
echo 0