//
//  PLToolbar.m v1.3
//
//  Created by Planet 1107 on 11/4/13.
//

#import "PNTToolbar.h"

@implementation PNTToolbar

#pragma mark - Object lifecycle

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        previousButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Previous",nil) style:UIBarButtonItemStyleBordered target:self action:@selector(previousField:)] ;
        nextButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Next",nil) style:UIBarButtonItemStyleBordered target:self action:@selector(nextField:)];
        UIBarButtonItem *spaceBetweenButtons = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard:)];
        if (self.hidePrevNextButtons) {
            [self setItems:[NSArray arrayWithObjects:spaceBetweenButtons, doneButton, nil] ];
        } else {
            [self setItems:[NSArray arrayWithObjects:previousButton, nextButton, spaceBetweenButtons, doneButton, nil] ];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

+ (PNTToolbar *)defaultToolbar {
    
    PNTToolbar *toolbar = [[PNTToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    toolbar.barStyle = UIBarStyleDefault;
    return toolbar;
}


#pragma mark - Setter methods

- (void)setTextFields:(NSArray *)textFields {
    
    _textFields = textFields;
    NSMutableArray* delegates = [NSMutableArray array];
    for (UITextField* textField in textFields) {
        if (textField.delegate && textField.delegate != self) {
            [delegates addObject:textField.delegate];
        } else {
            [delegates addObject:[NSNull null]];
        }
        textField.delegate = self;
        textField.inputAccessoryView = self;
    }
    self.delegates = delegates;
}

- (void)setMainScrollView:(UIScrollView *)mainScrollView {
    
    _mainScrollView = mainScrollView;
    //mainScrollViewInitialFrame = mainScrollView.frame;
}


#pragma mark - Keyboard methods

- (void)resignKeyboard:(id)sender {
    
    [self keyboardWillHide:nil];
    for (UITextField* textField in self.textFields) {
        [textField resignFirstResponder];
    }
}

- (void)keyboardDidShow:(NSNotification *)notification {
    
    if (!self.keyboardVisible) {
        self.keyboardVisible = YES;
    }
    NSDictionary* info = notification.userInfo;
    keyboardSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    
    int windowHeight = self.mainScrollView.window.frame.size.height;
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        windowHeight = self.mainScrollView.window.frame.size.width;
        keyboardSize = CGSizeMake(keyboardSize.height, keyboardSize.width);
    }
    CGPoint keyboardInViewPoint = [self.mainScrollView.superview convertPoint:CGPointMake(0, windowHeight - keyboardSize.height) fromView:nil];
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        keyboardInViewPoint = CGPointMake(keyboardInViewPoint.y, self.mainScrollView.window.frame.size.height - keyboardInViewPoint.x);
    }
    CGRect scrollViewFrame = self.mainScrollView.frame;
    scrollViewFrame.size.height = keyboardInViewPoint.y - CGRectGetMinY(scrollViewFrame);
    [UIView animateWithDuration:KEYBOARD_ANIMATION_DURATION animations:^{
        self.mainScrollView.frame = scrollViewFrame;
    } completion:^(BOOL finished) {
        UITextField *textField = nil;
        for (UIResponder *tf in self.textFields) {
            if (tf.isFirstResponder) {
                textField = (UITextField *)tf;
                break;
            }
        }
        [self scrollRectToVisible:textField.frame animated:YES];
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    [UIView animateWithDuration:KEYBOARD_ANIMATION_DURATION animations:^{
        self.mainScrollView.frame = mainScrollViewInitialFrame;
    } ];
    self.keyboardVisible = NO;
}


#pragma mark - Button methods

- (void)previousField:(id)sender {
    
    NSUInteger indexOfActiveTextFiled = [self.textFields indexOfObjectPassingTest:^BOOL(UITextField* textField, NSUInteger idx, BOOL* stop) {
        return textField.isFirstResponder;
    }];
    if (indexOfActiveTextFiled > 0) {
        [self.textFields[indexOfActiveTextFiled-1] becomeFirstResponder];
    }
}

- (void)nextField:(id)sender {
    
    NSUInteger indexOfActiveTextFiled = [self.textFields indexOfObjectPassingTest:^BOOL(UITextField* textField, NSUInteger idx, BOOL* stop) {
        return textField.isFirstResponder;
    }];
    if (indexOfActiveTextFiled < self.textFields.count-1) {
        [self.textFields[indexOfActiveTextFiled+1] becomeFirstResponder];
    }
}


#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (!self.keyboardVisible) {
        mainScrollViewInitialFrame = self.mainScrollView.frame;
    }
    [self scrollRectToVisible:textField.frame animated:YES];

    NSUInteger index = [self.textFields indexOfObject:textField];
    if ([self.delegates[index] respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.delegates[index] textFieldDidBeginEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSUInteger index = [self.textFields indexOfObject:textField];
    if ([self.delegates[index] respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.delegates[index] textFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger index = [self.textFields indexOfObject:textField];
    if ([self.delegates[index] respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.delegates[index] textField:textField shouldChangeCharactersInRange:range replacementString:string];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    NSUInteger index = [self.textFields indexOfObject:textField];
    if ([self.delegates[index] respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [self.delegates[index] textFieldShouldBeginEditing:textField];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    NSUInteger index = [self.textFields indexOfObject:textField];
    if ([self.delegates[index] respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [self.delegates[index] textFieldShouldEndEditing:textField];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    NSUInteger index = [self.textFields indexOfObject:textField];
    if ([self.delegates[index] respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [self.delegates[index] textFieldShouldClear:textField];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    NSUInteger index = [self.textFields indexOfObject:textField];
    if ([self.delegates[index] respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [self.delegates[index] textFieldShouldReturn:textField];
    } else {
        return YES;
    }
}

#pragma mark - UITextViewDelegate methods

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if (!self.keyboardVisible) {
        mainScrollViewInitialFrame = self.mainScrollView.frame;
    }
    [self scrollRectToVisible:textView.frame animated:YES];

    NSUInteger index = [self.textFields indexOfObject:textView];
    if ([self.delegates[index] respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [self.delegates[index] textViewDidBeginEditing:textView];
    }
    
}

- (void)textViewDidChange:(UITextView *)textView {
    
    NSUInteger index = [self.textFields indexOfObject:textView];
    if ([self.delegates[index] respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegates[index] textViewDidChange:textView];
    }
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    NSUInteger index = [self.textFields indexOfObject:textView];
    if ([self.delegates[index] respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        return [self.delegates[index] textViewShouldBeginEditing:textView];
    } else {
        return YES;
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    NSUInteger index = [self.textFields indexOfObject:textView];
    if ([self.delegates[index] respondsToSelector:@selector(textViewShouldEndEditing:)]) {
        return [self.delegates[index] textViewShouldEndEditing:textView];
    } else {
        return YES;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    NSUInteger index = [self.textFields indexOfObject:textView];
    if ([self.delegates[index] respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [self.delegates[index] textViewDidEndEditing:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSUInteger index = [self.textFields indexOfObject:textView];
    if ([self.delegates[index] respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        return [self.delegates[index] textView:textView shouldChangeTextInRange:range replacementText:text];
    } else {
        return YES;
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    
    NSUInteger index = [self.textFields indexOfObject:textView];
    if ([self.delegates[index] respondsToSelector:@selector(textViewDidChangeSelection:)]) {
        [self.delegates[index] textViewDidChangeSelection:textView];
    }
}


#pragma mark - Other methods and functions

- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated {
    
    rect.origin.y -= 5;
    rect.size.height += 10;
    
    
    int windowHeight = self.mainScrollView.window.frame.size.height;
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        windowHeight = self.mainScrollView.window.frame.size.width;
        keyboardSize = CGSizeMake(keyboardSize.height, keyboardSize.width);
    }
    CGPoint keyboardInViewPoint = [self.mainScrollView.superview convertPoint:CGPointMake(0, windowHeight - keyboardSize.height) fromView:nil];
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        keyboardInViewPoint = CGPointMake(keyboardInViewPoint.y, self.mainScrollView.window.frame.size.height - keyboardInViewPoint.x);
    }
    CGRect scrollViewFrame = self.mainScrollView.frame;
    int visibleHeight = keyboardInViewPoint.y - CGRectGetMinY(scrollViewFrame);
    

    if (rect.size.height > visibleHeight) {
        rect.size.height = visibleHeight - 30;
    }
    [self.mainScrollView scrollRectToVisible:rect animated:animated];
}

@end