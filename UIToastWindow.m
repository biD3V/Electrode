#import "UIToastWindow.h"

@implementation UIToastWindow

+ (UIToastWindow *)sharedWindow {
    static UIToastWindow *sharedToastWindow = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedToastWindow = [[self alloc] init];
    });
    return sharedToastWindow;
}

- (UIToastWindow *)init {
    self = [super init];
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = UIColor.clearColor;
    self.windowLevel = UIWindowLevelStatusBar;
    self.rootViewController = [NSClassFromString(@"SBFTouchPassThroughViewController") new];
    return self;
}

// Passthrough
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    return view == self ? nil : view;
}

@end