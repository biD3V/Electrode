#include "EDPCHRGToastListController.h"

@implementation EDPCHRGToastListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"CHRGToast" target:self];
	}

	return _specifiers;
}

- (void)testChargeToast {
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.bid3v.electrode.chargeTest"
                                                                   object:nil];
}

@end
