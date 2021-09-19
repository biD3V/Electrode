/*
* This header is generated by classdump-dyld 1.0
* on Friday, February 12, 2021 at 12:29:23 AM Eastern European Standard Time
* Operating System: Version 14.4 (Build 18D52)
* Image Source: /System/Library/Frameworks/ContactsUI.framework/ContactsUI
* classdump-dyld is licensed under GPLv3, Copyright © 2013-2016 by Elias Limneos.
*/


@protocol CNAvatarCardControllerDelegate <NSObject>
@optional
-(BOOL)avatarCardController:(id)arg1 shouldShowContact:(id)arg2;
-(id)avatarCardController:(id)arg1 orderedPropertiesForProperties:(id)arg2 category:(id)arg3;
-(void)avatarCardControllerWillDismiss:(id)arg1;
-(void)avatarCardControllerDidDismiss:(id)arg1;
-(void)avatarCardControllerWillBeginPreviewInteraction:(id)arg1;
-(long long)avatarCardController:(id)arg1 presentationResultForLocation:(CGPoint)arg2;
-(BOOL)avatarCardController:(id)arg1 shouldPresentForLocation:(CGPoint)arg2;

@required
-(id)presentingViewControllerForAvatarCardController:(id)arg1;

@end

