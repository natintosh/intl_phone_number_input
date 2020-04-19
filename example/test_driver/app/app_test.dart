import 'package:flutter_driver/flutter_driver.dart';
import 'package:intl_phone_number_input/intl_phone_number_input_test.dart';
import 'package:test/test.dart';

main() {
  group('International Phone Number Input Integration Test', () {
    final inputTextFieldFinder = find.byValueKey(TestHelper.TextInputKeyValue);
    final dropdownButtonFinder =
        find.byValueKey(TestHelper.DropdownButtonKeyValue);

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Tap On TextField and enter text', () async {
      await driver.tap(inputTextFieldFinder);
      await driver.enterText('7012345678');
      await driver.waitFor(find.text('701 234 5678'));
    });

    ///  Test for
    ///  PhoneInputSelectorType.DROPDOWN
    ///
    ///  N.B Some values such as -18500 may vary on devices
    ///

    test('Tap On Dropdown button', () async {
      await driver.tap(dropdownButtonFinder);
      await driver.waitFor(find.byType('Scrollable'));
    });

    test('Scroll to view and Select Country', () async {
      await driver.scroll(
          dropdownButtonFinder, 0, -16000, Duration(milliseconds: 300));

      await driver.tap(find.byValueKey(TestHelper.countryItemKeyValue('US')));
    });

    test('Update Textfield After new Item selected', () async {
      await driver.waitFor(inputTextFieldFinder);
      await driver.tap(inputTextFieldFinder);
      await driver.enterText('');
      await driver.enterText('5555555555');
      await driver.waitFor(find.text('555-555-5555'));
    });
  });
}
