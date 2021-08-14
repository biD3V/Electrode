#import <UIKit/UIKit.h>
#import <SpringBoard/SpringBoard.h>
#import <SpringBoardUI/SBLowPowerAlertItem.h>
#import <SpringBoard/SBAlertItemsController.h>
#import <SpringBoard/SBDefaultIconModelStore.h>
#import "UIToastWindow.h"
#import "UIBatteryToastView.h"

@interface SpringBoard (Electrode)

@property (nonatomic,strong) UIWindow * toastWindow;

@end

BOOL autoHideLP;
BOOL autoHideCHRG;
BOOL autoLP;
NSArray<NSNumber *> *percentages;

static void reloadPrefs() {
    // Check if system app (all system apps have this as their home directory). This path may change but it's unlikely.
    BOOL isSystem = [NSHomeDirectory() isEqualToString:@"/var/mobile"];
    // Retrieve preferences
    NSDictionary* prefs = nil;
    if(isSystem) {
        CFArrayRef keyList = CFPreferencesCopyKeyList(CFSTR("com.bid3v.electrodeprefs"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
        if(keyList) {
            prefs = (NSDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, CFSTR("com.bid3v.electrodeprefs"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost));
            if(!prefs) prefs = [NSDictionary new];
            CFRelease(keyList);
        }
    }
    if (!prefs) {
        prefs = [NSDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.bid3v.electrodeprefs.plist"];
    }

    autoHideLP = prefs[@"autoHideLP"] ? [prefs[@"autoHideLP"] boolValue] : false;
    autoHideCHRG = prefs[@"autoHideCHRG"] ? [prefs[@"autoHideCHRG"] boolValue] : true;
    autoLP = prefs[@"autoLP"] ? [prefs[@"autoLP"] boolValue] : true;
    percentages = prefs[@"percentages"];
}

static NSString * EDLocalizedString(NSString *key) {
	NSBundle *ElectrodeBundle = [NSBundle bundleWithPath:@"Library/Application Support/Electrode"];
	return [ElectrodeBundle localizedStringForKey:key value:@"" table:nil];
}

%hook SpringBoard
%property (nonatomic,strong) UIToastWindow * toastWindow;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    %orig;
    self.toastWindow = [UIToastWindow sharedWindow];
    self.toastWindow.frame = [UIScreen mainScreen].bounds;
    self.toastWindow.backgroundColor = UIColor.clearColor;
    self.toastWindow.windowLevel = UIWindowLevelStatusBar;
    [self.toastWindow makeKeyAndVisible];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkLevel)
                                                 name:UIDeviceBatteryLevelDidChangeNotification
                                               object:nil];
}

%new
- (void)checkLevel {
    if ([UIDevice currentDevice].batteryState != UIDeviceBatteryStateUnplugged) return;
    for (NSNumber *percent in percentages) {
        if (([UIDevice currentDevice].batteryLevel * 100) == percent.floatValue) [[%c(SBAlertItemsController) sharedInstance] activateAlertItem:[%c(SBLowPowerAlertItem) new]];
    }
}

%end

// TODO: Find system notification for LP Alert and charging
%hook SBAlertItemsController
- (void)activateAlertItem:(id)item animated:(BOOL)animated {
	if ([item isKindOfClass:[%c(SBLowPowerAlertItem) class]]) {
		BCBatteryDevice *battery = [BCBatteryDeviceController sharedInstance].connectedDevices[0];
		UIBatteryToastView *toast = [[UIBatteryToastView alloc] initToastWithTitle:EDLocalizedString(@"LOW_BATTERY") subtitle:[NSString stringWithFormat:EDLocalizedString(@"BATT_REMAINING"), battery.percentCharge] autoHidden:autoHideLP];
		[toast presentToast];
        if (autoLP) [(SBLowPowerAlertItem *)item _enableLowPowerMode];
		return;
	}
	%orig;
}
%end

%hook SBUIController

- (void)ACPowerChanged {
	%orig;
	if ([self isOnAC]) {
		BCBatteryDevice *battery = [BCBatteryDeviceController sharedInstance].connectedDevices[0];
		UIBatteryToastView *toast = [[UIBatteryToastView alloc] initToastWithTitle:EDLocalizedString(@"CHARGING") subtitle:[NSString stringWithFormat:@"%ld%%", battery.percentCharge] autoHidden:autoHideCHRG];
		[toast presentToast];
        NSLog(@"[Electrode] Charging toast presented");
	}
}

%end

%ctor {
    // Filter out invalid appilcations
	if (![NSProcessInfo processInfo]) return;
    NSString* processName = [NSProcessInfo processInfo].processName;
    BOOL isSpringboard = [@"SpringBoard" isEqualToString:processName];

    BOOL shouldLoad = NO;
    NSArray* args = [[NSClassFromString(@"NSProcessInfo") processInfo] arguments];
    NSUInteger count = args.count;
    if (count != 0) {
        NSString* executablePath = args[0];
        if (executablePath) {
            NSString* processName = [executablePath lastPathComponent];
            BOOL isApplication = [executablePath rangeOfString:@"/Application/"].location != NSNotFound || [executablePath rangeOfString:@"/Applications/"].location != NSNotFound;
            BOOL isFileProvider = [[processName lowercaseString] rangeOfString:@"fileprovider"].location != NSNotFound;
            BOOL skip = [processName isEqualToString:@"AdSheet"]
                        || [processName isEqualToString:@"CoreAuthUI"]
                        || [processName isEqualToString:@"InCallService"]
                        || [processName isEqualToString:@"MessagesNotificationViewService"]
                        || [executablePath rangeOfString:@".appex/"].location != NSNotFound;
            if ((!isFileProvider && isApplication && !skip) || isSpringboard) {
                shouldLoad = YES;
            }
        }
    }

	if (!shouldLoad) return; 

    reloadPrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadPrefs, CFSTR("com.bid3v.electrode/prefs.changed"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}
