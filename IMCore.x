#import <Foundation/Foundation.h>
#import <IMCore/IMHandle.h>
#import "UIToastView.h"

@interface IMItem : NSObject

@property (nonatomic,strong) NSString *sender;
@property (nonatomic,strong) NSDictionary *senderInfo;

- (IMHandle *)_senderHandle;

@end

@interface IMMessageItem : IMItem

@end

@interface IMMessageItem (Electrode)

@property (nonatomic,retain) UIToastView *toast;

@end

@interface NSDistributedNotificationCenter : NSNotificationCenter
@end

%hook IMDaemonController

- (unsigned)_capabilities {
	NSString *process = [[NSProcessInfo processInfo] processName];
	if ([process isEqualToString:@"SpringBoard"])
		return 17159;
	else
		return %orig;
}

%end

%hook IMMessageItem
%property (nonatomic,retain) UIToastView *toast;

- (bool)isCancelTypingMessage {
    bool orig = %orig;

    if (orig) {
        NSLog(@"[Electrode] %@ stopped typing.", [self _senderHandle].name);
        [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.bid3v.electrode.senderStoppedTyping"
                                                                       object:nil];
    }

    return orig;
}

- (bool)isIncomingTypingMessage {
    bool orig = %orig;

    if (orig) {
        NSLog(@"[Electrode] %@ started typing.", [self _senderHandle].name);
        [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.bid3v.electrode.senderStartedTyping"
                                                                       object:nil
                                                                     userInfo:@{
                                                                         @"name": [self _senderHandle].name,
                                                                         @"contact": self.cnContact
                                                                     }];
    }

    return orig;
}

// Testing
- (bool)isTypingMessage {
    bool orig = %orig;

    if (orig) {
        NSLog(@"[Electrode] %@ started typing.", [self _senderHandle].name);
        [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.bid3v.electrode.senderStartedTyping"
                                                                       object:nil
                                                                     userInfo:@{
                                                                         @"name": [self _senderHandle].name,
                                                                         @"contact": self.cnContact
                                                                     }];
    }

    return orig;
}

%end