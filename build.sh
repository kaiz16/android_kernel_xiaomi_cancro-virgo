#!/bin/sh
CODENAME=cancro
DEFCONFIG=virgo_defconfig
OBJ_DIR=`pwd`/.obj
TOOLCHAIN=${HOME}/toolchains/arm-eabi-5.x/bin/arm-eabi-
DATE=$(date +"%d-%b-%Y")

if [ ! -d ${OBJ_DIR} ]; then
    mkdir ${OBJ_DIR}
else
    rm -rf ${OBJ_DIR}
    make clean && make mrproper
    mkdir ${OBJ_DIR}
fi

make ARCH=arm O=$OBJ_DIR CROSS_COMPILE=${TOOLCHAIN} $DEFCONFIG
make CONFIG_NO_ERROR_ON_MISMATCH=y -j$(grep -c ^processor /proc/cpuinfo) ARCH=arm O=$OBJ_DIR CROSS_COMPILE=${TOOLCHAIN}

if [ ! -f ${OBJ_DIR}/arch/arm/boot/zImage-dtb ]; then
    echo "	Build failed. Check your errors."
else
    cp ${OBJ_DIR}/arch/arm/boot/zImage-dtb ~/AnyKernel3-cancro
    cd ~/AnyKernel3-cancro
    zip -r9 LegionKernel-$CODENAME-$DATE.zip * -x LegionKernel-* .git README.md *placeholder
fi
