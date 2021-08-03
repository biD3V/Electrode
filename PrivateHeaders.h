#import <UIKit/UIKit.h>

@interface MTMaterialView : UIView
@end

@interface MTMaterialShadowView : UIView

@property (nonatomic,retain) MTMaterialView *materialView;

+ (MTMaterialShadowView *)materialShadowViewWithRecipe:(long long)arg1 configuration:(long long)arg2 ;
- (void)setShadowOffset:(CGSize)offset;
- (void)setShadowColor:(UIColor *)color;
- (void)setShadowOpacity:(CGFloat)opacity;
- (void)setShadowRadius:(CGFloat)radius;
- (void)setShadowPathIsBounds:(BOOL)isBounds;

@end

@interface _UIBatteryView : UIView

@property (assign,nonatomic) CGFloat chargePercent;
@property (assign,nonatomic) NSInteger chargingState;
@property (assign,nonatomic) BOOL showsInlineChargingIndicator;

- (_UIBatteryView *)initWithSizeCategory:(NSUInteger)category;
- (void)_commonInit;

@end

@interface _UIStaticBatteryView : _UIBatteryView

@end

@interface BCUIBatteryView : _UIStaticBatteryView

- (void)setLowBattery:(BOOL)lowBattery;

@end

@interface BCBatteryDevice : NSObject {

