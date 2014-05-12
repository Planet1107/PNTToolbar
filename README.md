#PNTToolbar

Simple class which adds Safari like toolbar to keyboard and handles switching between input fields.

##Usage

```objc
self.inputViewToolbar = [PNTToolbar defaultToolbar];
self.inputViewToolbar.textFields = @[self.textField1, self.textField2, self.textField3, self.textField4, self.textField5];
self.inputViewToolbar.mainScrollView = self.scrollViewMain;
```

##Installation

###CocoaPods

```ruby
platform :ios, '7.0'
pod 'PNTToolbar', '~> 0.1.3'
```

###Manual

Just drag and drop PNTToolbar folder into your project
