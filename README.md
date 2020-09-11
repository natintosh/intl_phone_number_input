# Intl Phone Number Input

A simple and customizable flutter package for international phone number input

| CustomDecoration | CustomBorder | Default |
|----------|-------------|--------|
| <img src="https://user-images.githubusercontent.com/27495055/80114512-9544b100-857b-11ea-9292-9c9c3eaf93e0.png" width="240" height="430" alt="Screenshot_1587652933"/> | <img src="https://user-images.githubusercontent.com/27495055/80115521-beb20c80-857c-11ea-9902-41c444a3bd33.png" width="240" height="430" alt="Screenshot_1587652933"/> | <img src="https://user-images.githubusercontent.com/27495055/80116034-63344e80-857d-11ea-9922-1062b4320503.png" width="240" height="430" alt="Screenshot_1587652933"/> |

### What's new
  - Fixed issue with text input autoFocus when formatInput is set to false
  - Added new locale translations for ["sk" "se" "pl" "no" "ja" "it" "zh" "nl" "de" "fr" "es" "en" "pt_BR"]
    - Made possible by [@SimonFM](https://github.com/SimonFM) and [@diefferson](https://github.com/diefferson)
  - Added selector configuration `selectorConfig` parameter which enables you to
    - Add emoji flag support
    - Add option to turn off flags
  - <b>Breaking Change</b> `selectorType` has been moved to `selectorConfig`
  - Fixed autoFocus search search field
  - Fixed keyboard covers bottom sheet while search
  - <b>Breaking Change</b> Removed factory constructors `withCustomBorder` and `withCustomDecoration`

### Features
  - Support for RTL languages
  - Selector mode dropdown, bottom sheet and dialog
  - As You Type Formatter: formats inputs to its selected international format
  - Get Region Info with PhoneNumber.getRegionInfoFromPhoneNumber(String phoneNumber, [String isoCode]);
  - Format PhoneNumber with PhoneNumber.getParsableNumber(String phoneNumber, String isoCode) or `PhoneNumber Reference`.parseNumber()
  - Custom list of countries e.g. ['NG', 'GH', 'BJ' 'TG', 'CI']
    
```dart
    String phoneNumber =  '+234 500 500 5005';
    PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber);
    String parsableNumber = number.parseNumber();
    `controller reference`.text = parsableNumber
```    

### Note
``` dart
    PhoneNumber.getRegionInfoFromPhoneNumber(String phoneNumber, [String isoCode])
```
> Could throw an Exception if the phoneNumber isn't recognised its a good pattern to pass the country's isoCode or have '+' at the beginning of the string

> isoCode could be null if PhoneNumber is not recognised

# Usage

### Constructors

| s/n | Constructor                                             |
| --- | ------------------------------------------------------- |
|  1  | InternationalPhoneNumberInput                           |

## Available Parameters

```dart
InternationalPhoneNumberInput({
    Key key,
    this.selectorType = const SelectorConfig(),
    @required this.onInputChanged,
    this.onInputValidated,
    this.onSubmit,
    this.onFieldSubmitted,
    this.validator,
    this.onSaved,
    this.textFieldController,
    this.keyboardAction,
    this.initialValue,
    this.hintText = 'Phone number',
    this.errorMessage = 'Invalid phone number',
    this.selectorButtonOnErrorPadding = 24,
    this.maxLength = 15,
    this.isEnabled = true,
    this.formatInput = true,
    this.autoFocus = false,
    this.autoFocusSearch = false,
    this.autoValidate = false,
    this.ignoreBlank = false,
    this.countrySelectorScrollControlled = true,
    this.locale,
    this.textStyle,
    this.selectorTextStyle,
    this.inputBorder,
    this.inputDecoration,
    this.searchBoxDecoration,
    this.focusNode,
    this.countries
    });
```|

```dart
SelectorConfig({
    this.selectorType = PhoneInputSelectorType.DROPDOWN,
    this.showFlags = true,
    this.useEmoji = false,
});
```

| Parameter                     | Datatype          |    Initial Value     |
|-------------------------------|-------------------|----------------------|
| onInputChanged                | function(PhoneNumber)  |        null          |
| onInputValidated              | function(bool)    |        null          |
| focusNode                     | FocusNode         |        null          |
| textFieldController           | TextEditingController  |   TextEditingController() |
| onSubmit                      | Function()        |        null          |
| keyboardAction                | TextInputAction   |        null          |
| countries                     | List<string>      |        null          |
| textStyle                     | TextStyle         |        null          |
| selectorTextStyle             | TextStyle         |        null          |
| inputBorder                   | InputBorder       |        null          |
| inputDecoration               | InputDecoration   |        null          |
| initialValue                  | PhoneNumber       |        null          |
| hintText                      | String            |     Phone Number     |
| selectorButtonOnErrorPadding  | double            |        24            |
| maxLength                     | integer           |        15            |
| isEnabled                     | boolean           |        true          |
| autoFocus                     | boolean           |        false         |
| autoValidate                  | boolean           |        false         |
| formatInput                   | boolean           |        true          |
| errorMessage                  | String            | Invalid phone number |
| selectorConfig                | SelectorConfig  | PhoneInputSelectorType.DROPDOWN |
| ignoreBlank                   | boolean           |       false          |
| locale                        | String            |       null           |
| searchBoxDecoration           | InputDecoration   |        null          |
| countrySelectorScrollControlled | boolean           |        true          |

### Selector Types
| DROPDOWN | BOTTOMSHEET | DIALOG |
|----------|-------------|--------|
| <img src="https://user-images.githubusercontent.com/27495055/80116593-10a76200-857e-11ea-9600-f2cfef5b2965.png" height="430" alt="Screenshot_1587652933"/>         | <img src="https://user-images.githubusercontent.com/27495055/80116677-261c8c00-857e-11ea-8167-a3de563287f4.png" width="240" height="430" alt="Screenshot_1587652933"/>            | <img src="https://user-images.githubusercontent.com/27495055/80116721-3896c580-857e-11ea-84da-4efe13011d50.png" width="240" height="430" alt="Screenshot_1587652933"/>   |

### Testing
Widget Key parameters and Helper classes are now available for integration testing check out this example 🎯 [Integration Testing Example](https://gist.github.com/natintosh/b7b40d75240a65fdb63942a4b36753e5)


# Contributions
If you encounter any problem or the library is missing a feature feel free to open an issue. Feel free to fork, improve the package and make pull request.

# Contributors 
<a href="https://github.com/natintosh/intl_phone_number_input/graphs/contributors">
  <img src="https://contributors-img.web.app/image?repo=natintosh/intl_phone_number_input" />
</a>

Made with [contributors-img](https://contributors-img.web.app).

# Dependencies

* [libphonenumber](https://pub.dev/packages/libphonenumber)
* [equatable](https://pub.dev/packages/equatable)

# Credits

A special thanks to [niinyarko](https://github.com/niinyarko/flutter-international-phone-input)
