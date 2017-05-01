include $(THEOS)/makefiles/common.mk

TWEAK_NAME = 3DSwitcher2
3DSwitcher2_FILES = Tweak.xm CS3DSwitcherViewController.mm CS3DSwitcherPageScrollView.mm CS3DSwitcherPageView.mm
3DSwitcher2_FRAMEWORKS = UIKit CoreGraphics QuartzCore
3DSwitcher2_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

SUBPROJECTS = 3dswitcher
include $(THEOS_MAKE_PATH)/aggregate.mk
