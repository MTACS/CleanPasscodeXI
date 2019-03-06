include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = cpxiprefs
cpxiprefs_FILES = mtcRootListController.m
cpxiprefs_INSTALL_PATH = /Library/PreferenceBundles
cpxiprefs_FRAMEWORKS = UIKit
cpxiprefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/cpxiprefs.plist$(ECHO_END)
