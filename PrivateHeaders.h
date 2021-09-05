#import <UIKit/UIKit.h>
#import <MaterialKit/MTMaterialShadowView.h>
#import <BatteryCenterUI/BCUIBatteryView.h>
#import <BatteryCenter/BCBatteryDeviceController.h>

// TODO: Move to theos/include

@interface SBUIController : NSObject

- (BOOL)isOnAC;

@end

@interface _CDBatterySaver : NSObject

+ (id)sharedInstance;
- (BOOL)setPowerMode:(NSInteger)powerMode error:(id*)error;

@end

@interface NSDistributedNotificationCenter : NSNotificationCenter
@end