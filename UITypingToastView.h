#import <UIKit/UIKit.h>
#import "UIToastView.h"

// I can probably remove some of these
#import <IMCore/IMChatRegistry.h>
#import <IMCore/IMChat.h>
#import <IMCore/IMAccountController.h>
#import <IMCore/IMAccount.h>
#import <IMCore/IMHandle.h>
#import <IMCore/IMMessage.h>
#import <IMCore/IMDaemonController.h>
#import <IMCore/IMHandleRegistrar.h>
#import <ContactsUI/CNAvatarViewControllerSettings.h>
#import <Contacts/CNContact.h>
#import <ContactsUI/CNAvatarView.h>

@interface UITypingToastView : UIToastView

@property (nonatomic,retain) IMHandle *handle;
@property (nonatomic,retain) CNContact *contact;
@property (nonatomic,retain) CNAvatarView *avatar;

- (instancetype)initWithID:(NSString *)ID;

@end