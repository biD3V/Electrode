#import "UIToastView.h"

@interface BCBatteryDevice (Private)

- (UIImage *)batteryWidgetGlyph;

@end

@interface UIBatteryToastView : UIToastView

@property (nonatomic,strong) BCUIBatteryView *batteryView;

@end