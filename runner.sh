#!/bin/bash


export PLATFORM_VERSION=13
export ANDROID_MAJOR_VERSION=t
export ARCH=arm64

export KBUILD_BUILD_USER="@Mizumo_prjkt"
export KBUILD_BUILD_HOST="MizProject (MIZPRJKT)"
export LLVM=1

# make ARCH=arm64 exynos850-a12snsxx_defconfig
# make ARCH=arm64 -j64



build_kernel() {
    make clean && make mrproper
    make -j64  KCFLAGS=-w CONFIG_SECTION_MISMATCH_WARN_ONLY=y ARCH=arm64 mizkernel-a12snsxx_defconfig
    make -j64  KCFLAGS=-w CONFIG_SECTION_MISMATCH_WARN_ONLY=y ARCH=arm64 
}

menuconfig_summon() {
    make menuconfig
}

case "$1" in
    "build")
        build_kernel
        ;;
    "menuconfig")
        menuconfig_summon
        ;;
    *)
        echo "Usage: $0 {build|menuconfig}"
        exit 1
        ;;
esac