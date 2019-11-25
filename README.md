# Intl Phone Number Input

A simple and customizable flutter package for international phone number input

### What's new
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
```PhoneNumber.getRegionInfoFromPhoneNumber(String phoneNumber, [String isoCode])````
> Could throw an Exception if the phoneNUmber isn't recognised its a good pattern to pass the country's isoCode or have '+' ahead of the phoneNumber 

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
    @required this.onInputChanged,
    this.onInputValidated,
    this.focusNode,
    this.textFieldController,
    this.onSubmit,
    this.keyboardAction,
    this.countries,
    this.inputBorder,
    this.inputDecoration,
    this.initialCountry2LetterCode = 'NG',
    this.hintText = '(800) 000-0001 23',
    this.shouldParse = true,
    this.shouldValidate = true,
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
| inputBorder                   | InputBorder       |        null          | :heavy_check_mark: |        :x:         | :heavy_check_mark: |
| inputDecoration               | InputDecoration   |        null          | :heavy_check_mark: | :heavy_check_mark: |        :x:         |
| initialCountry2LetterCode     | String            |         NG           | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| hintText                      | String            |  (800) 000-0001 23   | :heavy_check_mark: |        :x:         | :heavy_check_mark: |
| shouldParse                   | boolean           |        true          | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| shouldValidate                | boolean           |        true          | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| formatInput                   | boolean           |        true          | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| errorMessage                  | String            | Invalid phone number | :heavy_check_mark: |        :x:         | :heavy_check_mark: |


# Examples
```dart
InternationalPhoneNumberInput(
 onInputChanged: onPhoneNumberChanged,
);
```
![Media 1|100x200,20%](https://raw.githubusercontent.com/natintosh/intl-phone-number-input/master/media/media_1.gif)


```dart
InternationalPhoneNumberInput(
  onInputChanged: onPhoneNumberChanged,
  shouldParse: false,
  );
```
![Media 2](https://raw.githubusercontent.com/natintosh/intl-phone-number-input/master/media/media_2.gif)


```dart
InternationalPhoneNumberInput(
  onInputChanged: onPhoneNumberChanged,
  shouldParse: true,
  shouldValidate: true,
  initialCountry2LetterCode: 'US',
  hintText: 'Insert phone number',
  );
```
    
![Media 3](https://raw.githubusercontent.com/natintosh/intl-phone-number-input/master/media/media_3.gif)


```dart
InternationalPhoneNumberInput.withCustomBorder(
  onInputChanged: onPhoneNumberChanged,
  inputBorder: OutlineInputBorder(),
  hintText: '(100) 123-4567 8901',
  initialCountry2LetterCode: 'US',
  errorMessage: 'Wrong number',
);
```
![Media 4](https://raw.githubusercontent.com/natintosh/intl-phone-number-input/master/media/media_4.gif)


```dart
InternationalPhoneNumberInput.withCustomDecoration(
  onInputChanged: onPhoneNumberChanged,
  initialCountry2LetterCode: 'US',
  inputDecoration: InputDecoration(
    border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(40),
      ),
    ),
  ),
);
```
![Media 4](https://raw.githubusercontent.com/natintosh/intl-phone-number-input/master/media/media_5.gif)


```dart
InternationalPhoneNumberInput.withCustomDecoration(
  onInputChanged: onPhoneNumberChanged,
  onInputValidated: onInputChanged,
  initialCountry2LetterCode: 'US',
  inputDecoration: InputDecoration(
    hintText: 'Enter phone number',
    errorText: valid ? null : 'Invalid',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(40),
      ),
    ),
  ),
);
```
![Media 6](https://raw.githubusercontent.com/natintosh/intl-phone-number-input/master/media/media_6.gif)

# Dependencies

* [libphonenumber](https://pub.dev/packages/libphonenumber)

# Credits

A special thanks to [niinyarko](https://github.com/niinyarko/flutter-international-phone-input)
