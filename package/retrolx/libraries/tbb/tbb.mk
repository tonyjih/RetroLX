################################################################################
#
# TBB
#
################################################################################

TBB_VERSION = v2021.3.0
TBB_SITE =  $(call github,oneapi-src,oneTBB,$(TBB_VERSION))
TBB_INSTALL_STAGING = YES

TBB_CONF_OPTS = -DTBB_TEST=OFF -DTBB_STRICT=OFF

$(eval $(cmake-package))
