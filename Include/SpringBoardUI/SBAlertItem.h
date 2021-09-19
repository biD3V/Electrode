// Headers generated with ktool v0.8.0
// https://github.com/kritantadev/ktool | pip3 install k2l
// Platform: IOS | Minimum OS: 14.3.0 | SDK: 14.3.0


#ifndef SBALERTITEM_H
#define SBALERTITEM_H

@class NSArray;

#import <BaseBoard/UIImage.h>
#import <SpringBoardServices/NSString.h>

#import "_SBAlertController.h"

@interface SBAlertItem : NSObject <BSDescriptionProviding>

 {
    _SBAlertController *_alertController;
    BOOL _didEverActivate;
    BOOL _didEverDeactivate;
    BOOL _didPlayPresentationSound;
}


@property (nonatomic) NSUInteger _presentationState; // ivar: _presentationState
@property (nonatomic) BOOL presented; // ivar: _presented
@property (retain, nonatomic) UIImage *_headerImage; // ivar: _headerImage
@property (retain, nonatomic) UIImage *_attachmentImage; // ivar: _attachmentImage
@property (nonatomic) BOOL _ignoresQuietMode; // ivar: _ignoresQuietMode
@property (retain, nonatomic) UIImage *iconImage; // ivar: _iconImage
@property (retain, nonatomic) NSString *iconImagePath; // ivar: _iconImagePath
@property (nonatomic) BOOL ignoreIfAlreadyDisplaying; // ivar: _ignoreIfAlreadyDisplaying
@property (nonatomic) BOOL allowInSetup; // ivar: _allowInSetup
@property (nonatomic) BOOL pendInSetupIfNotAllowed; // ivar: _pendInSetupIfNotAllowed
@property (nonatomic) BOOL pendWhileKeyBagLocked; // ivar: _pendWhileKeyBagLocked
@property (retain, nonatomic) NSArray *allowedBundleIDs; // ivar: _allowedBundleIDs
@property (nonatomic) BOOL suppressForKeynote; // ivar: _suppressForKeynote
@property (nonatomic) BOOL allowInCar; // ivar: _allowInCar
@property (nonatomic) BOOL allowMessageInCar; // ivar: _allowMessageInCar
@property (readonly) NSUInteger hash;
@property (readonly) Class superclass;
@property (readonly, copy) NSString *description;
@property (readonly, copy) NSString *debugDescription;


-(id)sound;
-(id)_prepareNewAlertControllerWithLockedState:(BOOL)arg0 requirePasscodeForActions:(BOOL)arg1 ;
-(id)visualStyleForAlertControllerStyle:(NSInteger)arg0 traitCollection:(id)arg1 descriptor:(id)arg2 ;
-(id)lockLabel;
-(id)shortLockLabel;
-(BOOL)wakeDisplay;
-(id)_publicDescription;
-(void)didFailToActivate;
-(void)presentationStateDidChangeFromState:(NSUInteger)arg0 toState:(NSUInteger)arg1 ;
-(BOOL)forcesModalAlertAppearance;
-(id)succinctDescription;
-(void)performUnlockAction;
-(BOOL)shouldShowInLockScreen;
-(void)doCleanupAfterDeactivationAnimation;
-(void)_setPresentationState:(NSUInteger)arg0 ;
-(id)_alertController;
-(id)alertController;
-(void)configure:(BOOL)arg0 requirePasscodeForActions:(BOOL)arg1 ;
-(void)dismiss:(int)arg0 ;
-(id)succinctDescriptionBuilder;
-(BOOL)dismissOnLock;
-(BOOL)reappearsAfterLock;
-(void)_noteVolumeOrLockPressed;
-(BOOL)allowLockScreenDismissal;
-(BOOL)allowInLoginWindow;
-(BOOL)behavesSuperModally;
-(BOOL)allowMenuButtonDismissal;
-(void)willDeactivateForReason:(int)arg0 ;
-(BOOL)hideOnClonedDisplay;
-(void)didDeactivateForReason:(int)arg0 ;
-(BOOL)allowInCar;
-(void)deactivate;
-(BOOL)_displayActionButtonOnLockScreen;
-(BOOL)_ignoresQuietMode;
-(void)willActivate;
-(void)dismiss;
-(BOOL)reappearsAfterUnlock;
-(BOOL)dismissesOverlaysOnLockScreen;
-(void)_setHeaderImage:(id)arg0 ;
-(void)deactivateForButton;
-(void)_setIgnoresQuietMode:(BOOL)arg0 ;
-(void)playPresentationSound;
-(BOOL)suppressForKeynote;
-(BOOL)ignoreIfAlreadyDisplaying;
-(BOOL)allowInSetup;
-(BOOL)pendInSetupIfNotAllowed;
-(BOOL)pendWhileKeyBagLocked;
-(BOOL)_didEverActivate;
-(BOOL)shouldShowInEmergencyCall;
-(void)didActivate;
-(void)_deactivationCompleted;
-(void)_clearAlertController;
-(void)deactivateForReason:(int)arg0 ;
-(BOOL)allowMessageInCar;
-(BOOL)undimsScreen;
-(BOOL)unlocksScreen;
-(BOOL)didPlayPresentationSound;
-(void)alertItemDidAppear;
-(void)alertItemDidDisappear;
-(void)willRelockForButtonPress:(BOOL)arg0 ;
-(int)alertPriority;
-(BOOL)_hasActiveKeyboardOnScreen;
-(void)buttonDismissed;
-(void)_setAttachmentImage:(id)arg0 ;
+(void)activateAlertItem:(id)arg0 ;
+(id)_alertItemsController;


@end