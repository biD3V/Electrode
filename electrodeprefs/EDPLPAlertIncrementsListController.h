#import <Preferences/PSSpecifier.h>
#import <Preferences/PSListController.h>

@interface PSEditableListController : PSListController {
	BOOL _editable;
	BOOL _editingDisabled;
}

- (void)editDoneTapped;
- (BOOL)performDeletionActionForSpecifier:(PSSpecifier *)specifier;

@end

@interface EDPLPAlertIncrementsListController : PSEditableListController

- (void)addLevel:(id)value forSpecifier:(PSSpecifier *)specifier;

@end
