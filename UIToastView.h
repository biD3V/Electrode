#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PrivateHeaders.h"

@interface UIToastView : UIView

@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UILabel *subtitleLabel;
@property (nonatomic,strong) MTMaterialShadowView *shadowView;
@property (nonatomic,strong) UIView *container;
@property (nonatomic,strong) UIStackView *hStack;
//@property (nonatomic,strong) UIStackView *nestHStack;
@property (nonatomic,strong) BCUIBatteryView *batteryView;
@property (nonatomic,strong) UIStackView *vStack;
@property (nonatomic,strong) UIImageView *deviceImage;
@property (nonatomic) CGAffineTransform initialTransform;
@property BOOL autoHide;
// @property (nonatomic,strong) NSTimeInterval *displayTime;
// @property (nonatomic,strong) NSTimeInterval *showAnimationDuration;
// @property (nonatomic,strong) NSTimeInterval *hideAnimationDuration;


- (UIToastView *)initToastWithTitle:(NSString *)title subtitle:(NSString *)subtitle autoHidden:(BOOL)autoHidden;
- (void)setUpBackground;
- (void)presentToast;
- (void)hide;
- (void)hideAfter:(NSTimeInterval)time;
- (void)setupConstraints;
- (void)setupStackViewContraints;


@end

