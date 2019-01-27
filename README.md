# HD_Python_Libs_Installation
Installer that makes easy installation process of additional python libs in Netezza env. Installer also fix zlib error while importing packages in python scripts and will correct sha versions available in Python. Tested on Netezza Software Emulator 7.2.1.

## Libraries list
* lapack 3.8.0 (compilation will be used for numpy installation)
* numpy 1.10.4
* scipy 0.18.1 (presents as 1.13)
* sscikit-learn 1.16.1

## Quick Start Guide

1. Install a INZA ([here is a great tutorial](https://www.ibm.com/developerworks/community/groups/service/html/communityview?communityUuid=266888e9-4b4b-44cd-bd51-e32d05da9143#fullpageWidgetId=Wf1f7a753939e_4e8b_b2f5_c349f2f91dbb&file=fa5083ff-a471-49e5-b4a5-2c1415393faf))
2. Place files to /export/home/nz/nz_scripts in your Netezza.
3. Run installer with code below:
```shell
su root
<type root password>
mkdir /export/home/nz/instalation
./main_installer.sh /export/home/nz/instalation
exit
```

## Caution

There are some little bugs with error dealing.
