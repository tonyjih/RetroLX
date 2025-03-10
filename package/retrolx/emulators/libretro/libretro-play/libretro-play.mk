################################################################################
#
# PLAY
#
################################################################################

LIBRETRO_PLAY_VERSION = 0.45
LIBRETRO_PLAY_SITE = https://github.com/jpd002/Play-.git
LIBRETRO_PLAY_LICENSE = BSD
LIBRETRO_PLAY_DEPENDENCIES =

LIBRETRO_PLAY_SITE_METHOD = git
LIBRETRO_PLAY_GIT_SUBMODULES = YES

LIBRETRO_PLAY_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release
LIBRETRO_PLAY_CONF_OPTS += -DBUILD_SHARED_LIBS=ON
LIBRETRO_PLAY_CONF_OPTS += -DBUILD_TESTS=OFF
LIBRETRO_PLAY_CONF_OPTS += -DBUILD_LIBRETRO_CORE=ON
LIBRETRO_PLAY_CONF_OPTS += -DBUILD_PLAY=OFF

$(eval $(cmake-package))
