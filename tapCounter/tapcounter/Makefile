include theos/makefiles/common.mk
export TARGET=iphone:latest:5.0
export ARCHS = armv7

SHARED_CFLAGS = -fobjc-arc

TOOL_NAME = tapCounter
tapCounter_FILES = main.m
tapCounter_FRAMEWORKS = IOKit
tapCounter_CFLAGS = -I/opt/PrivateHeaders
LOCAL_INSTALL_PATH = "/usr/bin"

include $(THEOS_MAKE_PATH)/tool.mk
include $(FW_MAKEDIR)/aggregate.mk