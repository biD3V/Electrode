TARGET := iphone:clang:latest:13.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ElectrodePrefs

ElectrodePrefs_FILES = $(wildcard *.m)
ElectrodePrefs_FRAMEWORKS = UIKit
ElectrodePrefs_PRIVATE_FRAMEWORKS = Preferences
ElectrodePrefs_INSTALL_PATH = /Library/PreferenceBundles
ElectrodePrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
