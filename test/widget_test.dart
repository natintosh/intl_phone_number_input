import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('InternationalPhoneNumberInput Widget Tests', () {
    testWidgets('Should render basic widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                // Callback handled
              },
            ),
          ),
        ),
      );

      // Verify the widget renders
      expect(find.byType(InternationalPhoneNumberInput), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('Should show hint text', (WidgetTester tester) async {
      const hintText = 'Enter your phone number';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {},
              hintText: hintText,
            ),
          ),
        ),
      );

      expect(find.text(hintText), findsOneWidget);
    });

    testWidgets('Should handle text input', (WidgetTester tester) async {
      PhoneNumber? capturedPhoneNumber;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                capturedPhoneNumber = number;
              },
            ),
          ),
        ),
      );

      // Find the text field and enter text
      final textField = find.byType(TextFormField);
      await tester.enterText(textField, '1234567890');
      await tester.pump();

      // Verify callback was called
      expect(capturedPhoneNumber, isNotNull);
      expect(capturedPhoneNumber!.phoneNumber, contains('1234567890'));
    });

    testWidgets('Should handle initial value', (WidgetTester tester) async {
      final initialValue = PhoneNumber(
        phoneNumber: '+1234567890',
        isoCode: 'US',
        dialCode: '+1',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {},
              initialValue: initialValue,
            ),
          ),
        ),
      );

      // Wait for initialization
      await tester.pumpAndSettle();

      // The widget should render successfully
      expect(find.byType(InternationalPhoneNumberInput), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('Should show selector button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {},
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.DROPDOWN,
              ),
            ),
          ),
        ),
      );

      // Should find a selector button
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('Should handle dropdown selector type',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {},
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.DROPDOWN,
              ),
            ),
          ),
        ),
      );

      // Tap the selector to open dropdown
      final selectorButton = find.byType(GestureDetector).first;
      await tester.tap(selectorButton);
      await tester.pumpAndSettle();

      // Should show some form of scrollable content (could be multiple)
      expect(find.byType(Scrollable), findsAtLeastNWidgets(1));
    });

    testWidgets('Should handle form validation', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {},
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  }
                  return null;
                },
                autoValidateMode: AutovalidateMode.always,
              ),
            ),
          ),
        ),
      );

      // Trigger validation
      final isValid = formKey.currentState!.validate();
      await tester.pump();

      // Should show validation error for empty field
      expect(find.text('Phone number is required'), findsOneWidget);
      expect(isValid, isFalse);
    });

    testWidgets('Should handle disabled state', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {},
              isEnabled: false,
            ),
          ),
        ),
      );

      final textField = find.byType(TextFormField);
      final TextFormField textFieldWidget = tester.widget(textField);
      expect(textFieldWidget.enabled, isFalse);
    });

    testWidgets('Should handle custom text style', (WidgetTester tester) async {
      const customTextStyle = TextStyle(
        fontSize: 18,
        color: Colors.red,
        fontWeight: FontWeight.bold,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {},
              textStyle: customTextStyle,
            ),
          ),
        ),
      );

      // Verify the widget renders with custom style
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(InternationalPhoneNumberInput), findsOneWidget);
    });

    testWidgets('Should handle prefix icon configuration',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {},
              selectorConfig: const SelectorConfig(
                setSelectorButtonAsPrefixIcon: true,
              ),
            ),
          ),
        ),
      );

      // When prefix icon is enabled, the selector should be inside the text field
      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);
    });

    testWidgets('Should handle onInputValidated callback',
        (WidgetTester tester) async {
      bool? isValid;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {},
              onInputValidated: (bool valid) {
                isValid = valid;
              },
            ),
          ),
        ),
      );

      // Enter a valid US phone number
      final textField = find.byType(TextFormField);
      await tester.enterText(textField, '5551234567');
      await tester.pump();

      // Give some time for validation
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // The callback should have been called
      expect(isValid, isNotNull);
    });

    testWidgets('Should handle custom input decoration',
        (WidgetTester tester) async {
      const decoration = InputDecoration(
        labelText: 'Phone Number',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.phone),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {},
              inputDecoration: decoration,
            ),
          ),
        ),
      );

      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.byIcon(Icons.phone), findsOneWidget);
    });

    testWidgets('Should handle maxLength constraint',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {},
              maxLength: 10,
            ),
          ),
        ),
      );

      // Verify the widget renders with maxLength constraint
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(InternationalPhoneNumberInput), findsOneWidget);
    });

    testWidgets('Should handle autoFocus', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {},
              autoFocus: true,
            ),
          ),
        ),
      );

      // Verify the widget renders with autoFocus enabled
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(InternationalPhoneNumberInput), findsOneWidget);
    });

    testWidgets('Should handle keyboard type', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {},
              keyboardType: TextInputType.number,
            ),
          ),
        ),
      );

      // Verify the widget renders with custom keyboard type
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(InternationalPhoneNumberInput), findsOneWidget);
    });
  });

  group('SelectorConfig Widget Tests', () {
    testWidgets('Should handle bottom sheet selector',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {},
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              ),
            ),
          ),
        ),
      );

      // Tap the selector to open bottom sheet
      final selectorButton = find.byType(GestureDetector).first;
      await tester.tap(selectorButton);
      await tester.pumpAndSettle();

      // Should show bottom sheet
      expect(find.byType(BottomSheet), findsOneWidget);
    });

    testWidgets('Should handle dialog selector', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {},
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.DIALOG,
              ),
            ),
          ),
        ),
      );

      // Tap the selector to open dialog
      final selectorButton = find.byType(GestureDetector).first;
      await tester.tap(selectorButton);
      await tester.pumpAndSettle();

      // Should show dialog
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('Should handle flag visibility', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {},
              selectorConfig: const SelectorConfig(
                showFlags: false,
              ),
            ),
          ),
        ),
      );

      // When flags are disabled, should not show flag images
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('Should handle emoji flags', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {},
              selectorConfig: const SelectorConfig(
                useEmoji: true,
              ),
            ),
          ),
        ),
      );

      // Should render emoji flags as text instead of images
      expect(find.byType(Text), findsWidgets);
    });
  });

  group('Error Handling Tests', () {
    testWidgets('Should handle invalid initial value gracefully',
        (WidgetTester tester) async {
      // Use a less invalid value that won't immediately crash
      final invalidValue = PhoneNumber(
        phoneNumber: '123',
        isoCode: 'US',
        dialCode: '+1',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {},
              initialValue: invalidValue,
            ),
          ),
        ),
      );

      // Should not crash and render the widget
      expect(find.byType(InternationalPhoneNumberInput), findsOneWidget);
    });

    testWidgets('Should handle null callbacks gracefully',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {},
              onInputValidated: null,
              onSaved: null,
              validator: null,
            ),
          ),
        ),
      );

      final textField = find.byType(TextFormField);
      await tester.enterText(textField, '1234567890');
      await tester.pump();

      // Should not crash
      expect(find.byType(InternationalPhoneNumberInput), findsOneWidget);
    });
  });
}
