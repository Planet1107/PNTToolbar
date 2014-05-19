#PNTToolbar

Simple class which adds Safari like toolbar to keyboard and handles switching between input fields.

![alt preview](https://raw.githubusercontent.com/jcavar/PNTToolbar/master/preview.gif)

##Basic Usage

```objective-c
PNTToolbar *inputViewToolbar = [PNTToolbar defaultToolbar];
inputViewToolbar.textFields = @[self.textField1, self.textView2, self.textField3, self.textField4, self.textField5];
inputViewToolbar.mainScrollView = self.scrollViewMain;
```

##Installation

###CocoaPods

```ruby
platform :ios, '7.0'
pod 'PNTToolbar', '~> 0.1.3'
```

###Manual

Just drag and drop PNTToolbar folder into your project

##How it works

When you set the text fields property, instance of this class becames delegate to all text fields. Object implements delegate methods and calculates scrolling behaviour. If you need custom delegate behaviour, you can set delegates property of object where you can set delegate for every text field which you provide.