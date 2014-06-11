//
//  PNTToolbar.m
//
//  Created by Planet 1107
//

#import "PNTToolbar.h"

@interface PNTToolbar () <UITextFieldDelegate>

@property (assign, nonatomic) BOOL shouldReturnActivated;

@property (strong, nonatomic) UIBarButtonItem *barButtonItemPrevious;
@property (strong, nonatomic) UIBarButtonItem *barButtonItemNext;
@property (strong, nonatomic) UIBarButtonItem *barButtonItemDone;

@property (assign, nonatomic) CGRect keyboardFrame;

@end

@implementation PNTToolbar

#pragma mark - Object lifecycle

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        _barButtonItemPrevious = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Previous",nil) style:UIBarButtonItemStyleBordered target:self action:@selector(barButtonItemPreviousTouchUpInside:)] ;
        _barButtonItemNext = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Next",nil) style:UIBarButtonItemStyleBordered target:self action:@selector(barButtonItemNextTouchUpInside:)];
        UIBarButtonItem *spaceBetweenButtons = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        _barButtonItemDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(barButtonItemDoneTouchUpInside:)];
        if (self.shouldHideNavigationButtons) {
            self.items = @[spaceBetweenButtons, _barButtonItemDone];
        } else {
            self.items = @[_barButtonItemPrevious, _barButtonItemNext, spaceBetweenButtons, _barButtonItemDone];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

+ (PNTToolbar *)defaultToolbar {
    
    PNTToolbar *toolbar = [[PNTToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    toolbar.barStyle = UIBarStyleDefault;
    return toolbar;
}


#pragma mark - Setter methods

- (void)setTextFields:(NSArray *)textFields {
    
    _textFields = textFields;
    NSMutableArray *delegates = [NSMutableArray array];
    for (UITextField *textField in textFields) {
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

- (void)setNavigationButtonsTintColor:(UIColor *)navigationButtonsTintColor {

    _navigationButtonsTintColor = navigationButtonsTintColor;
    self.barButtonItemPrevious.tintColor = navigationButtonsTintColor;
    self.barButtonItemNext.tintColor = navigationButtonsTintColor;
    self.barButtonItemDone.tintColor = navigationButtonsTintColor;
}


#pragma mark - Keyboard methods

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    
    CGRect keyboardEndFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardFrame = [self.mainScrollView.superview convertRect:keyboardEndFrame fromView:nil];
    UIViewAnimationCurve curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    UIViewAnimationOptions options = (curve << 16) | UIViewAnimationOptionBeginFromCurrentState;
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect newFrame = self.mainScrollView.frame;
    newFrame.size.height = self.keyboardFrame.origin.y;
    
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        self.mainScrollView.frame = newFrame;
    } completion:nil];
}


#pragma mark - Button methods

- (void)barButtonItemPreviousTouchUpInside:(id)sender {
    
    NSUInteger indexOfActiveTextFiled = [self.textFields indexOfObjectPassingTest:^BOOL(UITextField *textField, NSUInteger idx, BOOL* stop) {
        return textField.isFirstResponder;
    }];
    if (indexOfActiveTextFiled > 0) {
        [self.textFields[indexOfActiveTextFiled-1] becomeFirstResponder];
    }
}

- (void)barButtonItemNextTouchUpInside:(id)sender {
    
    NSUInteger indexOfActiveTextFiled = [self.textFields indexOfObjectPassingTest:^BOOL(UITextField *textField, NSUInteger idx, BOOL* stop) {
        return textField.isFirstResponder;
    }];
    if (indexOfActiveTextFiled < self.textFields.count-1) {
        [self.textFields[indexOfActiveTextFiled+1] becomeFirstResponder];
    }
}

- (void)barButtonItemDoneTouchUpInside:(id)sender {
    
    for (UITextField *textField in self.textFields) {
        [textField resignFirstResponder];
    }
}


#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    CGRect frameToScroll = [self.mainScrollView convertRect:textField.frame fromView:textField.superview];
    [self scrollRectToVisible:frameToScroll animated:YES];

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
    
    BOOL shouldEndEditing = NO;
    NSUInteger index = [self.textFields indexOfObject:textField];
    if ([self.delegates[index] respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        shouldEndEditing = [self.delegates[index] textFieldShouldEndEditing:textField];
    } else {
        shouldEndEditing = YES;
    }
    if (self.shouldReturnActivated && shouldEndEditing) {
        for (UITextField *textField in self.textFields) {
            [textField resignFirstResponder];
        }
    }
    self.shouldReturnActivated = NO;
    return shouldEndEditing;
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
    
    NSUInteger index = [self.textFields indexOfObject:textField];
    if ([self.delegates[index] respondsToSelector:@selector(textFieldShouldReturn:)]) {
        self.shouldReturnActivated = [self.delegates[index] textFieldShouldReturn:textField];
        return self.shouldReturnActivated;
    } else {
        self.shouldReturnActivated = YES;
        [textField resignFirstResponder];
        return self.shouldReturnActivated;
    }
}


#pragma mark - UITextViewDelegate methods

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    CGRect frameToScroll = [self.mainScrollView convertRect:textView.frame fromView:textView.superview];
    [self scrollRectToVisible:frameToScroll animated:YES];

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
    
    [self.mainScrollView scrollRectToVisible:CGRectInset(rect, 0, -TEXT_FIELD_INSET) animated:animated];
}

@end