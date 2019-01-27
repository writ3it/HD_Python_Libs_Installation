#!/bin/sh
echo 
if [ `whoami` != "root" ]; then
	echo "Zaloguj się na roota!"
	exit 1
fi
if [ "$1" == "install" ]; then
        cp /nz/export/ae/languages/python/2.6/host/lib/python2.6/lib-dynload/zlib.so /nz/export/ae/languages/python/2.6/spu/lib/python2.6/lib-dynload/
        cp /nz/export/ae/languages/python/2.6/spu/lib/python2.6/lib-dynload/_md5.so /nz/export/ae/languages/python/2.6/host/lib/python2.6/lib-dynload/
        cp /nz/export/ae/languages/python/2.6/spu/lib/python2.6/lib-dynload/_sha.so /nz/export/ae/languages/python/2.6/host/lib/python2.6/lib-dynload/
fi