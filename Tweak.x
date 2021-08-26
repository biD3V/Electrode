#import <UIKit/UIKit.h>
#import <SpringBoard/SpringBoard.h>
#import <SpringBoardUI/SBLowPowerAlertItem.h>
#import <SpringBoard/SBAlertItemsController.h>
#import <SpringBoard/SBDefaultIconModelStore.h>
#import "UIToastWindow.h"
#import "UIBatteryToastView.h"

#import <IMCore/IMChatRegistry.h>
#import <IMCore/IMChat.h>
#import <IMCore/IMAccountController.h>
#import <IMCore/IMAccount.h>
#import <IMCore/IMHandle.h>
#import <IMCore/IMMessage.h>
#import <IMCore/IMDaemonController.h>

#import "dlfcn.h"

@interface NSDistributedNotificationCenter : NSNotificationCenter
@end

@interface SpringBoard (Electrode)

@property (nonatomic,strong) UIWindow * toastWindow;
@property (nonatomic,strong) NSMutableArray<NSNumber *> *alertedPercents;

- (void)presentTypingToast:(NSString *)name;

@end

BOOL autoHideLP;
BOOL autoHideCHRG;
BOOL autoLP;
NSArray<NSNumber *> *percentages;
CGFloat chargeDelay;
CGFloat lpDelay;

static NSBundle *ElectrodeBundle;

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
    chargeDelay = prefs[@"chargeDelay"] ? [prefs[@"chargeDelay"] floatValue] : 1.0;
    lpDelay = prefs[@"lpDelay"] ? [prefs[@"lpDelay"] floatValue] : 1.0;
}

%hook SpringBoard
%property (nonatomic,strong) UIToastWindow *toastWindow;
%property (nonatomic,strong) NSMutableArray *alertedPercents;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    %orig;
    self.alertedPercents = [NSMutableArray new];
    self.toastWindow = [UIToastWindow sharedWindow];
    self.toastWindow.frame = [UIScreen mainScreen].bounds;
    self.toastWindow.backgroundColor = UIColor.clearColor;
    self.toastWindow.windowLevel = UIWindowLevelStatusBar;
    [self.toastWindow makeKeyAndVisible];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkLevel)
                                                 name:UIDeviceBatteryLevelDidChangeNotification
                                               object:nil];
    
    __block UIToastView *typingToast;

    [[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"com.bid3v.electrode.senderStartedTyping"
                                                                 object:nil
                                                                  queue:[NSOperationQueue mainQueue]
                                                             usingBlock:^(NSNotification *notif){
                                                                 if (!typingToast) {
                                                                     typingToast = [[UIToastView alloc] initToastWithTitle:[NSString stringWithFormat:@"%@ is typing...", notif.userInfo[@"name"]]
                                                                                                                 image:[[CNAvatarView alloc] initWithContact:(CNContact *)notif.userInfo[@"contact"]].contentImage
                                                                                                            autoHidden:false];
                                                                     [typingToast presentToast];
                                                                 }
                                                             }];
    [[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"com.bid3v.electrode.senderStoppedTyping"
                                                                 object:nil
                                                                  queue:[NSOperationQueue mainQueue]
                                                             usingBlock:^(NSNotification *notif){
                                                                 if (typingToast) {
                                                                     [typingToast hide];
                                                                     typingToast = nil;
                                                                 }
                                                             }];
}

%new
- (void)checkLevel {
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:true];
    //if ([UIDevice currentDevice].batteryState != UIDeviceBatteryStateUnplugged) return;
    for (NSNumber *percent in percentages) {
        if (([UIDevice currentDevice].batteryLevel * 100) <= percent.floatValue && ![self.alertedPercents containsObject:percent]) {
            [[%c(SBAlertItemsController) sharedInstance] activateAlertItem:[%c(SBLowPowerAlertItem) new]];
            [self.alertedPercents addObject:percent];
            return;
        }
    }
}

%new
- (void)presentTypingToast:(NSString *)name {
    UIToastView *typingToast = [[UIToastView alloc] initToastWithTitle:name autoHidden:false];
    [typingToast presentToast];
}

%end

// TODO: Find system notification for LP Alert and charging
%hook SBAlertItemsController
- (void)activateAlertItem:(id)item animated:(BOOL)animated {
	if ([item isKindOfClass:[%c(SBLowPowerAlertItem) class]]) {
		BCBatteryDevice *battery = [BCBatteryDeviceController sharedInstance].connectedDevices[0];
		UIBatteryToastView *toast = [[UIBatteryToastView alloc] initToastWithTitle:[ElectrodeBundle localizedStringForKey:@"LOW_BATTERY" value:@"Low Battery" table:nil]
                                                                          subtitle:[NSString stringWithFormat:[ElectrodeBundle localizedStringForKey:@"BATT_REMAINING" value:@"%ld%% battery remaining" table:nil], battery.percentCharge]
                                                                        autoHidden:autoHideLP];
        toast.displayTime = lpDelay;
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
		UIBatteryToastView *toast = [[UIBatteryToastView alloc] initToastWithTitle:[ElectrodeBundle localizedStringForKey:@"CHARGING" value:@"Charging" table:nil]
                                                                          subtitle:[NSString stringWithFormat:@"%ld%%", battery.percentCharge]
                                                                        autoHidden:autoHideCHRG];
        toast.displayTime = chargeDelay;
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

    ElectrodeBundle = [NSBundle bundleWithPath:@"Library/Application Support/Electrode"];
    reloadPrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadPrefs, CFSTR("com.bid3v.electrode/prefs.changed"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}
