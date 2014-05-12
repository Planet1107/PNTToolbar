#PNTToolbar

Simple class which adds Safari like toolbar to keyboard and handles switching between input fields.

<img src="https://raw.githubusercontent.com/jcavar/PNTToolbar/master/preview.gif" alt="preview" style="width: 100px;height: 100px;"/>
![alt preview](https://raw.githubusercontent.com/jcavar/PNTToolbar/master/preview.gif =200x400)

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
