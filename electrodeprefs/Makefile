TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ElectrodePrefs

ElectrodePrefs_FILES = EDPRootListController.m
ElectrodePrefs_FRAMEWORKS = UIKit
ElectrodePrefs_PRIVATE_FRAMEWORKS = Preferences
ElectrodePrefs_INSTALL_PATH = /Library/PreferenceBundles
ElectrodePrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
