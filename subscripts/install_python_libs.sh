#!/bin/sh
echo 
if [ `whoami` != "root" ]; then
	echo "Zaloguj się na roota!"
	exit 1
fi
AEPATH=/nz/export/ae/applications/mypython
if [ ! -d $AEPATH ]; then
	echo "Brak ścieżki dla Pythona! Tworzenie... "
	mkdir $AEPATH
fi
if [ "$1" == "clean" ]; then
	read -p "Are you sure to remove all python libs?" -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		rm -rf $AEPATH
		echo "DELETED"
	fi
	exit 0
fi

if [ "$1" == "install" ]; then
	if [ "$#" -lt 2 ]; then
		echo "./install_python.sh install [katalog skąd skopiowane zostaną wszystkie pliki] [biblioteka do instalaji]"
		echo "BRAK ŚCIEŻKI DO KATALOGU BIBLIOTEK SO"
	fi
	if [ "$#" -lt 3 ]; then
		echo "./install_python.sh install [katalog skąd skopiowane zostaną wszystkie pliki] [biblioteka do instalaji]"
		echo "BRAK ŚCIEŻKI DO KATALOGU BIBLIOTEKI PYTHONA INSTALOWANEJ"
	fi
	if [ "$#" -ne 3 ]; then
		exit 1
	fi
	SHAREDLIBS=$2
	INSTALL=$3/lib/python2.6
	if [ ! -d $SHAREDLIBS ]; then
		echo "$SHAREDLIBS nie istnieje"
		exit 2
	fi
	if [ ! -d $INSTALL ]; then
		echo "$INSTALL nie istnieje"
		exit 2
	fi
		
	yes | cp -r $SHAREDLIBS $AEPATH
	echo "COPIED so libs $SHAREDLIBS"
	yes | cp -r $INSTALL $AEPATH
	echo "COPIED lib $INSTALL"
fi