//
//  PNTToolbar.h
//
//  Created by Planet 1107
//

#define TEXT_FIELD_INSET 10

#import <UIKit/UIKit.h>

@interface PNTToolbar : UIToolbar

@property (strong, nonatomic) UIScrollView *mainScrollView;
@property (strong, nonatomic) NSArray *inputFields;
@property (strong, nonatomic) NSArray *inputFieldsDelegates;
@property (strong, nonatomic) UIColor *navigationButtonsTintColor;
@property (assign, nonatomic) BOOL shouldHideNavigationButtons;

+ (PNTToolbar *)defaultToolbar;

@end
