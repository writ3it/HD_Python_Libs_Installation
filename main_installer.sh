#!/bin/sh
clear
echo
echo "-----------------------------------------------"
echo "Instalator blas, lapack, numpy, scipy, sklearn"
echo "-----------------------------------------------"
echo " By J.Klorek, A.Nowak, J.Malczewski PUT POZNAN "
echo "-----------------------------------------------"
echo " NUMPY: 1.10.4 (pierwotnie 1.7.2) "
echo " SCIPY: 0.18.1 (pierwotnie 0.13.2) przedstawia się jako 0.13.1 :/"
echo " SKLEARN: 1.16.1 (pierwotnie 0.14.1) "

#sprawdzanie czy root
if [ `whoami` != root ]; then
	echo "!!! Musisz zalogować się na roota. !!!"
	echo "EXIT"
	exit 1
fi
#----

#sprawdzanie liczby parametrow
if [ "$#" -lt 1 ]; then
	echo "!!! Złe parametry! !!!"
	echo
	echo "./main_installer.sh [clean|help|install] [install_path]"
	echo
	echo "install_path - katalog w którym znajdą się skompilowane biblioteki oraz trochę źródeł. Jest to katalog tymczasowy ale kompilacje mogą się przydać na przyszłość :)"
	echo "EXIT"
	exit 1
fi
#----



if [ "$1" == "clean" ]; then
	./subscripts/install/clean.sh
	echo "EXIT $?"
	exit 1
fi

if [ "$1" == "help" ]; then
	echo
	echo "./main_installer.sh [clean|help|install] [install_path]"
	echo
	echo "install_path - katalog w którym znajdą się skompilowane biblioteki oraz trochę źródeł. Jest to katalog tymczasowy ale kompilacje mogą się przydać na przyszłość :)"
	echo
	echo "Proces będzie zadawał pytania czy na pewno chcesz wykonać daną operację"
	echo "Musisz jednak pamiętać, że każda kolejna biblioteka wymaga poprzednich :)"
	echo "Logi z kompilacji znajdziesz w katalogu log. stderr to konsola"
	echo "To powinno zwiększyć czytelność"
	echo
	echo "EXIT - oznacza, że skrypt zakończył się w przewidzianym momencie"
	echo 
	echo "Wymagania:"
	echo "* INZA 2.5.x (z innymi nie testowano) w domyślnej lokalizacji /nz/export/ae"
	echo "* Połączenie z internetem"
	echo
	echo "EXIT"
	exit 1
fi

if [ "$1" == "install" ]; then
	if [ "$#" -ne 2 ]; then
		echo "Musisz podać install_path. (./main_installer.sh help)"
		echo "EXIT"
		exit 1;
	fi
	if [ ! -d $2 ]; then
		echo "$2 musi być zapisywalny!"
		echo "EXIT"
		exit 1;
	fi
	INSTALL_DIR=$2
	echo "Katalog instalacji: $INSTALL_DIR"
	echo "No to zaczynamy!"
	read -p "Pytanie 1: Czy wyrażasz zgodę na chmod -R +x `pwd`? [y/n]: " choice
	case "$choice" in
		y|Y ) echo "Nadano uprawnienia +x do wszystkich plików `pwd`"; chmod -R +x . ;;
		n|N ) echo "EXIT"; exit 1;;
		* ) echo "invalid"; exit 1 ;;
	esac
	./subscripts/install/install.sh "$INSTALL_DIR"
	echo "EXIT"
	exit 1
fi