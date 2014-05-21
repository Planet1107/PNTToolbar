//
//  PLToolbar.h
//
//  Created by Planet 1107
//

#define KEYBOARD_ANIMATION_DURATION 0.2

#import <UIKit/UIKit.h>

@interface PNTToolbar : UIToolbar

@property (strong, nonatomic) UIScrollView *mainScrollView;
@property (strong, nonatomic) NSArray *textFields;
@property (strong, nonatomic) NSArray *delegates;
@property (strong, nonatomic) UIColor *navigationButtonsTintColor;
@property (assign, nonatomic) BOOL shouldHideNavigationButtons;

+ (PNTToolbar *)defaultToolbar;

@end
