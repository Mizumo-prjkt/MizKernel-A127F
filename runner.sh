#!/bin/bash


export PLATFORM_VERSION=13
export ANDROID_MAJOR_VERSION=t
export ARCH=arm64

export KBUILD_BUILD_USER="@Mizumo_prjkt"
export KBUILD_BUILD_HOST="MizProject (MIZPRJKT)"
export LLVM=1

# make ARCH=arm64 exynos850-a12snsxx_defconfig
# make ARCH=arm64 -j64

ksu_symlink() {
    if [ ! -d "KernelSU-Next/kernel" ]; then
        echo "Empty KernelSU-Next/kernel directory, abort as extreme error"
        exit 9
    fi
    ln -sf $(pwd)/KernelSU-Next/kernel $(pwd)/drivers/kernelsu
    if [ $? -ne 0 ]; then
        echo "Failed to create symlink for KernelSU-Next/kernel"
        exit 1
    fi
}


submodule_summon() {
    git submodule update --init --recursive
}

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
        # Use ksu_symlink as always since object files are permanently configured
        # and to avoid future errors relating "missing file or foler"
        ksu_symlink
        if [ "$2" == "-submodule_summon" ]; then
            submodule_summon
        fi
            build_kernel
        ;;
    "menuconfig")
        menuconfig_summon
        ;;
    "submodule_summon")
        submodule_summon
        ;;
    *)
        echo "Usage: $0 {build (-submodule_summon)|menuconfig|submodule_summon}"
        exit 1
        ;;
esac