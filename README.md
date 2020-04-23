# Intl Phone Number Input

A simple and customizable flutter package for international phone number input

### What's new
    * Added new initialValue parameter that accepts a PhoneNumber object
    * Added autoFocus option
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
``` dart
    PhoneNumber.getRegionInfoFromPhoneNumber(String phoneNumber, [String isoCode])
```
> Could throw an Exception if the phoneNumber isn't recognised its a good pattern to pass the country's isoCode or have '+' at the beginning of the string

# Usage
## Constructors

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

# Contributions
If you encounter any problem or the library is missing a feature feel free to open an issue. Feel free to fork, improve the package and make pull request.

# Dependencies

* [libphonenumber](https://pub.dev/packages/libphonenumber)

# Credits

A special thanks to [niinyarko](https://github.com/niinyarko/flutter-international-phone-input)
