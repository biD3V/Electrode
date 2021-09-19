#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <IMCore/IMHandle.h>
#import <Contacts/CNContact.h>
#import <ContactsUI/CNAvatarView.h>
#import "UIToastView.h"
#import "PrivateHeaders.h"

@interface IMItem : NSObject

@property (nonatomic,strong) NSString *sender;
@property (nonatomic,strong) NSDictionary *senderInfo;

- (IMHandle *)_senderHandle;

@end

@interface IMMessageItem : IMItem

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
                                                                     userInfo:@{@"identifier": [self _senderHandle].ID}];
    } else {
        NSLog(@"[Electrode] %@ stopped typing.", [self _senderHandle].name);
        [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.bid3v.electrode.senderStoppedTyping"
                                                                       object:nil];
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
                                                                     userInfo:@{@"identifier": [self _senderHandle].ID}];
    }

    return orig;
}

%end