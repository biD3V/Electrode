#import "UIToastView.h"

@implementation UIToastView // TODO: Make modular and a subclass

- (UIToastView *)initToastWithTitle:(NSString *)title subtitle:(NSString *)subtitle image:(UIImage *)image autoHidden:(BOOL)autoHidden {
    self = [super initWithFrame:CGRectZero];

    [self setUpBackground];

    self.autoHide = autoHidden;
    self.displayTime = 1.0;

    [[UIToastWindow sharedWindow] addSubview:self];

    // Set hidden position
    self.initialTransform = CGAffineTransformMakeTranslation(0, -100);

    self.container = [UIView new];
    [self addSubview:self.container];

    if (image) {
        self.toastImage = [[UIImageView alloc] initWithImage:image];
        self.toastImage.tintColor = [UIColor labelColor];
        [self.container addSubview:self.toastImage]; // Outside of stack view to center it on the leading containter edge
    }

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

    [self addSubview:self.hStack];

    // For hiding when auto-hide is disabled
    UISwipeGestureRecognizer *swipeGuesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    swipeGuesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:swipeGuesture];

    [self setupConstraints];
    [self setupStackViewContraints];
    
    self.transform = self.initialTransform;

    return self;
}

- (UIToastView *)initToastWithTitle:(NSString *)title subtitle:(NSString *)subtitle autoHidden:(BOOL)autoHidden {
    return [self initToastWithTitle:title subtitle:subtitle image:nil autoHidden:autoHidden];
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
                         if (self.autoHide) [self hideAfter:self.displayTime];
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
    [self.toastImage setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.container setTranslatesAutoresizingMaskIntoConstraints:false];

    if (self.toastImage) {
        [NSLayoutConstraint activateConstraints:@[
            [self.toastImage.heightAnchor constraintEqualToAnchor:self.vStack.heightAnchor],
            [self.toastImage.centerXAnchor constraintEqualToAnchor:self.container.leadingAnchor],
            [self.toastImage.centerYAnchor constraintEqualToAnchor:self.container.centerYAnchor],
            [self.toastImage.widthAnchor constraintEqualToAnchor:self.toastImage.heightAnchor multiplier:(self.toastImage.image.size.width / self.toastImage.image.size.height)],
            [self.hStack.leadingAnchor constraintEqualToAnchor:self.toastImage.trailingAnchor constant:8],
        ]];
    } else {
        [self.hStack.leadingAnchor constraintEqualToAnchor:self.container.leadingAnchor].active = true;
    }

    [NSLayoutConstraint activateConstraints:@[
        [self.container.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:24],
        [self.container.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-24],
        [self.container.topAnchor constraintEqualToAnchor:self.topAnchor constant:8],
        [self.container.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-8],
        [self.hStack.trailingAnchor constraintEqualToAnchor:self.container.trailingAnchor],
        [self.hStack.topAnchor constraintEqualToAnchor:self.container.topAnchor],
        [self.hStack.bottomAnchor constraintEqualToAnchor:self.container.bottomAnchor]
    ]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.shadowView.materialView.layer.cornerRadius = self.bounds.size.height / 2.0; // Why doesn't the native method do this?
}

@end