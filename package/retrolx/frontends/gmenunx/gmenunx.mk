#############################################################
#
# GMENUNX
#
#############################################################
GMENUNX_VERSION = 47973316bd0444de3c54826674e97b89eb992a1a
GMENUNX_SITE_METHOD = git
GMENUNX_SITE = https://github.com/pingflood/gmenunx
GMENUNX_LICENSE = GPL-2.0

GMENUNX_DEPENDENCIES = sdl sdl_ttf sdl_gfx dejavu libpng fonts-droid

GMENUNX_CONF_OPTS = -DBIND_CONSOLE=ON

ifeq ($(BR2_PACKAGE_GMENUNX_SHOW_CLOCK),y)
GMENUNX_CONF_OPTS += -DCLOCK=ON
else
GMENUNX_CONF_OPTS += -DCLOCK=OFF
endif

ifeq ($(BR2_PACKAGE_GMENUNX_CPUFREQ),y)
GMENUNX_CONF_OPTS += -DCPUFREQ=ON
else
GMENUNX_CONF_OPTS += -DCPUFREQ=OFF
endif

GMENUNX_CONF_OPTS += -DSCREEN_WIDTH=240 -DSCREEN_HEIGHT=240 -DSCREEN_DEPTH=16

ifeq ($(BR2_PACKAGE_LIBOPK),y)
GMENUNX_DEPENDENCIES += libopk
endif

ifeq ($(BR2_PACKAGE_LIBXDGMIME),y)
GMENUNX_DEPENDENCIES += libxdgmime
endif

define GMENUNX_CONFIGURE_CMDS
    echo "No configure"
endef

define GMENUNX_BUILD_CMDS
	cd $(@D) && make -f Makefile.linux
endef

$(eval $(autotools-package))
