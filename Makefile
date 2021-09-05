TARGET := iphone:clang:latest:13.0
ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Electrode

Electrode_FILES = Tweak.x UIToastView.m UIToastWindow.m UIBatteryToastView.m UITypingToastView.m IMCore.x
Electrode_FRAMEWORKS = UIKit CoreGraphics
Electrode_PRIVATE_FRAMEWORKS = MaterialKit UIKitCore BatteryCenter BatteryCenterUI Contacts ContactsUI IMCore
Electrode_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += electrodeprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
