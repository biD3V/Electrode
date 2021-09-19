#import "UIBatteryToastView.h"

@implementation UIBatteryToastView

- (UIToastView *)initToastWithTitle:(NSString *)title subtitle:(NSString *)subtitle image:(UIImage *)image autoHidden:(BOOL)autoHidden {
    self = [super initToastWithTitle:title subtitle:subtitle image:image autoHidden:autoHidden];

    // --- Battery View ---
    // -- Battery Info --
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = true;

    BCBatteryDevice *battery = [BCBatteryDeviceController sharedInstance].connectedDevices[0];

    // -- View --
    self.batteryView = [[NSClassFromString(@"BCUIBatteryView") alloc] initWithSizeCategory:1];
    [self.batteryView setChargePercent:device.batteryLevel];
    [self.batteryView setChargingState:(device.batteryState == UIDeviceBatteryStateCharging || device.batteryState == UIDeviceBatteryStateFull) ? 1 : 0];
    [self.batteryView setShowsInlineChargingIndicator:(device.batteryState == UIDeviceBatteryStateCharging || device.batteryState == UIDeviceBatteryStateFull)];
    [self.batteryView setLowBattery:battery.lowBattery];
    [self.hStack addArrangedSubview:self.batteryView];

    return self;
}

- (UIToastView *)initToastWithTitle:(NSString *)title subtitle:(NSString *)subtitle autoHidden:(BOOL)autoHidden {
    return [self initToastWithTitle:title subtitle:subtitle image:[[BCBatteryDeviceController sharedInstance].connectedDevices[0] batteryWidgetGlyph] autoHidden:autoHidden];
}

@end