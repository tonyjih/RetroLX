################################################################################
#
# VBA-M
#
################################################################################
# Version.: Commits on Jul 23, 2021
LIBRETRO_VBA_M_VERSION = 96ce316bcd159253e9f724a807fb23af5f51706c
LIBRETRO_VBA_M_SITE = $(call github,visualboyadvance-m,visualboyadvance-m,$(LIBRETRO_VBA_M_VERSION))

LIBRETRO_VBA_M_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_VBA_M_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-vba-m

define LIBRETRO_VBA_M_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/src/libretro -f Makefile platform="unix"
endef

define LIBRETRO_VBA_M_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_VBA_M_PKG_DIR)$(LIBRETRO_VBA_M_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/src/libretro/vbam_libretro.so \
	$(LIBRETRO_VBA_M_PKG_DIR)$(LIBRETRO_VBA_M_PKG_INSTALL_DIR)/vba-m_libretro.so

	# Build Pacman package
	cd $(LIBRETRO_VBA_M_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-vba-m/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_VBA_M_POST_INSTALL_TARGET_HOOKS = LIBRETRO_VBA_M_MAKEPKG

$(eval $(generic-package))
