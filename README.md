# Intl Phone Number Input

A simple and customizable flutter package for international phone number input

### What's new
    * As You Type Formatter: The Package now formats the input to it's selected national format
    * You can now disable input formatting by setting inputFormat to false
    * Replaced TextField with 
    * AutoValidate
    * TextStyle
    * onInputChanged now returns a new PhoneNumber Model
    * You can create a PhoneNumber object from PhoneNumber.getRegionInfoFromPhoneNumber(String phoneNumber, [String isoCode]); 
    * You can now parse phoneNumber by calling   PhoneNumber.getParsableNumber(String phoneNumber, String isoCode) or `PhoneNumber Reference`.parseNumber()
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
    this.initialCountry2LetterCode = 'NG',
    this.hintText = 'Phone Number',
    this.autoValidate = false,
    this.formatInput = true,
    this.errorMessage = 'Invalid phone number',
    });
```

| Parameter                     | Datatype          |    Initial Value     |    Default [1]     |   Decoration [2]   |  CustomBorder [3]  |
|-------------------------------|-------------------|----------------------|--------------------|--------------------|--------------------|
| onInputChange                 | function(PhoneNumber)  |        null          | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| onInputValidated              | function(string)  |        null          | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| focusNode                     | FocusNode         |        null          | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| textFieldController   | TextEditingController  |   TextEditingController() | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| onSubmit              | Function()         |        null          | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| keyboardAction      | TextInputAction  |        null          | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| countries                     | List<string>      |        null          | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| textStyle                     | TextStyle      |        null          | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| inputBorder                   | InputBorder       |        null          | :heavy_check_mark: |        :x:         | :heavy_check_mark: |
| inputDecoration               | InputDecoration   |        null          | :heavy_check_mark: | :heavy_check_mark: |        :x:         |
| initialCountry2LetterCode     | String            |         NG           | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| hintText                      | String            |  Phone Number   | :heavy_check_mark: |        :x:         | :heavy_check_mark: |
| autoValidate                | boolean           |        true          | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| formatInput                   | boolean           |        true          | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| errorMessage                  | String            | Invalid phone number | :heavy_check_mark: |        :x:         | :heavy_check_mark: |


# Contribution 
If you encounter any problems feel free to open an issue. If you feel the library is missing a feature, please raise a ticket on the Repo and I'll look into it. Pull request are also welcome.

# Dependencies

* [libphonenumber](https://pub.dev/packages/libphonenumber)

# Credits

A special thanks to [niinyarko](https://github.com/niinyarko/flutter-international-phone-input)
