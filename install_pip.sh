#!/bin/sh

mkdir /tmp/pip
wget --no-check-certificate https://bootstrap.pypa.io/2.6/get-pip.py -O /tmp/pip/get-pip.py
python /tmp/pip/get-pip.py
rm -rf /tmp/pip