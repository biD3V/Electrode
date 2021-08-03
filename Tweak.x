#import <UIKit/UIKit.h>
#import <SpringBoard/SpringBoard.h>
#import <SpringBoardUI/SBLowPowerAlertItem.h>
#import "UIToastView.h"

// @interface SpringBoard (TestWindow)

// @property (nonatomic,strong) UIWindow * testWindow;

// @end

BOOL autoHideLP;

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

    autoHideLP = [prefs[@"autoHideLP"] boolValue];
}

// TODO: Custom Window
// %hook SpringBoard
// %property (nonatomic,strong) UIWindow * testWindow;

// - (void)applicationDidFinishLaunching:(UIApplication *)application {
//     %orig;
//     self.testWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0,0,100,100)];
//     self.testWindow.backgroundColor = [UIColor redColor];
//     self.testWindow.windowLevel = UIWindowLevelStatusBar;
//     [self.testWindow makeKeyAndVisible];
// }

// %end

// TODO: Find system notification for LP Alert and charging
%hook SBAlertItemsController
- (void)activateAlertItem:(id)item animated:(BOOL)animated {
	if ([item isKindOfClass:[%c(SBLowPowerAlertItem) class]]) {
		BCBatteryDevice *battery = [BCBatteryDeviceController sharedInstance].connectedDevices[0];
		UIToastView *toast = [[UIToastView alloc] initToastWithTitle:@"Low Battery" subtitle:[NSString stringWithFormat:@"%ld%% battery remaining", battery.percentCharge] autoHidden:autoHideLP];
		[toast presentToast];
        [(SBLowPowerAlertItem *)item _enableLowPowerMode];
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
		UIToastView *toast = [[UIToastView alloc] initToastWithTitle:@"Charging" subtitle:[NSString stringWithFormat:@"%ld%%", battery.percentCharge] autoHidden:true];
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
