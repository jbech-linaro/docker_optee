#!/bin/bash -ex
# This script is used to fetch the complete source for linux build

echo -e "\n+++++++++++++++++++++++++++++++++++++++++++++++++"
echo -e "+++ Start fetching the source for linux build +++"
echo -e "+++                                           +++"
echo -e "+++ Tweaked for Docker                        +++"
echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++"
if [ -z "$WORKSPACE" ];then
	WORKSPACE=$PWD
	echo "Setting WORKSPACE to $WORKSPACE"
fi

if [ -z "$linux_builddir" ];then
    	linux_builddir=$WORKSPACE/linux_build
    	echo "Setting linux_builddir to $linux_builddir"
fi

if [ -z "$BASEDIR" ];then
    	BASEDIR=`readlink -f $BASH_SOURCE | xargs dirname`
    	echo "Setting BASEDIR to $BASEDIR"
fi

if [ ! -d "$linux_builddir" ]; then
	# Create linux build dir if it does not exist.
	mkdir $linux_builddir
	mkdir -p $linux_builddir/.repo/local_manifests
fi

cd $linux_builddir
# JBECH repo init -u https://source.codeaurora.org/external/imx/imx-manifest.git -b imx-linux-sumo -m imx-4.14.98-2.1.0.xml
repo init -u https://source.codeaurora.org/external/imx/imx-manifest.git -b imx-linux-sumo -m imx-4.14.98-2.1.0.xml --reference /home/optee/reference
rc=$?
if [ "$rc" != 0 ]; then
	echo -e "\n---------------------------"
	echo -e "---- Repo Init failure ----"
	echo -e "---------------------------"
	return 1
fi

echo -e "\n+++++++++++++++++++++++++++++++++++++++++++++"
echo -e "+++ Amend manifest with wpe and DRM repos +++"
echo -e "+++++++++++++++++++++++++++++++++++++++++++++"
if [ -f $BASEDIR/linux_drm.xml ]; then
	echo -e "\n+++ ->Add git repos to support DRM +++"
	cp -f $BASEDIR/linux_drm.xml $linux_builddir/.repo/local_manifests
fi
echo -e "\n+++ ->Add git repos to support WPE +++"
cp -f $BASEDIR/wpe.xml $linux_builddir/.repo/local_manifests

#rm -rf $linux_builddir/.??*
cd $linux_builddir

echo -e "\n+++++++++++++++++++++"
echo -e "+++ Sync the repo +++"
echo -e "+++++++++++++++++++++"
repo sync -j `nproc` -c --no-clone-bundle
rc=$?
if [ "$rc" != 0 ]; then
	echo -e "\n---------------------------"
	echo -e "---- Repo sync failure ----"
	echo -e "---------------------------"
        return 1
fi

echo -e "\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo -e "+++ Copy the proprietary packages to the linux build folder +++"
echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
#cp -r $BASEDIR/SCR* $linux_builddir
cp $BASEDIR/enable-drm.sh $linux_builddir
cp $BASEDIR/enable-wpe.sh $linux_builddir

if [ ! -f $BASEDIR/linux_drm.xml ]; then
	#Untar proprietary source code
	echo -e "\n+++ ->Use tarballs from delivery package +++"
	tar -zxvf $BASEDIR/yocto_source_code/meta-lhg-prop.tgz -C $linux_builddir/sources
	tar -zxvf $BASEDIR/yocto_source_code/meta-lhg.tgz -C $linux_builddir/sources
fi

echo -e "\n+++++++++++++++++++++++++"
echo -e "+++ Apply DRM patches +++"
echo -e "+++++++++++++++++++++++++"
$BASEDIR/apply-patches.sh -f $BASEDIR/meta-drm-patches/ -r $linux_builddir
if [ ! $? -eq 0 ]; then
	echo -e "\n-------------------------------------"
	echo -e "---- Failed to apply DRM patches ----"
	echo -e "-------------------------------------"
	return 1
fi

# unset variables
unset linux_builddir
unset WORKSPACE
unset BASEDIR

echo -e "\n+++++++++++++++++++++++++++++++++++++++++++++"
echo -e "++++ Linux source is ready for the build ++++"
echo -e "+++++++++++++++++++++++++++++++++++++++++++++"

