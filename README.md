# Intl Phone Number Input

A simple and customizable flutter package for international phone number input

| CustomDecoration | CustomBorder | Default |
|----------|-------------|--------|
| <img src="https://user-images.githubusercontent.com/27495055/80114512-9544b100-857b-11ea-9292-9c9c3eaf93e0.png" width="240" height="430" alt="Screenshot_1587652933"/> | <img src="https://user-images.githubusercontent.com/27495055/80115521-beb20c80-857c-11ea-9902-41c444a3bd33.png" width="240" height="430" alt="Screenshot_1587652933"/> | <img src="https://user-images.githubusercontent.com/27495055/80116034-63344e80-857d-11ea-9922-1062b4320503.png" width="240" height="430" alt="Screenshot_1587652933"/> |

### What's new
    * Added selectorTextStyle parameter
    * Improve load up time
    * Added new initialValue parameter that accepts a PhoneNumber object
    * Added autoFocus option
    * Added support for integration testing
    * Added Keys and Helper class for testing
    * Updated static method getParsableNumber from PhoneNumber

### Features
    * Support for RTL languages
    * Selector mode dropdown, bottom sheet and dialog
    * As You Type Formatter: formats inputs to its selected international format
    * Get Region Info with PhoneNumber.getRegionInfoFromPhoneNumber(String phoneNumber, [String isoCode]);
    * Format PhoneNumber with PhoneNumber.getParsableNumber(String phoneNumber, String isoCode) or `PhoneNumber Reference`.parseNumber()
    * Custom list of countries e.g. ['NG', 'GH', 'BJ' 'TG', 'CI']
    
```dart
    String phoneNumber =  '+234 500 500 5005';
    PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber);
    String parsableNumber = number.parseNumber();
    `controller reference`.text = parsableNumber
```    

### Note
```dart 
   onInputChanged(PhoneNumber value) {
      setState((){});
   }
```
> :question: Calling setState inside onInputChanged and onInputValidated causes the Widget to rebuild multiple times and soft keyboard hidding after textfield is focused. Not fix is available yet I'm opened to suggestions and PRs on this issue

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
|  2  | InternationalPhoneNumberInput.withCustomDecoration      |
|  3  | InternationalPhoneNumberInput.withCustomBorder          |

## Available Parameters

```dart
InternationalPhoneNumberInput({
    Key key,
    this.selectorType,
    @required this.onInputChanged,
    this.onInputValidated,
    this.focusNode,
    this.textFieldController,
    this.onSubmit,
    this.keyboardAction,
    this.countries,
    this.textStyle,
    this.selectorTextStyle,
    this.inputBorder,
    this.inputDecoration,
    this.searchBoxDecoration,
    this.initialValue,
    this.hintText = 'Phone Number',
    this.isEnabled = true,
    this.autoFocus = false,
    this.autoValidate = false,
    this.formatInput = true,
    this.errorMessage = 'Invalid phone number',
    this.ignoreBlank = false,
    this.locale,
    this.countrySelectorScrollControlled = true,
    });
```

| Parameter                     | Datatype          |    Initial Value     |    Default [1]     |   Decoration [2]   |  CustomBorder [3]  |
|-------------------------------|-------------------|----------------------|--------------------|--------------------|--------------------|
| onInputChanged                | function(PhoneNumber)  |        null          | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| onInputValidated              | function(bool)    |        null          | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| focusNode                     | FocusNode         |        null          | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| textFieldController           | TextEditingController  |   TextEditingController() | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| onSubmit                      | Function()        |        null          | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| keyboardAction                | TextInputAction   |        null          | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| countries                     | List<string>      |        null          | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| textStyle                     | TextStyle         |        null          | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| selectorTextStyle             | TextStyle         |        null          | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| inputBorder                   | InputBorder       |        null          | :heavy_check_mark: |        :x:         | :heavy_check_mark: |
| inputDecoration               | InputDecoration   |        null          | :heavy_check_mark: | :heavy_check_mark: |        :x:         |
| initialValue                  | PhoneNumber       |        null          | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| hintText                      | String            |     Phone Number     | :heavy_check_mark: |        :x:         | :heavy_check_mark: |
| isEnabled                     | boolean           |        true          | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| autoFocus                     | boolean           |        false         | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| autoValidate                  | boolean           |        false         | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| formatInput                   | boolean           |        true          | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| errorMessage                  | String            | Invalid phone number | :heavy_check_mark: |        :x:         | :heavy_check_mark: |
| selectorType                  | PhoneInputSelectorType  | PhoneInputSelectorType.DROPDOWN | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| ignoreBlank                   | boolean           | false | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| locale                        | String            | null | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| searchBoxDecoration           | InputDecoration   |        null          | :heavy_check_mark: | :heavy_check_mark: | :x: |
| countrySelectorScrollControlled | boolean           |        true          | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |

### Selector Types
| DROPDOWN | BOTTOMSHEET | DIALOG |
|----------|-------------|--------|
| <img src="https://user-images.githubusercontent.com/27495055/80116593-10a76200-857e-11ea-9600-f2cfef5b2965.png" height="430" alt="Screenshot_1587652933"/>         | <img src="https://user-images.githubusercontent.com/27495055/80116677-261c8c00-857e-11ea-8167-a3de563287f4.png" width="240" height="430" alt="Screenshot_1587652933"/>            | <img src="https://user-images.githubusercontent.com/27495055/80116721-3896c580-857e-11ea-84da-4efe13011d50.png" width="240" height="430" alt="Screenshot_1587652933"/>   |

### Testing
Widget Key parameters and Helper classe are now available for integration testing check out this example 🎯 [Integration Testing Example](https://gist.github.com/natintosh/b7b40d75240a65fdb63942a4b36753e5)


# Contributions
If you encounter any problem or the library is missing a feature feel free to open an issue. Feel free to fork, improve the package and make pull request.

# Contributors 
<a href="https://github.com/natintosh/intl_phone_number_input/graphs/contributors">
  <img src="https://contributors-img.web.app/image?repo=natintosh/intl_phone_number_input" />
</a>

Made with [contributors-img](https://contributors-img.web.app).

# Dependencies

* [libphonenumber](https://pub.dev/packages/libphonenumber)
* [provider](https://pub.dev/packages/provider)

# Credits

A special thanks to [niinyarko](https://github.com/niinyarko/flutter-international-phone-input)
