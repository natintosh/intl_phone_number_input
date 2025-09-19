# Example Applications

This directory contains comprehensive examples demonstrating various features and use cases of the `intl_phone_number_input` package.

## Examples Overview

### 1. Basic Example (`basic_example.dart`)
- Simple phone number input implementation
- Country selection and validation
- Basic callbacks and state management
- Perfect starting point for new implementations

### 2. Validation Example (`validation_example.dart`)
- Real-time validation with visual feedback
- Form integration with proper validation
- Custom validation rules and error handling
- Best practices for form submission

### 3. Styling Example (`styling_example.dart`)
- Multiple styling approaches and themes
- Custom colors, borders, and decorations
- Material Design integration
- Responsive design patterns
- Custom flag displays and country filtering

### 4. Advanced Example (`advanced_example.dart`)
- PhoneNumber API demonstrations
- Controller management and focus handling
- Comprehensive callback usage
- Real-time configuration changes
- Complex state management patterns

## Running the Examples

### Option 1: Run Individual Examples
Navigate to the example directory and run any specific example:

```bash
cd example
flutter run lib/basic_example.dart
flutter run lib/validation_example.dart
flutter run lib/styling_example.dart
flutter run lib/advanced_example.dart
```

### Option 2: Use the Main Example App
The main example app (`lib/main.dart`) provides a navigation interface to all examples:

```bash
cd example
flutter run
```

## Key Learning Points

### Basic Implementation
- Always handle the `onInputChanged` callback to receive phone number updates
- Use `selectorConfig` to customize country selector appearance
- Implement proper form validation for production apps

### Validation Best Practices
- Use `autoValidateMode` for real-time validation feedback
- Implement custom validators for specific business requirements
- Handle edge cases like empty input and incomplete numbers

### Styling Guidelines
- Leverage `inputDecoration` for consistent Material Design styling
- Use `selectorConfig` for country selector customization
- Consider accessibility when customizing colors and contrast

### Advanced Usage
- Utilize `textFieldController` for programmatic control
- Implement `focusNode` for complex navigation flows
- Use the PhoneNumber API for advanced number manipulation

## Common Patterns

### Form Integration
```dart
Form(
  key: _formKey,
  child: InternationalPhoneNumberInput(
    onInputChanged: (PhoneNumber number) {
      // Handle phone number changes
    },
    validator: (String? value) {
      // Custom validation logic
      return null;
    },
    autoValidateMode: AutovalidateMode.onUserInteraction,
  ),
)
```

### Controller Usage
```dart
final TextEditingController _controller = TextEditingController();

InternationalPhoneNumberInput(
  textFieldController: _controller,
  onInputChanged: (PhoneNumber number) {
    // number contains the complete phone number data
  },
)
```

### Custom Styling
```dart
InternationalPhoneNumberInput(
  selectorConfig: SelectorConfig(
    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
    backgroundColor: Colors.blue,
    showFlags: true,
  ),
  inputDecoration: InputDecoration(
    labelText: 'Phone Number',
    border: OutlineInputBorder(),
  ),
)
```

## Testing Your Implementation

Each example includes testing patterns you can adapt:

1. **Unit Testing**: Test phone number validation and formatting
2. **Widget Testing**: Test user interactions and state changes
3. **Integration Testing**: Test complete form workflows

## Platform Considerations

### iOS
- Ensure proper keyboard types are set for numeric input
- Test with iOS accessibility features enabled
- Consider iOS-specific design guidelines

### Android
- Test with various Android versions and device sizes
- Ensure proper Material Design implementation
- Test with Android accessibility features

### Web
- Consider responsive design for various screen sizes
- Test keyboard navigation and focus management
- Ensure proper semantic HTML generation

## Troubleshooting

If you encounter issues while running the examples:

1. **Dependencies**: Ensure all dependencies are properly installed
   ```bash
   flutter pub get
   ```

2. **Flutter Version**: Verify you're using Flutter 3.0 or higher
   ```bash
   flutter --version
   ```

3. **Platform Setup**: Ensure your target platform is properly configured
   ```bash
   flutter doctor
   ```

## Contributing

When contributing new examples:

1. Follow the existing code structure and naming conventions
2. Include comprehensive comments explaining key concepts
3. Add the example to this README with appropriate documentation
4. Ensure the example compiles and runs without errors
5. Test on multiple platforms if possible

## Additional Resources

- [Package Documentation](../README.md)
- [API Reference](../lib/)
- [Flutter Documentation](https://flutter.dev/docs)
- [libphonenumber Documentation](https://github.com/google/libphonenumber)
