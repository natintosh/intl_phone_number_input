# Intl Phone Number Input

A simple and customizable flutter package for inputting phone number in intl / international format uses Google's libphonenumber

| CustomDecoration | CustomBorder | Default |
|----------|-------------|--------|
| <img src="https://user-images.githubusercontent.com/27495055/80114512-9544b100-857b-11ea-9292-9c9c3eaf93e0.png" width="240" height="430" alt="Screenshot_1587652933"/> | <img src="https://user-images.githubusercontent.com/27495055/80115521-beb20c80-857c-11ea-9902-41c444a3bd33.png" width="240" height="430" alt="Screenshot_1587652933"/> | <img src="https://user-images.githubusercontent.com/27495055/80116034-63344e80-857d-11ea-9922-1062b4320503.png" width="240" height="430" alt="Screenshot_1587652933"/> |

| Web |
|-----|
| <img src="https://user-images.githubusercontent.com/27495055/103301956-c9257f80-4a02-11eb-8385-01564c2ec875.png" width=420 height=550></img>  |


### What's new
  - Replace libphonenumber_plugin with dlibphonenumber
  - Updated libphonenumber and PhoneNumberToCarrierMapper on Android
  - Removed dependency on libphonenumber
  - Switch from libphonenumber-iOS to PhoneNumberKit on iOS
  - Update libphonenumber.js file
  - Depreciating getNameForNumber in future updates
  
  
### Features
  - Support all Flutter platforms.
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
      this.selectorConfig = const SelectorConfig(),
      @required this.onInputChanged,
      this.onInputValidated,
      this.onSubmit,
      this.onFieldSubmitted,
      this.validator,
      this.onSaved,
      this.textFieldController,
      this.keyboardAction,
      this.keyboardType = TextInputType.phone,
      this.initialValue,
      this.hintText = 'Phone number',
      this.errorMessage = 'Invalid phone number',
      this.selectorButtonOnErrorPadding = 24,
      this.spaceBetweenSelectorAndTextField = 12,
      this.maxLength = 15,
      this.isEnabled = true,
      this.formatInput = true,
      this.autoFocus = false,
      this.autoFocusSearch = false,
      this.autoValidateMode = AutovalidateMode.disabled,
      this.ignoreBlank = false,
      this.countrySelectorScrollControlled = true,
      this.locale,
      this.textStyle,
      this.selectorTextStyle,
      this.inputBorder,
      this.inputDecoration,
      this.searchBoxDecoration,
      this.textAlign = TextAlign.start,
      this.textAlignVertical = TextAlignVertical.center,
      this.scrollPadding = const EdgeInsets.all(20.0),
      this.focusNode,
      this.cursorColor,
      this.autofillHints,
      this.countries
    });
```

```dart
SelectorConfig({
    this.selectorType = PhoneInputSelectorType.DROPDOWN,
    this.showFlags = true,
    this.useEmoji = false,
    this.countryComparator,
    this.setSelectorButtonAsPrefixIcon = false,
    this.useBottomSheetSafeArea = false,
});
```

| Parameter                           | Datatype               |    Initial Value          |
|---------------------------------    |------------------------|---------------------------|
| onInputChanged                      | function(PhoneNumber)  |        null               |
| onSaved                             | function(PhoneNumber)  |        null               |
| onInputValidated                    | function(bool)         |        null               |
| focusNode                           | FocusNode              |        null               |
| textFieldController                 | TextEditingController  |   TextEditingController() |
| onSubmit                            | Function()             |        null               |
| keyboardAction                      | TextInputAction        |        null               |
| keyboardType                        | TextInputType          |   TextInputType.phone     |
| countries                           | List<string>           |        null               |
| textStyle                           | TextStyle              |        null               |
| selectorTextStyle                   | TextStyle              |        null               |
| inputBorder                         | InputBorder            |        null               |
| inputDecoration                     | InputDecoration        |        null               |
| initialValue                        | PhoneNumber            |        null               |
| hintText                            | String                 |     Phone Number          |
| selectorButtonOnErrorPadding        | double                 |        24                 |
| spaceBetweenSelectorAndTextField    | double                 |        12                 |
| maxLength                           | integer                |        15                 |
| isEnabled                           | boolean                |        true               |
| autoFocus                           | boolean                |        false              |
| autoValidateMode                    | AutoValidateMode       | AutoValidateMode.disabled |
| formatInput                         | boolean                |        true               |
| errorMessage                        | String                 | Invalid phone number      |
| selectorConfig                      | SelectorConfig         | SelectorConfig()          |
| ignoreBlank                         | boolean                |       false               |
| locale                              | String                 |       null                |
| searchBoxDecoration                 | InputDecoration        |        null               |
| textAlign                           | TextAlign              |   TextAlign.start         |
| textAlignVertical                   | TextAlignVertical      | TextAlignVertical.center  |
| scrollPadding                       | EdgeInsets             | EdgeInsets.all(20.0)      |
| countrySelectorScrollControlled     | boolean                |        true               |
| cursorColor                         | String     \            |       null                |
| autofillHints                       | Iterable<String>       |       null                |

### Selector Types
| DROPDOWN | BOTTOMSHEET | DIALOG |
|----------|-------------|--------|
| <img src="https://user-images.githubusercontent.com/27495055/80116593-10a76200-857e-11ea-9600-f2cfef5b2965.png" height="430" alt="Screenshot_1587652933"/>         | <img src="https://user-images.githubusercontent.com/27495055/80116677-261c8c00-857e-11ea-8167-a3de563287f4.png" width="240" height="430" alt="Screenshot_1587652933"/>            | <img src="https://user-images.githubusercontent.com/27495055/80116721-3896c580-857e-11ea-84da-4efe13011d50.png" width="240" height="430" alt="Screenshot_1587652933"/>   |

## Advanced Usage Examples

### Basic Setup
```dart
class MyPhoneForm extends StatefulWidget {
  @override
  _MyPhoneFormState createState() => _MyPhoneFormState();
}

