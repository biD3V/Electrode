#import "EDPLPAlertIncrementsListController.h"

@interface NSConcreteNotification : NSNotification
@end

@implementation EDPLPAlertIncrementsListController

- (id)specifiers {
    if (!_specifiers) {
        _specifiers = [NSMutableArray new];

        [_specifiers addObjectsFromArray:[self loadSpecifiersFromPlistName:@"Percentage" target:self]];

        NSArray<NSNumber *> *percentages = [NSDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.bid3v.electrodeprefs.plist"][@"percentages"];

        for (NSNumber *percentage in percentages) {
            PSSpecifier *percentSpecifier = [PSSpecifier preferenceSpecifierNamed:[percentage stringValue]
                                                                           target:self
                                                                              set:NULL
                                                                              get:NULL
                                                                           detail:nil
                                                                             cell:PSListItemCell
                                                                             edit:nil];
            [_specifiers addObject:percentSpecifier];
        }
    }

    return _specifiers;
}

- (void)addLevel:(NSString *)value forSpecifier:(PSSpecifier *)specifier {
    if ([specifier.properties[@"key"] isEqual:@"newPercent"] || [specifier.properties[@"id"] isEqual:@"newPercent"]) {
        NSMutableDictionary *prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.bid3v.electrodeprefs.plist"];
        NSMutableArray<NSNumber *> *percentages = prefs[@"percentages"] ?: [NSMutableArray new];

        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterNoStyle;
        [percentages addObject:[formatter numberFromString:value]];
        [prefs setObject:percentages forKey:@"percentages"];
        [prefs writeToFile:@"/User/Library/Preferences/com.bid3v.electrodeprefs.plist" atomically:true];
        [self reloadSpecifiers];
    }
}

- (BOOL)performDeletionActionForSpecifier:(PSSpecifier *)specifier {
    NSMutableDictionary *prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.bid3v.electrodeprefs.plist"];
    NSMutableArray<NSNumber *> *percentages = prefs[@"percentages"];

    [percentages removeObject:[NSNumber numberWithInteger:[specifier.name intValue]]];
    [prefs setObject:percentages forKey:@"percentages"];
    [prefs writeToFile:@"/User/Library/Preferences/com.bid3v.electrodeprefs.plist" atomically:true];

    return [super performDeletionActionForSpecifier:specifier];
}

- (void)_returnKeyPressed:(NSConcreteNotification *)notification {
	[self.view endEditing:YES];
	[super _returnKeyPressed:notification];
}

@end