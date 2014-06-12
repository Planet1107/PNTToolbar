#PNTToolbar

Simple class which adds Safari like toolbar to keyboard and handles switching between input fields.

![alt preview](https://raw.githubusercontent.com/Planet1107/PNTToolbar/master/preview.gif)

##Basic Usage

```objective-c
PNTToolbar *toolbar = [PNTToolbar defaultToolbar];
toolbar.mainScrollView = self.scrollViewForm;
toolbar.inputFields = @[self.textFieldKeyboard, self.textView, self.textFieldDatePicker, self.textFieldPickerView];
```

##Installation

###CocoaPods

```ruby
platform :ios, '7.0'
pod 'PNTToolbar', '~> 0.1.6'
```

###Manual

Just drag and drop PNTToolbar folder into your project

##How it works

When you set the text fields property, instance of this class becames delegate to all text fields. Object implements delegate methods and calculates scrolling behaviour. If you need custom delegate behaviour, you can set delegates property of object where you can set delegate for every text field which you provide.
