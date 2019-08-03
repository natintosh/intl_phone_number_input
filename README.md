# Intl Phone Number Input

A single and customizable flutter package for internation phone number input


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
 onInputChange: onPhoneNumberChanged,
);
```
()[]


```dart
InternationalPhoneNumberInput(
  onInputChange: onPhoneNumberChanged,
  shouldParse: false,
  );
```
()[]


```dart
InternationalPhoneNumberInput(
  onInputChange: onPhoneNumberChanged,
  shouldParse: true,
  shouldValidate: true,
  initialCountry2LetterCode: 'US',
  hintText: 'Insert phone number',
  );
```
    
()[]


```dart
InternationalPhoneNumberInput.withCustomBorder(
  onInputChange: onPhoneNumberChanged,
  inputBorder: OutlineInputBorder(),
  hintText: '(100) 123-4567 8901',
  initialCountry2LetterCode: 'US',
  errorMessage: 'Wrong number',
);
```
()[]


```dart
InternationalPhoneNumberInput.withCustomDecoration(
  onInputChange: onPhoneNumberChanged,
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
()[]


```dart
InternationalPhoneNumberInput.withCustomDecoration(
  onInputChange: onPhoneNumberChanged,
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
()[]



# Credits

A special thanks to [niinyarko](https://github.com/niinyarko/flutter-international-phone-input) for the inspiration
