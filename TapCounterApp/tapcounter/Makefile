include theos/makefiles/common.mk

export TARGET=iphone:latest:5.0
export ARCHS = armv7

SHARED_CFLAGS = -fobjc-arc

APPLICATION_NAME = TapCounter

TapCounter_FILES = main.m CUBAppDelegate.m CUBRootViewController.m

TapCounter_FRAMEWORKS = UIKit CoreGraphics IOKit QuartzCore
TapCounter_CFLAGS = -I/opt/PrivateHeaders

include $(THEOS_MAKE_PATH)/application.mk