	NSString* _identifier;
	NSString* _matchIdentifier;
	NSInteger _percentCharge;
	BOOL _charging;
	BOOL _connected;
	BOOL _batterySaverModeActive;
	BOOL _lowBattery;
	BOOL _internal;
	BOOL _powerSource;
	BOOL _approximatesPercentCharge;
	BOOL _wirelesslyCharging;
	BOOL _fake;
	long long _vendor;
	long long _powerSourceState;
	long long _productIdentifier;
	NSString* _accessoryIdentifier;
	NSString* _name;
	NSString* _modelNumber;
	unsigned long long _parts;
	unsigned long long _accessoryCategory;
	NSString* _groupName;
	long long _transportType;
}
@property (nonatomic,copy) NSString * identifier;                                                      //@synthesize identifier=_identifier - In the implementation block
@property (nonatomic,copy) NSString * name;                                                            //@synthesize name=_name - In the implementation block
@property (assign,nonatomic) NSInteger percentCharge;                                                  //@synthesize percentCharge=_percentCharge - In the implementation block
@property (assign,getter=isConnected,nonatomic) BOOL connected;                                        //@synthesize connected=_connected - In the implementation block
@property (assign,getter=isCharging,nonatomic) BOOL charging;                                          //@synthesize charging=_charging - In the implementation block
@property (assign,getter=isInternal,nonatomic) BOOL internal;                                          //@synthesize internal=_internal - In the implementation block
@property (assign,getter=isPowerSource,nonatomic) BOOL powerSource;                                    //@synthesize powerSource=_powerSource - In the implementation block
@property (assign,nonatomic) BOOL approximatesPercentCharge;                                           //@synthesize approximatesPercentCharge=_approximatesPercentCharge - In the implementation block
@property (assign,nonatomic) unsigned long long parts;                                                 //@synthesize parts=_parts - In the implementation block
@property (assign,getter=isWirelesslyCharging,nonatomic) BOOL wirelesslyCharging;                      //@synthesize wirelesslyCharging=_wirelesslyCharging - In the implementation block
@property (nonatomic,copy) NSString * groupName;                                                       //@synthesize groupName=_groupName - In the implementation block
@property (nonatomic,copy,readonly) NSString * matchIdentifier;                                        //@synthesize matchIdentifier=_matchIdentifier - In the implementation block
@property (assign,nonatomic) long long transportType;                                                  //@synthesize transportType=_transportType - In the implementation block
@property (assign,nonatomic) long long powerSourceState;                                               //@synthesize powerSourceState=_powerSourceState - In the implementation block
@property (assign,getter=isFake,nonatomic) BOOL fake;                                                  //@synthesize fake=_fake - In the implementation block
@property (assign,getter=isBatterySaverModeActive,nonatomic) BOOL batterySaverModeActive;              //@synthesize batterySaverModeActive=_batterySaverModeActive - In the implementation block
@property (assign,getter=isLowBattery,nonatomic) BOOL lowBattery;                                      //@synthesize lowBattery=_lowBattery - In the implementation block
@property (nonatomic,copy) NSString * accessoryIdentifier;                                             //@synthesize accessoryIdentifier=_accessoryIdentifier - In the implementation block
@property (assign,nonatomic) unsigned long long accessoryCategory;                                     //@synthesize accessoryCategory=_accessoryCategory - In the implementation block
@property (nonatomic,copy) NSString * modelNumber;                                                     //@synthesize modelNumber=_modelNumber - In the implementation block
@property (nonatomic,readonly) long long vendor;                                                       //@synthesize vendor=_vendor - In the implementation block
@property (nonatomic,readonly) long long productIdentifier;                                            //@synthesize productIdentifier=_productIdentifier - In the implementation block
+(id)_internalBatteryDeviceGlyphName;
+(CGSize)batteryWidgetGlyphLargestSize;
+(BOOL)supportsSecureCoding;
+(id)batteryDeviceWithIdentifier:(id)arg1 vendor:(long long)arg2 productIdentifier:(long long)arg3 parts:(unsigned long long)arg4 matchIdentifier:(id)arg5 ;
-(UIImage *)batteryWidgetGlyph;
-(id)_batteryWidgetGlyphName:(out BOOL*)arg1 ;
-(BOOL)isConnected;
-(BOOL)isInternal;
-(unsigned long long)parts;
-(void)setConnected:(BOOL)arg1 ;
-(NSString *)groupName;
-(long long)transportType;
-(void)setGroupName:(NSString *)arg1 ;
-(void)setTransportType:(long long)arg1 ;
-(void)setCharging:(BOOL)arg1 ;
-(BOOL)isFake;
-(void)setName:(NSString *)arg1 ;
-(NSString *)name;
-(NSString *)matchIdentifier;
-(void)setParts:(unsigned long long)arg1 ;
-(BOOL)isPowerSource;
-(void)setPowerSource:(BOOL)arg1 ;
-(void)setPowerSourceState:(long long)arg1 ;
-(void)setWirelesslyCharging:(BOOL)arg1 ;
-(void)setLowBattery:(BOOL)arg1 ;
-(void)setApproximatesPercentCharge:(BOOL)arg1 ;
-(NSString *)modelNumber;
-(void)setBatterySaverModeActive:(BOOL)arg1 ;
-(long long)powerSourceState;
-(id)initWithIdentifier:(id)arg1 vendor:(long long)arg2 productIdentifier:(long long)arg3 parts:(unsigned long long)arg4 matchIdentifier:(id)arg5 ;
-(BOOL)approximatesPercentCharge;
-(BOOL)isWirelesslyCharging;
-(void)setIdentifier:(NSString *)arg1 ;
-(NSString *)accessoryIdentifier;
-(void)setAccessoryIdentifier:(NSString *)arg1 ;
-(BOOL)isBatterySaverModeActive;
-(NSString *)identifier;
-(BOOL)isCharging;
-(void)setAccessoryCategory:(unsigned long long)arg1 ;
-(void)setModelNumber:(NSString *)arg1 ;
-(id)description;
-(NSInteger)percentCharge;
-(void)setFake:(BOOL)arg1 ;
-(unsigned long long)accessoryCategory;
-(long long)vendor;
-(BOOL)isLowBattery;
-(void)setPercentCharge:(NSInteger)arg1 ;
-(void)setInternal:(BOOL)arg1 ;
-(long long)productIdentifier;
@end

@interface BCBatteryDeviceController : NSObject

@property (nonatomic,copy,readonly) NSArray<BCBatteryDevice *> *connectedDevices;

+ (BCBatteryDeviceController *)sharedInstance;

@end

@interface SBUIController : NSObject

- (BOOL)isOnAC;

@end

// @interface CALayer (Private)

// @property BOOL shadowPathIsBounds;

// @end