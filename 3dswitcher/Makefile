ARCHS = armv7 arm64
include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = 3DSwitcher
3DSwitcher_FILES = 3DSwitcher.mm CS3DSwitcherLogoCell.mm CS3DSwitcherEasterEgg.mm
3DSwitcher_INSTALL_PATH = /Library/PreferenceBundles
3DSwitcher_FRAMEWORKS = UIKit Twitter
3DSwitcher_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/3DSwitcher.plist$(ECHO_END)
