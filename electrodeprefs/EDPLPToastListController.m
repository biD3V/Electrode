#include "EDPLPToastListController.h"

@implementation EDPLPToastListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"LPToast" target:self];
	}

	return _specifiers;
}

@end
