# Intl Phone Number Input

A single and customizable flutter package for international phone number input

### What's new
    * Added focus node
    * Custom list of countries e.g. ['NG', 'GH', 'BJ' 'TG', 'CI']
    * Country Flag and Logo now formatted

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
@required onInputChange,
      onInputValidated,
      focusNode,
      countries,
      inputBorder,
      inputDecoration,
      initialCountry2LetterCode = 'NG',
      hintText = '(800) 000-0001 23',
      shouldParse = true,
      shouldValidate = true,
      formatInput = true,
      errorMessage = 'Invalid phone number'});
```

| Parameter                     | Datatype          |    Initial Value     |    Default [1]     |   Decoration [2]   |  CustomBorder [3]  |
|-------------------------------|-------------------|----------------------|--------------------|--------------------|--------------------|
| onInputChange                 | function(string)  |        null          | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| onInputValidated              | function(string)  |        null          | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| focusNode                     | FocusNode         |        null          | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
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
