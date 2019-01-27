#!/bin/sh
echo "SETUPTOOLS"
pip install --upgrade pip setuptools wheel sortedcontainers
echo "Copy sortedcontainers to nz"
cp -R /usr/lib/python2.6/site-packages/sortedcontainers /nz/export/ae/languages/python/2.6/spu/lib/python2.6/
cp -R /usr/lib/python2.6/site-packages/sortedcontainers /nz/export/ae/languages/python/2.6/host/lib/python2.6/