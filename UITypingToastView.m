#import "UITypingToastView.h"

@implementation UITypingToastView

@synthesize handle, contact, avatar;

- (instancetype)initWithID:(NSString *)ID {
    self.handle = [[IMHandleRegistrar sharedInstance] getIMHandlesForID:ID].firstObject;
    self.contact = handle.cnContact;

    self = [super initToastWithTitle:[NSString stringWithFormat:@"%@ is typing...", self.contact.givenName] autoHidden:false];

    self.avatar = [NSClassFromString(@"CNAvatarView") new];
    [self.avatar setContact:self.contact];

    [self.container addSubview:self.avatar];
    [self.avatar setTranslatesAutoresizingMaskIntoConstraints:false];

    [NSLayoutConstraint activateConstraints:@[
        [self.avatar.centerXAnchor constraintEqualToAnchor:self.avatar.superview.leadingAnchor constant:1],
        [self.avatar.centerYAnchor constraintEqualToAnchor:self.avatar.superview.centerYAnchor],
        [self.avatar.heightAnchor constraintEqualToAnchor:self.avatar.superview.heightAnchor],
        [self.avatar.widthAnchor constraintEqualToAnchor:self.avatar.heightAnchor],
        [self.hStack.leadingAnchor constraintEqualToAnchor:self.avatar.trailingAnchor constant:8]
    ]];

    return self;
}

@end