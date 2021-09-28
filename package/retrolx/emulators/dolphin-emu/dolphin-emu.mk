################################################################################
#
# DOLPHIN EMU
#
################################################################################
# Version: Commits on Sep 03, 2021 - 5.0-15015
DOLPHIN_EMU_VERSION = 4b8b53ac732645f6c0fd3f4b11733cb3d86c9c41
DOLPHIN_EMU_SITE = $(call github,dolphin-emu,dolphin,$(DOLPHIN_EMU_VERSION))
DOLPHIN_EMU_LICENSE = GPLv2+
DOLPHIN_EMU_DEPENDENCIES = libevdev ffmpeg zlib libpng lzo libusb libcurl bluez5_utils hidapi xz host-xz

DOLPHIN_EMU_PKG_DIR = $(TARGET_DIR)/opt/retrolx/dolphin
DOLPHIN_EMU_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/dolphin

DOLPHIN_EMU_SUPPORTS_IN_SOURCE_BUILD = NO

DOLPHIN_EMU_CONF_OPTS  = -DTHREADS_PTHREAD_ARG=OFF
DOLPHIN_EMU_CONF_OPTS += -DUSE_DISCORD_PRESENCE=OFF
DOLPHIN_EMU_CONF_OPTS += -DBUILD_SHARED_LIBS=OFF
DOLPHIN_EMU_CONF_OPTS += -DDISTRIBUTOR='RetroLX'
DOLPHIN_EMU_CONF_OPTS += -DUSE_MGBA=OFF

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_X86_64),y)
DOLPHIN_EMU_DEPENDENCIES += xserver_xorg-server qt5base
DOLPHIN_EMU_CONF_OPTS += -DENABLE_NOGUI=OFF
DOLPHIN_EMU_CONF_OPTS += -DENABLE_EGL=OFF
endif

ifeq ($(BR2_PACKAGE_RETROLX_QT),y)
DOLPHIN_EMU_DEPENDENCIES += qt5base
DOLPHIN_EMU_CONF_OPTS += -DENABLE_QT=ON
DOLPHIN_EMU_CONF_OPTS += -DENABLE_EGL=ON
DOLPHIN_EMU_CONF_OPTS += -DENABLE_LTO=ON
endif

# Install into package prefix
DOLPHIN_EMU_MAKE_OPTS += DESTDIR="$(DOLPHIN_EMU_PKG_DIR)"
DOLPHIN_EMU_INSTALL_TARGET_OPTS = DESTDIR="$(DOLPHIN_EMU_PKG_DIR)$(DOLPHIN_EMU_PKG_INSTALL_DIR)" install

define DOLPHIN_EMU_MAKEPKG
	# Build Pacman package
	cd $(DOLPHIN_EMU_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/dolphin-emu/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

DOLPHIN_EMU_POST_INSTALL_TARGET_HOOKS = DOLPHIN_EMU_MAKEPKG

$(eval $(cmake-package))
