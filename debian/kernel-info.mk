########################################################################
# Kernel settings
########################################################################

# Kernel variant. This is currently used only on the Source package name.
# Use 'android' for Android kernels ("downstream") or 'mainline' for upstream
# kernels.
VARIANT = android

# Kernel base version. Use proper X.Y.Z form (4.19.113, dots not dashes)
# so the resulting KERNELRELEASE = "4.19.113-samsung-gts7xlwifi" has a
# 'Linux version 4.19.113-...' banner matching the upstream Linux
# version-string format that Samsung ABL may pattern-check against.
KERNEL_BASE_VERSION = 4.19.113

# Match the TWRP / stock cmdline byte-for-byte. Droidian-specific tokens
# (loop.max_part, droidian.lvm.prefer, etc) are appended by initramfs / late
# boot, not required in the kernel-side cmdline. Samsung ABL doesn't parse
# the cmdline but matching reduces variables when debugging.
KERNEL_BOOTIMAGE_CMDLINE = console=null androidboot.hardware=qcom androidboot.memcg=1 lpm_levels.sleep_disabled=1 video=vfb:640x400,bpp=32,memsize=3072000 msm_rtb.filter=0x237 service_locator.enable=1 swiotlb=2048 firmware_class.path=/vendor/firmware_mnt androidboot.usbcontroller=a600000.dwc3 buildvariant=eng androidboot.selinux=permissive

# Slug for the device vendor.
DEVICE_VENDOR = samsung

# Slug for the device model.
DEVICE_MODEL = gts7xlwifi

# Slug for the device platform.
DEVICE_PLATFORM = kona

# Marketing-friendly full-name.
DEVICE_FULL_NAME = Samsung Galaxy Tab S7+ Wi-Fi

# Whether to use configuration fragments to augment the kernel configuration.
KERNEL_CONFIG_USE_FRAGMENTS = 1

# Whether to use diffconfig to generate the device-specific configuration.
KERNEL_CONFIG_USE_DIFFCONFIG = 0

KERNEL_CONFIG_EXTRA_FRAGMENTS = extra.config

# Defconfig: ianmacd's caliban variant (the one his accepted TWRP kernel uses).
# Differences from the openx variant include: SELinux default (not AppArmor),
# CONFIG_BUILD_ARM64_UNCOMPRESSED_KERNEL=y, CRYPTO_FIPS, CFQ I/O sched.
# Hypothesis: matching the defconfig may match the ABL-acceptable kernel build.
KERNEL_DEFCONFIG = vendor/gts7xl_eur_openx_caliban_defconfig

# Whether to include DTBs with the image.
KERNEL_IMAGE_WITH_DTB = 1

# Path to the DTB. Samsung kernel produces multiple kona SoC revs.
KERNEL_IMAGE_DTB = arch/arm64/boot/dts/vendor/qcom/*.dtb

# Whether to include a DTB Overlay.
KERNEL_IMAGE_WITH_DTB_OVERLAY = 1

# Path to the DTB overlay. Samsung gts7xlwifi ships HW rev overlays.
KERNEL_IMAGE_DTB_OVERLAY = arch/arm64/boot/dts/samsung/gts7xl/*.dtbo

# Whether to include the DTB Overlay into the kernel image.
KERNEL_IMAGE_WITH_DTB_OVERLAY_IN_KERNEL = 0

# Various other settings that will be passed straight to mkbootimg.
# These MUST match the values in TWRP (which Samsung ABL accepts).
KERNEL_BOOTIMAGE_PAGE_SIZE = 4096
KERNEL_BOOTIMAGE_BASE_OFFSET = 0x00000000
KERNEL_BOOTIMAGE_KERNEL_OFFSET = 0x00008000
KERNEL_BOOTIMAGE_INITRAMFS_OFFSET = 0x02000000
KERNEL_BOOTIMAGE_SECONDIMAGE_OFFSET = 0x00f00000
KERNEL_BOOTIMAGE_TAGS_OFFSET = 0x01e00000
KERNEL_BOOTIMAGE_DTB_OFFSET = 0x01f00000

# Samsung-recognized board name (matches TWRP header byte-for-byte).
KERNEL_BOOTIMAGE_BOARD = SRPTC16A002

# Kernel bootimage version. Tab S7+ ships v2.
KERNEL_BOOTIMAGE_VERSION = 2

# Match TWRP os_version (Android 12 + 2022-05 SPL).
KERNEL_BOOTIMAGE_OS_VERSION = 12.0.0
KERNEL_BOOTIMAGE_OS_PATCH_LEVEL = 2022-05

########################################################################
# Android verified boot
########################################################################

DEVICE_VBMETA_REQUIRED = 1
DEVICE_VBMETA_IS_SAMSUNG = 1

########################################################################
# Automatic flashing on package upgrades
########################################################################

FLASH_ENABLED = 1
FLASH_IS_AONLY = 1
FLASH_IS_LEGACY_DEVICE = 0

FLASH_INFO_MANUFACTURER = samsung
FLASH_INFO_MODEL = SM-T970
FLASH_INFO_CPU = Qualcomm Technologies, Inc KONA
FLASH_INFO_DEVICE_IDS = SM-T970 SM-T975 SM-T976 SM-T976B gts7xlwifi gts7xl

########################################################################
# Kernel build settings
########################################################################

BUILD_CROSS = 1
BUILD_TRIPLET = aarch64-linux-android-
BUILD_CLANG_TRIPLET = aarch64-linux-gnu-

# Samsung-downstream kernel was originally built with clang 13 per its
# defconfig (CC_IS_CLANG=y, CLANG_VERSION=130000). Use our packaged
# clang-android-14 toolchain.
BUILD_CC = clang
CLANG_CUSTOM = 1
# Use clang+LLVM 10.0.0 prebuilt (matches ianmacd's TWRP build exactly).
# Downloaded by CI workflow to /build/sources/clang10/bin before container start.
BUILD_PATH = /build/sources/clang10/bin

# Tolerate Samsung-downstream -Werror strictness mismatches with newer clang.
KERNEL_BUILD_FLAGS = KCFLAGS="-Wno-error=unused-variable -Wno-error=unused-function -Wno-error=unused-const-variable -Wno-error=implicit-function-declaration -Wno-error=int-conversion -Wno-error=incompatible-pointer-types -Wno-error=address-of-packed-member -Wno-error=strict-prototypes -fno-builtin-stpcpy"

DEB_TOOLCHAIN = device-tree-compiler, linux-initramfs-halium-generic:arm64, binutils-aarch64-linux-gnu, clang-android-14.0-r450784d, gcc-4.9-aarch64-linux-android, g++-4.9-aarch64-linux-android, libgcc-4.9-dev-aarch64-linux-android-cross, curl, ca-certificates

DEB_BUILD_ON = amd64
DEB_BUILD_FOR = arm64

KERNEL_ARCH = arm64

# Samsung sm8250 produces Image (uncompressed).
KERNEL_BUILD_TARGET = Image
