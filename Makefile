include $(TOPDIR)/rules.mk

PKG_NAME:=qmodem
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/qmodem
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=QModem Utility
  DEPENDS:=+libserial +libubus +libblobmsg-json
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./application/src/* $(PKG_BUILD_DIR)/
	$(CP) ./application/include/* $(PKG_BUILD_DIR)/
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS) -I$(PKG_BUILD_DIR)"
endef

define Package/qmodem/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/main $(1)/usr/bin/qmodem
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./application/config/qmodem.conf $(1)/etc/config/qmodem
endef

$(eval $(call BuildPackage,qmodem))
