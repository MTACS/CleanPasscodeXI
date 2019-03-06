export THEOS_DEVICE_IP = 10.0.0.151

DEBUG = 0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CleanPasscodeXI
CleanPasscodeXI_FILES = Tweak.xm
CleanPasscodeXI_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += cpxiprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
