#include "EDPLPToastListController.h"

@implementation EDPLPToastListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"LPToast" target:self];
	}

	return _specifiers;
}

- (void)testLowPowerToast {
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.bid3v.electrode.lpTest"
                                                                   object:nil];
}

@end
