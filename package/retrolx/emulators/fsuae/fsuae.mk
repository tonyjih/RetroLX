################################################################################
#
# FSUAE
#
################################################################################
# Version.: Commits on Oct 10, 2021 (4.0.x)
FSUAE_VERSION = f00b12db92ea40a87edb2d0ffae92e8d8196479c
FSUAE_SITE = $(call github,FrodeSolheim,fs-uae,$(FSUAE_VERSION))
FSUAE_LICENSE = GPLv2
FSUAE_DEPENDENCIES = openal libpng sdl2 zlib libmpeg2 libglib2 libcapsimage

ifeq ($(BR2_x86_64)$(BR2_i686),y)
FSUAE_DEPENDENCIES += xserver_xorg-server
else ifeq ($(BR2_arm),y)
FSUAE_CONF_OPTS += --disable-jit --without-opengl
#FSUAE_CONF_ENV  += OPENGL_LIBS="-lEGL -lGLESv2"
FSUAE_CONF_ENV += CFLAGS="-DSUPPORT_XINPUT2=0"
else ifeq($(BR2_aarch64),y)
FSUAE_CONF_OPTS += --disable-jit --without-opengl
#FSUAE_CONF_ENV  += OPENGL_LIBS="-lEGL -lGLESv2"
FSUAE_CONF_ENV += CFLAGS="-DSUPPORT_XINPUT2=0"
endif

FSUAE_CONF_OPTS += --disable-codegen

define FSUAE_HOOK_BOOTSTRAP
  cd $(@D) && ./bootstrap
endef

FSUAE_PRE_CONFIGURE_HOOKS += FSUAE_HOOK_BOOTSTRAP

$(eval $(autotools-package))
