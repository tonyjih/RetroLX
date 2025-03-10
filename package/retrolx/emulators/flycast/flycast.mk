################################################################################
#
# FLYCAST
#
################################################################################
# Version.: Release on Aug 30, 2021
FLYCAST_VERSION = v1.1
FLYCAST_SITE = https://github.com/flyinghead/flycast.git
FLYCAST_SITE_METHOD=git
FLYCAST_GIT_SUBMODULES=YES
FLYCAST_LICENSE = GPLv2
FLYCAST_DEPENDENCIES = sdl2 libpng libzip

FLYCAST_PKG_DIR = $(TARGET_DIR)/opt/retrolx/flycast
FLYCAST_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/flycast

ifeq ($(BR2_PACKAGE_UDEV),y)
	FLYCAST_DEPENDENCIES += udev
endif

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_X86_64),y)
	FLYCAST_PLATFORM = x64
endif

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_X86),y)
	FLYCAST_PLATFORM = x86
endif

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_EXYNOS5422),y)
	FLYCAST_PLATFORM = odroidxu3
	FLYCAST_EXTRA_ARGS += USE_SDL=1 USE_SDLAUDIO=1
endif

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S905)$(BR2_PACKAGE_RETROLX_TARGET_H5)$(BR2_PACKAGE_RETROLX_TARGET_H616),y)
	FLYCAST_PLATFORM = odroidc2
	FLYCAST_EXTRA_ARGS += USE_SDLAUDIO=1
endif

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_H6),y)
	FLYCAST_PLATFORM = rpi3-64-mesa
	FLYCAST_EXTRA_ARGS += USE_SDLAUDIO=1
endif

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S905GEN3),y)
	FLYCAST_PLATFORM = odroidc4
	FLYCAST_EXTRA_ARGS += USE_SDLAUDIO=1
endif

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S922X),y)
	FLYCAST_PLATFORM = odroidn2
	FLYCAST_EXTRA_ARGS += USE_SDLAUDIO=1
endif

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI3),y)
    ifeq ($(BR2_aarch64),y)
	    FLYCAST_PLATFORM = rpi3-64-mesa
    else
        FLYCAST_PLATFORM = rpi3-mesa
    endif
	FLYCAST_EXTRA_ARGS += USE_SDL=1 USE_SDLAUDIO=1
endif

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI4),y)
	FLYCAST_PLATFORM = rpi4-64-mesa
	FLYCAST_EXTRA_ARGS += USE_SDL=1 USE_SDLAUDIO=1
endif

ifeq ($(BR2_PACKAGE_RETROLX_ROCKCHIP_ANY),y)
ifeq ($(BR2_ARCH_IS_64),y)
	FLYCAST_PLATFORM = arm64
	FLYCAST_EXTRA_ARGS += USE_GLES=1
else
	FLYCAST_PLATFORM = rockchip
endif
	FLYCAST_EXTRA_ARGS += USE_SDL=1 USE_SDLAUDIO=1
endif

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S812)$(BR2_PACKAGE_RETROLX_TARGET_AW32),y)
	FLYCAST_PLATFORM = armv7h neon
	FLYCAST_EXTRA_ARGS += USE_GLES=1
	FLYCAST_EXTRA_ARGS += USE_SDL=1 USE_SDLAUDIO=1
endif

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S912)$(BR2_PACKAGE_RETROLX_TARGET_S905GEN2),y)
	FLYCAST_PLATFORM = arm64
	FLYCAST_EXTRA_ARGS += USE_GLES=1
	FLYCAST_EXTRA_ARGS += USE_SDL=1 USE_SDLAUDIO=1
endif

ifeq ($(BR2_PACKAGE_HAS_LIBMALI),y)
FLYCAST_EXTRA_ARGS += EXTRAFLAGS=-Wl,-lmali
endif

define FLYCAST_UPDATE_INCLUDES
	sed -i "s+/opt/vc+$(STAGING_DIR)/usr+g" $(@D)/shell/linux/Makefile
	sed -i "s+sdl2-config+$(STAGING_DIR)/usr/bin/sdl2-config+g" $(@D)/shell/linux/Makefile
endef

define FLYCAST_HACK_X11
	sed -i "s+\`pkg-config --cflags x11\`++g" $(@D)/shell/linux/Makefile
	sed -i "s+\`pkg-config --libs x11\`+-lX11+g" $(@D)/shell/linux/Makefile
endef

FLYCAST_PRE_CONFIGURE_HOOKS += FLYCAST_UPDATE_INCLUDES
FLYCAST_PRE_CONFIGURE_HOOKS += FLYCAST_HACK_X11

define FLYCAST_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/shell/linux -f Makefile \
		platform="$(FLYCAST_PLATFORM)" $(FLYCAST_EXTRA_ARGS)
endef

define FLYCAST_INSTALL_TARGET_CMDS
endef

define FLYCAST_MAKEPKG
	# Create directories
	mkdir -p $(FLYCAST_PKG_DIR)$(FLYCAST_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D -m 0755 $(@D)/shell/linux/nosym-flycast.elf $(FLYCAST_PKG_DIR)$(FLYCAST_PKG_INSTALL_DIR)/flycast

	# Build Pacman package
	cd $(FLYCAST_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/flycast/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

FLYCAST_POST_INSTALL_TARGET_HOOKS = FLYCAST_MAKEPKG

$(eval $(generic-package))

