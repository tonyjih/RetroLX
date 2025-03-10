################################################################################
#
# drastic
#
################################################################################

DRASTIC_VERSION = 1.0
DRASTIC_SOURCE = drastic.tar.gz
DRASTIC_SITE = https://github.com/liberodark/drastic/releases/download/$(DRASTIC_VERSION)

define DRASTIC_EXTRACT_CMDS
	mkdir -p $(@D)/target && cd $(@D)/target && tar xf $(DL_DIR)/$(DRASTIC_DL_SUBDIR)/$(DRASTIC_SOURCE)
endef

ifeq ($(BR2_cortex_a35),y)
DRASTIC_BINARYFILE=drastic_oga
else ifeq ($(BR2_aarch64),y)
DRASTIC_BINARYFILE=drastic_n2
endif

define DRASTIC_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/bin/
	mkdir -p $(TARGET_DIR)/usr/share/
	mkdir -p $(TARGET_DIR)/usr/share/evmapy

	install -m 0755 $(@D)/target/$(DRASTIC_BINARYFILE) $(TARGET_DIR)/usr/bin/drastic
	cp -pr $(@D)/target/drastic $(TARGET_DIR)/usr/share/drastic

	# evmap config
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/drastic/controllers/nds.drastic.keys $(TARGET_DIR)/usr/share/evmapy
endef

$(eval $(generic-package))
