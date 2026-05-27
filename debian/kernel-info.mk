########################################################################
# Kernel settings
########################################################################

# Kernel variant. This is currently used only on the Source package name.
# Use 'android' for Android kernels ("downstream") or 'mainline' for upstream
# kernels.
VARIANT = android

# Kernel base version
KERNEL_BASE_VERSION = 4.19-325

# The kernel cmdline to use
# Sony Sony-specific bits (buildid=EDO-..., oemboot.earlymount=/mnt/oem)
# removed. console=null matches what the device's stock TWRP boots with.
KERNEL_BOOTIMAGE_CMDLINE = console=null androidboot.hardware=qcom androidboot.memcg=1 lpm_levels.sleep_disabled=1 video=vfb:640x400,bpp=32,memsize=3072000 msm_rtb.filter=0x237 service_locator.enable=1 androidboot.usbcontroller=a600000.dwc3 swiotlb=2048 loop.max_part=7 cgroup.memory=nokmem,nosocket reboot=panic_warm buildproduct=gts7xlwifi droidian.lvm.prefer

# Slug for the device vendor. This is going to be used in the KERNELRELASE
# and package names.
DEVICE_VENDOR = samsung

# Slug for the device model. Like above.
DEVICE_MODEL = gts7xlwifi

# Slug for the device platform. If unsure, keep this commented.
DEVICE_PLATFORM = kona

# Marketing-friendly full-name. This will be used inside package descriptions
DEVICE_FULL_NAME = Samsung Galaxy Tab S7+ Wi-Fi

# Whether to use configuration fragments to augment the kernel configuration.
# If unsure, keep this to 0.
KERNEL_CONFIG_USE_FRAGMENTS = 1

# Whether to use diffconfig to generate the device-specific configuration.
# If you enable this, you should set KERNEL_CONFIG_USE_FRAGMENTS to 1.
# If unsure, keep this to 0.
KERNEL_CONFIG_USE_DIFFCONFIG = 0

KERNEL_CONFIG_EXTRA_FRAGMENTS = kona-sec-common.config gts7xlwifi.config extra.config

# The diffconfig to apply. Only used when KERNEL_CONFIG_USE_DIFFCONFIG is
# enabled.
#KERNEL_PRODUCT_DIFFCONFIG = $(DEVICE_MODEL)_diffconfig

# Defconfig to use
KERNEL_DEFCONFIG = vendor/kona-perf_defconfig

# Whether to include DTBs with the image. Use 0 (no) or 1.
KERNEL_IMAGE_WITH_DTB = 1

