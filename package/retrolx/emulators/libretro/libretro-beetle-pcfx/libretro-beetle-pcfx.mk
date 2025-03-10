################################################################################
#
# BEETLE_PCFX
#
################################################################################
# Version.: Commits on Oct 3, 2021
LIBRETRO_BEETLE_PCFX_VERSION = a1f1734509dd6acb11269f118d61f480ae8dbacf
LIBRETRO_BEETLE_PCFX_SITE = $(call github,libretro,beetle-pcfx-libretro,$(LIBRETRO_BEETLE_PCFX_VERSION))
LIBRETRO_BEETLE_PCFX_LICENSE = GPLv2

LIBRETRO_BEETLE_PCFX_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_BEETLE_PCFX_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-beetle-pcfx

LIBRETRO_BEETLE_PCFX_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S922X),y)
LIBRETRO_BEETLE_PCFX_PLATFORM = CortexA73_G12B

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3326),y)
LIBRETRO_BEETLE_PCFX_PLATFORM = RK3326

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3399),y)
LIBRETRO_BEETLE_PCFX_PLATFORM = rpi4

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK356X),y)
LIBRETRO_BEETLE_PCFX_PLATFORM = SM1

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI3),y)
LIBRETRO_BEETLE_PCFX_PLATFORM = S905

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S905)$(BR2_PACKAGE_RETROLX_TARGET_RK3328)$(BR2_PACKAGE_RETROLX_TARGET_H5),y)
LIBRETRO_BEETLE_PCFX_PLATFORM = S905

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_H6),y)
LIBRETRO_BEETLE_PCFX_PLATFORM = S905

#hack
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S912)$(BR2_PACKAGE_RETROLX_TARGET_S905GEN2),y)
LIBRETRO_BEETLE_PCFX_PLATFORM = S905

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_H616),y)
LIBRETRO_BEETLE_PCFX_PLATFORM = S905

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S905GEN3),y)
LIBRETRO_BEETLE_PCFX_PLATFORM = SM1

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S812),y)
LIBRETRO_BEETLE_PCFX_PLATFORM = armv
endif

define LIBRETRO_BEETLE_PCFX_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D) platform="$(LIBRETRO_BEETLE_PCFX_PLATFORM)"
endef

define LIBRETRO_BEETLE_PCFX_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_BEETLE_PCFX_PKG_DIR)$(LIBRETRO_BEETLE_PCFX_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/mednafen_pcfx_libretro.so \
	$(LIBRETRO_BEETLE_PCFX_PKG_DIR)$(LIBRETRO_BEETLE_PCFX_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_BEETLE_PCFX_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-beetle-pcfx/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_BEETLE_PCFX_POST_INSTALL_TARGET_HOOKS = LIBRETRO_BEETLE_PCFX_MAKEPKG

$(eval $(generic-package))