class _MyPhoneFormState extends State<MyPhoneForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'NG';
  PhoneNumber number = PhoneNumber(isoCode: 'NG');

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                print(number.phoneNumber);
              },
              onInputValidated: (bool value) {
                print(value);
              },
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                backgroundColor: Colors.black87,
              ),
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.disabled,
              selectorTextStyle: TextStyle(color: Colors.black),
              initialValue: number,
              textFieldController: controller,
              formatInput: false,
              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
              inputBorder: OutlineInputBorder(),
              onSaved: (PhoneNumber number) {
                print('On Saved: $number');
              },
            ),
            ElevatedButton(
              onPressed: () {
                formKey.currentState?.validate();
              },
              child: Text('Validate'),
            ),
            ElevatedButton(
              onPressed: () {
                getPhoneNumber(controller.text);
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');
    setState(() {
      this.number = number;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
```

### Custom Styling
```dart
InternationalPhoneNumberInput(
  onInputChanged: (PhoneNumber number) {},
  selectorConfig: SelectorConfig(
    selectorType: PhoneInputSelectorType.DROPDOWN,
    backgroundColor: Theme.of(context).backgroundColor,
    setSelectorButtonAsPrefixIcon: true,
    leadingPadding: 20,
    trailingSpace: false,
  ),
  textStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  ),
  selectorTextStyle: TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.bold,
  ),
  inputDecoration: InputDecoration(
    labelText: 'Phone Number',
    labelStyle: TextStyle(color: Colors.blue),
    hintText: 'Enter your phone number',
    hintStyle: TextStyle(color: Colors.grey),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.blue, width: 2),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
  spaceBetweenSelectorAndTextField: 16,
)
```

### Country Filtering
```dart
// Only allow North American countries
InternationalPhoneNumberInput(
  onInputChanged: (PhoneNumber number) {},
  countries: ['US', 'CA', 'MX'],
  selectorConfig: SelectorConfig(
    selectorType: PhoneInputSelectorType.DIALOG,
  ),
)

// Only allow European countries
InternationalPhoneNumberInput(
  onInputChanged: (PhoneNumber number) {},
  countries: ['GB', 'FR', 'DE', 'IT', 'ES', 'NL'],
  selectorConfig: SelectorConfig(
    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
    countryComparator: (Country a, Country b) => a.name!.compareTo(b.name!),
  ),
)
```

### Form Validation
```dart
class PhoneNumberForm extends StatefulWidget {
  @override
  _PhoneNumberFormState createState() => _PhoneNumberFormState();
}

class _PhoneNumberFormState extends State<PhoneNumberForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PhoneNumber? _phoneNumber;
  bool _isValidNumber = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) {
              _phoneNumber = number;
            },
            onInputValidated: (bool value) {
              setState(() {
                _isValidNumber = value;
              });
            },
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a phone number';
              }
              if (!_isValidNumber) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
            autoValidateMode: AutovalidateMode.onUserInteraction,
            errorMessage: 'Invalid phone number',
            inputDecoration: InputDecoration(
              labelText: 'Phone Number *',
              helperText: 'Required field',
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Phone number: ${_phoneNumber?.phoneNumber}')),
                );
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
```

### Working with Controllers
```dart
class ControllerExample extends StatefulWidget {
  @override
  _ControllerExampleState createState() => _ControllerExampleState();
}

