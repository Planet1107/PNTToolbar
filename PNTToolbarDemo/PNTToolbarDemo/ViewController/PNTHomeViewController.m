//
//  PNTHomeViewController.m
//  PNTToolbarDemo
//
//  Created by Planet 1107 on 21/11/13.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#import "PNTHomeViewController.h"
#import "PNTToolbar.h"

@implementation PNTHomeViewController


#pragma mark - Object lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self.scrollViewForm addSubview:self.viewContentForm];
    self.scrollViewForm.contentSize = self.viewContentForm.frame.size;
    
    [self.datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.textFieldPickerView.inputView = self.pickerView;
    self.textFieldDatePicker.inputView = self.datePicker;
    
    PNTToolbar *toolbar = [PNTToolbar defaultToolbar];
    toolbar.navigationButtonsTintColor = [UIColor redColor];
    toolbar.mainScrollView = self.scrollViewForm;
    toolbar.inputFields = @[self.textFieldKeyboard, self.textFieldTwo1, self.textFieldTwo2, self.textView, self.textFieldDatePicker, self.textFieldPickerView];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIDatePicker methods

- (void)datePickerValueChanged:(UIDatePicker *)datePicker {
    
    self.textFieldDatePicker.text = datePicker.date.description;
}


#pragma mark - UIPickerViewDataSource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return 10;
}

#pragma mark - UIPickerViewDelegate methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [@(row).stringValue stringByAppendingString:@". row"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.textFieldPickerView.text = [@(row).stringValue stringByAppendingString:@". row"];
}

@end
