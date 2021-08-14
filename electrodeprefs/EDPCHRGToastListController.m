#include "EDPCHRGToastListController.h"

@implementation EDPCHRGToastListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"CHRGToast" target:self];
	}

	return _specifiers;
}

@end