class _ControllerExampleState extends State<ControllerExample> {
  final TextEditingController _phoneController = TextEditingController();
  PhoneNumber? _currentNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InternationalPhoneNumberInput(
          onInputChanged: (PhoneNumber number) {
            _currentNumber = number;
          },
          textFieldController: _phoneController,
          formatInput: true,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 20),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                _phoneController.text = '5551234567';
              },
              child: Text('Set US Number'),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                _phoneController.clear();
              },
              child: Text('Clear'),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text('Current: ${_currentNumber?.phoneNumber ?? 'None'}'),
      ],
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
```

## Troubleshooting

### Common Issues

#### Issue: "Invalid phone number" appears for valid numbers
**Solution:**
- Ensure the phone number includes the country code
- Use the `initialValue` parameter to set the correct country
- Check that the `isoCode` matches the phone number's country

```dart
// Correct way to set initial value
PhoneNumber initialValue = PhoneNumber(
  phoneNumber: '+1234567890', // Include country code
  isoCode: 'US',
  dialCode: '+1',
);
```

#### Issue: Country selector not opening
**Solution:**
- Make sure the widget is wrapped in a `MaterialApp` or `CupertinoApp`
- Check for any `GestureDetector` conflicts in parent widgets
- Verify that `isEnabled` is set to `true`

#### Issue: TextFormField validation not working
**Solution:**
- Wrap the widget in a `Form` widget
- Use `autoValidateMode` for real-time validation
- Implement both `validator` and `onInputValidated` callbacks

```dart
Form(
  child: InternationalPhoneNumberInput(
    autoValidateMode: AutovalidateMode.onUserInteraction,
    validator: (String? value) {
      // Your validation logic
      return null; // Return null if valid
    },
    onInputValidated: (bool isValid) {
      // Handle validation state
    },
  ),
)
```

#### Issue: Flag images not loading
**Solution:**
- Ensure you have added the assets to your `pubspec.yaml`:
```yaml
flutter:
  assets:
    - packages/intl_phone_number_input/assets/flags/
```
- Alternative: Use emoji flags instead:
```dart
SelectorConfig(
  useEmoji: true,
  showFlags: true,
)
```

#### Issue: Layout overflow in bottom sheet
**Solution:**
- Set `useBottomSheetSafeArea: true`
- Adjust `countrySelectorScrollControlled`
- Use a smaller device or test on different screen sizes

```dart
SelectorConfig(
  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
  useBottomSheetSafeArea: true,
  countrySelectorScrollControlled: true,
)
```

#### Issue: Performance issues with large country lists
**Solution:**
- Filter countries using the `countries` parameter
- Use pagination or search functionality in custom implementations

```dart
// Only show commonly used countries
InternationalPhoneNumberInput(
  countries: ['US', 'GB', 'CA', 'AU', 'FR', 'DE'],
  // ... other parameters
)
```

### Migration Guide

#### From version 0.7.x to current
- Update your `pubspec.yaml` to use the latest version
- Replace deprecated `getNameForNumber` calls (removed in 0.7.3)
- Update any custom `backgroundColor` usage in `SelectorConfig` (deprecated in 0.7.0)

#### Breaking Changes in 0.7.0
- `SelectorConfig.backgroundColor` deprecated - use theme colors instead
- Null safety migration - update null checks in your code
- Some internal API changes for better performance

### Performance Tips

1. **Limit Country List**: Use the `countries` parameter to show only relevant countries
2. **Optimize Flags**: Use `useEmoji: true` for better performance
3. **Lazy Loading**: Enable `countrySelectorScrollControlled` for large lists
4. **Debounce Input**: Implement debouncing for `onInputChanged` if making API calls

### Accessibility

- The widget supports screen readers out of the box
- Use `autofillHints` for better form completion
- Provide meaningful `inputDecoration.labelText` and `hintText`
- Test with TalkBack (Android) and VoiceOver (iOS)

### Testing
Widget Key parameters and Helper classes are now available for integration testing check out this example 🎯 [Integration Testing Example](https://gist.github.com/natintosh/b7b40d75240a65fdb63942a4b36753e5)

### Testing Helper Keys
```dart
// Use these keys for integration testing
find.byValueKey(TestHelper.TextInputKeyValue)          // Text input field
find.byValueKey(TestHelper.DropdownButtonKeyValue)     // Country selector
find.byValueKey(TestHelper.CountrySearchInputKeyValue) // Search field in popup
find.byValueKey(TestHelper.countryItemKeyValue('US'))  // Specific country item
```


# Contributions
If you encounter any problem or the library is missing a feature feel free to open an issue. Feel free to fork, improve the package and make pull request.

## Co-contributors
Interested in becoming a co-contributors checkout this link for more info [discussions/201](https://github.com/natintosh/intl_phone_number_input/discussions/201)

# Contributors 
<a href="https://github.com/natintosh/intl_phone_number_input/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=natintosh/intl_phone_number_input" />
</a>

Made with [contributors-img](https://contributors-img.web.app).

# Dependencies

* [dlibphonenumber](https://pub.dev/packages/dlibphonenumber)
* [equatable](https://pub.dev/packages/equatable)

# Credits

A special thanks to [niinyarko](https://github.com/niinyarko/flutter-international-phone-input)

# FAQ
* For discussions and frequent question and concerns, check [here](https://github.com/natintosh/intl_phone_number_input/discussions/159)
