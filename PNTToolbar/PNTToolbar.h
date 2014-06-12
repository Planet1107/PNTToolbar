//
// PNTToolbar.h
//
// Copyright (c) 2014 Planet 1107 (http://www.planet1107.net/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>

/**
 *  `PNTToolbar` is a subclass of `UIToolbar` for better and simpler forms behaviour in `UIScrollView`.
 */
@interface PNTToolbar : UIToolbar

/**
 *  This object is actually scrolled to achive desired behaviour.
 */
@property (strong, nonatomic) UIScrollView *mainScrollView;


/**
 *  Array of input fields for which you want to provide Prev, Next, Done behaviour. Input fields are switched from first in this array to last.
 */
@property (strong, nonatomic) NSArray *inputFields;


/**
 *  Array of delegates of input fields. `PNTToolbar` provides default behaviour with input fileds. If you still need to do some work in delegate methods, set your delegates here.
 */
@property (strong, nonatomic) NSArray *inputFieldsDelegates;


/**
 *  Change default color of buttons in `PNTToolbar`.
 */
@property (strong, nonatomic) UIColor *navigationButtonsTintColor;


/**
 *  Hide Prev, Next buttons in navigation. Handy in situation when `PNTToolbar` is `inputAccessoryView` of only one input view.
 */
@property (assign, nonatomic) BOOL shouldHideNavigationButtons;


/**
 *  Creates `PNTToolbar` instance
 *
 *  @return `PNTToolbar` instance with default settings.
 */
+ (PNTToolbar *)defaultToolbar;

@end
