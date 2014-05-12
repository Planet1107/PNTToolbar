//
//  PNTHomeViewController.h
//  PNTToolbarDemo
//
//  Created by Planet 1107 on 21/11/13.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PNTHomeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewForm;
@property (strong, nonatomic) IBOutlet UIView *viewContentForm;

@property (strong, nonatomic) IBOutlet UITextField *textFieldKeyboard;
@property (strong, nonatomic) IBOutlet UITextField *textFieldTwo1;
@property (strong, nonatomic) IBOutlet UITextField *textFieldTwo2;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UITextField *textFieldDatePicker;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPickerView;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

@end