# Path to the DTB
# If you leave this undefined, an attempt to find it automatically
# will be made.
KERNEL_IMAGE_DTB = arch/arm64/boot/dts/vendor/qcom/*.dtb

# Whether to include a DTB Overlay. Use 0 (no) or 1.
KERNEL_IMAGE_WITH_DTB_OVERLAY = 1

# Path to the DTB overlay.
# Samsung gts7xlwifi ships EU HW revs r02..r06 as separate dtbo overlays.
KERNEL_IMAGE_DTB_OVERLAY = arch/arm64/boot/dts/samsung/gts7xl/*.dtbo

# Whether to include the DTB Overlay into the kernel image
# Use 0 (no, default) or 1.
# dtbo.img will always be shipped in the linux-bootimage- package.
KERNEL_IMAGE_WITH_DTB_OVERLAY_IN_KERNEL = 0

# Path to a specifc configuration file for mkdtboimg.
# The default is to leave it undefined.
#KERNEL_IMAGE_DTB_OVERLAY_CONFIGURATION = debian/custom_dtbo_config.cfg

# Path to the DTB directory. Only define if KERNEL_IMAGE_DTB_OVERLAY_CONFIGURATION
# is defined too.
#KERNEL_IMAGE_DTB_OVERLAY_DTB_DIRECTORY = arch/arm64/boot/dts/qcom

# Various other settings that will be passed straight to mkbootimg
KERNEL_BOOTIMAGE_PAGE_SIZE = 4096
KERNEL_BOOTIMAGE_BASE_OFFSET = 0x00000000
KERNEL_BOOTIMAGE_KERNEL_OFFSET = 0x00008000
KERNEL_BOOTIMAGE_INITRAMFS_OFFSET = 0x01000000
KERNEL_BOOTIMAGE_SECONDIMAGE_OFFSET = 0x00f00000
KERNEL_BOOTIMAGE_TAGS_OFFSET = 0x00000100
KERNEL_BOOTIMAGE_DTB_OFFSET = 0x01f00000

# Kernel bootimage version. Defaults to 0 (legacy header).
# As a rule of thumb:
# Devices launched with Android 8 and lower: version 0
# Devices launched with Android 9: version 1
# Devices launched with Android 10: version 2
# Devices launched with Android 11: version 2 or 3 (GKI)
KERNEL_BOOTIMAGE_VERSION = 2

########################################################################
# Android verified boot
########################################################################

# Whether to build a flashable vbmeta.img. Please note that currently
# only empty vbmeta images (disabling verified boot) can be generated.
# Use 0 (no) or 1 (default).
DEVICE_VBMETA_REQUIRED = 1

# Samsung devices require a special flag. Enable the following if your
# device is a Samsung device that requires flag 0 to be present
# Use 0 (no, default) or 1.
DEVICE_VBMETA_IS_SAMSUNG = 1

########################################################################
# Automatic flashing on package upgrades
########################################################################

# Whether to enable kernel upgrades on package upgrades. Use 0 (no) or 1.
FLASH_ENABLED = 1

# If your device is treble-ized, but aonly, you should set the following to
# 1 (yes). Tab S7+ is A-only (confirmed: no slot_suffix prop, single boot
# partition in PIT).
FLASH_IS_AONLY = 1

# `flash-bootimage` defaults are enough for most recent devices, but legacy
# devices won't work out of the box.
# If you set the following to 1, this package will set `flash-bootimage`'s
# DEVICE_IS_AB and BOOTIMAGE_SLOT_A accordingly, thus enabling flashing
# on older devices.
#
# Do not enable if you don't know what you're doing
FLASH_IS_LEGACY_DEVICE = 0


# Device specific: to accomodate the various device variants, always
# fallback to FLASH_INFO_CPU

# Device manufacturer. This must match the `ro.product.vendor.manufacturer`
# Android property.
FLASH_INFO_MANUFACTURER = samsung

# Device model. This must match the `ro.product.vendor.model`
# Android property. On SM-T970 the vendor model is SM-T970.
FLASH_INFO_MODEL = SM-T970

# Device CPU. Last-resort match against /proc/cpuinfo.
FLASH_INFO_CPU = Qualcomm Technologies, Inc KONA

# Space-separated list of supported device ids as reported by fastboot.
# Tab S7+ Wi-Fi (SM-T970) is the primary target; Tab S7+ LTE/5G variants
# (SM-T976B, SM-T975) share the kernel and DT and only differ at the modem.
FLASH_INFO_DEVICE_IDS = SM-T970 SM-T975 SM-T976 SM-T976B gts7xlwifi gts7xl

########################################################################
# Kernel build settings
########################################################################

# Whether to cross-build. Use 0 (no) or 1.
BUILD_CROSS = 1

# (Cross-build only) The build triplet to use. You'll probably want to
# use aarch64-linux-android- if building Android kernels.
BUILD_TRIPLET = aarch64-linux-android-

# (Cross-build only) The build triplet to use with clang. You'll probably
# want to use aarch64-linux-gnu- here.
BUILD_CLANG_TRIPLET = aarch64-linux-gnu-

# The compiler to use. Recent Android kernels are built with clang.
BUILD_CC = clang
CLANG_CUSTOM = 1

# Extra paths to prepend to the PATH variable. You'll probably want
# to specify the clang path here (the default).
BUILD_PATH = /usr/lib/llvm-android-14.0-r450784d/bin

# Allow the build to continue past Samsung-downstream / LineageOS-23.2
# strict -Werror=unused-variable on fs/f2fs/data.c:721 ('inode' unused on
# one path). Propagates into KBUILD_CFLAGS via the kernel's KCFLAGS hook.
KERNEL_BUILD_FLAGS = KCFLAGS="-Wno-error=unused-variable -Wno-error=unused-but-set-variable"

# Extra packages to add to the Build-Depends section. Mainline builds
# can have this section empty, unless cross-building.
# The default is enough to install the Android toolchain, including clang.
DEB_TOOLCHAIN = device-tree-compiler, linux-initramfs-halium-generic:arm64, binutils-aarch64-linux-gnu, clang-android-14.0-r450784d, gcc-4.9-aarch64-linux-android, g++-4.9-aarch64-linux-android, libgcc-4.9-dev-aarch64-linux-android-cross

# Where we're building on
DEB_BUILD_ON = amd64

# Where we're going to run this kernel on
DEB_BUILD_FOR = arm64

# Target kernel architecture
KERNEL_ARCH = arm64

# Kernel target to build. Samsung sm8250 produces Image (uncompressed);
# the LineageOS kernel does not enable CONFIG_KERNEL_GZ for the final image.
KERNEL_BUILD_TARGET = Image
