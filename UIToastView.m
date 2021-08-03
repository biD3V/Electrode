#import "UIToastView.h"

@implementation UIToastView // TODO: Make modular and a subclass

- (UIToastView *)initToastWithTitle:(NSString *)title subtitle:(NSString *)subtitle autoHidden:(BOOL)autoHidden {
    self = [super initWithFrame:CGRectZero];

    // Check if there is a view controller
    // TODO: Create custom UIWindow
    if (![self getTopViewController].view) return self;

    [self setUpBackground];

    self.autoHide = autoHidden;

    [[self getTopViewController].view addSubview:self];

    // Set hidden position
    self.initialTransform = CGAffineTransformMakeTranslation(0, -100);

    self.container = [UIView new];
    [self addSubview:self.container];

    // Device Image
    self.deviceImage = [[UIImageView alloc] initWithImage:[[BCBatteryDeviceController sharedInstance].connectedDevices[0] batteryWidgetGlyph]];
    self.deviceImage.tintColor = [UIColor labelColor];
    [self.container addSubview:self.deviceImage]; // Outside of stack view to center it on the leading containter edge

    self.hStack = [UIStackView new];
    self.hStack.alignment = UIStackViewAlignmentCenter;
    self.hStack.spacing = 16.0;
    [self.container addSubview:self.hStack];

    self.vStack = [UIStackView new];
    self.vStack.axis = UILayoutConstraintAxisVertical;
    [self.hStack addArrangedSubview:self.vStack];

    // TODO: Use the native toast fonts
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightSemibold];
    self.titleLabel.text = title;

    self.subtitleLabel = [UILabel new];
    self.subtitleLabel.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightSemibold];
    self.subtitleLabel.textColor = [UIColor secondaryLabelColor];
    self.subtitleLabel.text = subtitle;

    [self.vStack addArrangedSubview:self.titleLabel];
    [self.vStack addArrangedSubview:self.subtitleLabel];

    // --- Battery View ---
    // -- Battery Info --
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = true;

    BCBatteryDevice *battery = [BCBatteryDeviceController sharedInstance].connectedDevices[0];

    // -- View --
    self.batteryView = [[BCUIBatteryView alloc] initWithSizeCategory:1];
    [self.batteryView setChargePercent:device.batteryLevel];
    [self.batteryView setChargingState:(device.batteryState == UIDeviceBatteryStateCharging || device.batteryState == UIDeviceBatteryStateFull) ? 1 : 0];
    [self.batteryView setShowsInlineChargingIndicator:(device.batteryState == UIDeviceBatteryStateCharging || device.batteryState == UIDeviceBatteryStateFull)];
    [self.batteryView setLowBattery:battery.lowBattery];
    [self.hStack addArrangedSubview:self.batteryView];

    [self addSubview:self.hStack];

    // For hiding when auto-hide is disabled
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self addGestureRecognizer:tapGuesture];

    [self setupConstraints];
    [self setupStackViewContraints];
    
    self.transform = self.initialTransform;

    return self;
}

- (void)setUpBackground {
    self.shadowView = [MTMaterialShadowView materialShadowViewWithRecipe:54 configuration:1];
    [self.shadowView setTranslatesAutoresizingMaskIntoConstraints:false];

	[self addSubview:self.shadowView];

    [NSLayoutConstraint activateConstraints:@[
        [self.shadowView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.shadowView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.shadowView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.shadowView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];

    self.shadowView.shadowColor = UIColor.blackColor;
    self.shadowView.shadowRadius = 25;
    self.shadowView.shadowOpacity = 0.18;
    self.shadowView.shadowOffset = CGSizeMake(0,8);
    self.shadowView.shadowPathIsBounds = true;
}

- (void)presentToast {
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(){
                         self.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished){
                         if (self.autoHide) [self hideAfter:1.0];
                     }];
}

- (void)hide {
    [self hideAfter:0.0];
}

- (void)hideAfter:(NSTimeInterval)time {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.transform = self.initialTransform;
                         }
                         completion:^(BOOL finished){
                             [self removeFromSuperview];
                         }];
    });
}

- (void)setupConstraints {
    [self setTranslatesAutoresizingMaskIntoConstraints:false];

    [NSLayoutConstraint activateConstraints:@[
        [self.centerXAnchor constraintEqualToAnchor:self.superview.centerXAnchor],
        [self.topAnchor constraintEqualToAnchor:self.superview.layoutMarginsGuide.topAnchor],
        [self.bottomAnchor constraintLessThanOrEqualToAnchor:self.superview.layoutMarginsGuide.bottomAnchor constant:-8],
        [self.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.superview.leadingAnchor constant:8],
        [self.trailingAnchor constraintLessThanOrEqualToAnchor:self.superview.trailingAnchor constant:-8],
        [self.heightAnchor constraintGreaterThanOrEqualToConstant:50]
    ]];
}

- (void)setupStackViewContraints {
    [self.hStack setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.deviceImage setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.container setTranslatesAutoresizingMaskIntoConstraints:false];

    [NSLayoutConstraint activateConstraints:@[
        [self.container.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:24],
        [self.container.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-24],
        [self.container.topAnchor constraintEqualToAnchor:self.topAnchor constant:8],
        [self.container.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-8],
        [self.deviceImage.heightAnchor constraintEqualToAnchor:self.vStack.heightAnchor],
        [self.deviceImage.widthAnchor constraintEqualToAnchor:self.deviceImage.heightAnchor multiplier:(self.deviceImage.image.size.width / self.deviceImage.image.size.height)],
        [self.deviceImage.centerXAnchor constraintEqualToAnchor:self.container.leadingAnchor],
        [self.deviceImage.centerYAnchor constraintEqualToAnchor:self.container.centerYAnchor],
        [self.hStack.leadingAnchor constraintEqualToAnchor:self.deviceImage.trailingAnchor constant:8],
        [self.hStack.trailingAnchor constraintEqualToAnchor:self.container.trailingAnchor],
        [self.hStack.topAnchor constraintEqualToAnchor:self.container.topAnchor],
        [self.hStack.bottomAnchor constraintEqualToAnchor:self.container.bottomAnchor]
    ]];
}

- (UIViewController *)getTopViewController {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;

    return keyWindow.rootViewController;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.shadowView.materialView.layer.cornerRadius = self.bounds.size.height / 2.0; // Why doesn't the native method do this?
}

@end