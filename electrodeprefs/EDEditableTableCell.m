#import "EDEditableTableCell.h"

@implementation EDEditableTableCell

- (instancetype)initWithSpecifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:1000 reuseIdentifier:@"Cell" specifier:specifier];
    self.textField.returnKeyType = UIReturnKeyDone;
    return self;
}

@end