import 'package:flutter_test/flutter_test.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:intl_phone_number_input/src/utils/formatter/as_you_type_formatter.dart';
import 'package:intl_phone_number_input/src/utils/phone_number/phone_number_util.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("AsYouTypeFormatter Tests", () {
    test("Should create formatter with valid parameters", () {
      expect(() {
        AsYouTypeFormatter(
          isoCode: "US",
          dialCode: "+1",
          onInputFormatted: (_) {},
        );
      }, returnsNormally);
    });
  });

  group("PhoneNumber Object Tests", () {
    test(
        "Should throw exception for empty phone number in getRegionInfoFromPhoneNumber",
        () async {
      expect(
        () async => await PhoneNumber.getRegionInfoFromPhoneNumber('', ""),
        throwsA(isA<Exception>()),
      );
    });

    test("Should create PhoneNumber with all parameters", () {
      final phoneNumber = PhoneNumber(
        phoneNumber: '+1234567890',
        dialCode: '+1',
        isoCode: 'US',
      );

      expect(phoneNumber.phoneNumber, equals('+1234567890'));
      expect(phoneNumber.dialCode, equals('+1'));
      expect(phoneNumber.isoCode, equals('US'));
      expect(phoneNumber.hash, isA<int>());
    });

    test("Should create PhoneNumber with null parameters", () {
      final phoneNumber = PhoneNumber();

      expect(phoneNumber.phoneNumber, isNull);
      expect(phoneNumber.dialCode, isNull);
      expect(phoneNumber.isoCode, isNull);
      expect(phoneNumber.hash, isA<int>());
    });

    test("Should generate different hash values for different instances", () {
      final phoneNumber1 = PhoneNumber(phoneNumber: '+1234567890');
      final phoneNumber2 = PhoneNumber(phoneNumber: '+1234567890');

      expect(phoneNumber1.hash, isNot(equals(phoneNumber2.hash)));
    });

    test("Should have proper toString implementation", () {
      final phoneNumber = PhoneNumber(
        phoneNumber: '+1234567890',
        dialCode: '+1',
        isoCode: 'US',
      );

      final stringRepresentation = phoneNumber.toString();
      expect(stringRepresentation, contains('PhoneNumber'));
      expect(stringRepresentation, contains('+1234567890'));
      expect(stringRepresentation, contains('+1'));
      expect(stringRepresentation, contains('US'));
    });

    test("Should support equality comparison", () {
      final phoneNumber1 = PhoneNumber(
        phoneNumber: '+1234567890',
        dialCode: '+1',
        isoCode: 'US',
      );
      final phoneNumber2 = PhoneNumber(
        phoneNumber: '+1234567890',
        dialCode: '+1',
        isoCode: 'US',
      );
      final phoneNumber3 = PhoneNumber(
        phoneNumber: '+1987654321',
        dialCode: '+1',
        isoCode: 'US',
      );

      expect(phoneNumber1, equals(phoneNumber2));
      expect(phoneNumber1, isNot(equals(phoneNumber3)));
    });

    test("Should parse number correctly", () {
      final phoneNumber = PhoneNumber(
        phoneNumber: '+1234567890',
        dialCode: '+1',
        isoCode: 'US',
      );

      final parsed = phoneNumber.parseNumber();
      expect(parsed, equals('234567890'));
    });

    test("parseNumber should handle phone number without dial code", () {
      final phoneNumber = PhoneNumber(
        phoneNumber: '234567890',
        dialCode: '+1',
        isoCode: 'US',
      );

      final parsed = phoneNumber.parseNumber();
      expect(parsed, equals('234567890'));
    });

    test("getParsableNumber should throw exception for null isoCode", () async {
      final phoneNumber = PhoneNumber(
        phoneNumber: '+1234567890',
        dialCode: '+1',
        isoCode: null,
      );

      expect(
        () async => await PhoneNumber.getParsableNumber(phoneNumber),
        throwsException,
      );
    });
  });

  group("PhoneNumberUtil Tests", () {
    test("Should return false for invalid phone numbers", () async {
      final isValid = await PhoneNumberUtil.isValidNumber(
        phoneNumber: '123',
        isoCode: 'US',
      );
      expect(isValid, isFalse);
    });

    test("Should return false for very short phone numbers", () async {
      final isValid = await PhoneNumberUtil.isValidNumber(
        phoneNumber: '1',
        isoCode: 'US',
      );
      expect(isValid, isFalse);
    });

    test("Should handle empty phone number", () async {
      final isValid = await PhoneNumberUtil.isValidNumber(
        phoneNumber: '',
        isoCode: 'US',
      );
      expect(isValid, isFalse);
    });

    test("Should normalize phone number to E164 format", () async {
      final normalized = await PhoneNumberUtil.normalizePhoneNumber(
        phoneNumber: '(555) 123-4567',
        isoCode: 'US',
      );
      expect(normalized, isNotNull);
      expect(normalized, startsWith('+1'));
    });

    test("Should get region info for valid phone number", () async {
      final regionInfo = await PhoneNumberUtil.getRegionInfo(
        phoneNumber: '+15551234567',
        isoCode: 'US',
      );

      // Just verify the method completes without error
      expect(regionInfo, isA<RegionInfo>());
    });

    test("Should get number type for valid phone number", () async {
      final numberType = await PhoneNumberUtil.getNumberType(
        phoneNumber: '+15551234567',
        isoCode: 'US',
      );

      expect(numberType, isA<PhoneNumberType>());
    });
  });

  group("SelectorConfig Tests", () {
    test("Should create SelectorConfig with default values", () {
      const config = SelectorConfig();

      expect(config.selectorType, equals(PhoneInputSelectorType.DROPDOWN));
      expect(config.showFlags, isTrue);
      expect(config.useEmoji, isFalse);
      expect(config.setSelectorButtonAsPrefixIcon, isFalse);
      expect(config.trailingSpace, isTrue);
      expect(config.useBottomSheetSafeArea, isFalse);
      expect(config.countryComparator, isNull);
      expect(config.leadingPadding, isNull);
    });

    test("Should create SelectorConfig with custom values", () {
      const config = SelectorConfig(
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        showFlags: false,
        useEmoji: true,
        setSelectorButtonAsPrefixIcon: true,
        trailingSpace: false,
        useBottomSheetSafeArea: true,
        leadingPadding: 16.0,
      );

      expect(config.selectorType, equals(PhoneInputSelectorType.BOTTOM_SHEET));
      expect(config.showFlags, isFalse);
      expect(config.useEmoji, isTrue);
      expect(config.setSelectorButtonAsPrefixIcon, isTrue);
      expect(config.trailingSpace, isFalse);
      expect(config.useBottomSheetSafeArea, isTrue);
      expect(config.leadingPadding, equals(16.0));
    });
  });

  group("PhoneNumberType Tests", () {
    test("Should have all expected phone number types", () {
      expect(PhoneNumberType.values, contains(PhoneNumberType.FIXED_LINE));
      expect(PhoneNumberType.values, contains(PhoneNumberType.MOBILE));
      expect(PhoneNumberType.values,
          contains(PhoneNumberType.FIXED_LINE_OR_MOBILE));
      expect(PhoneNumberType.values, contains(PhoneNumberType.TOLL_FREE));
      expect(PhoneNumberType.values, contains(PhoneNumberType.PREMIUM_RATE));
      expect(PhoneNumberType.values, contains(PhoneNumberType.SHARED_COST));
      expect(PhoneNumberType.values, contains(PhoneNumberType.VOIP));
      expect(PhoneNumberType.values, contains(PhoneNumberType.PERSONAL_NUMBER));
      expect(PhoneNumberType.values, contains(PhoneNumberType.PAGER));
      expect(PhoneNumberType.values, contains(PhoneNumberType.UAN));
      expect(PhoneNumberType.values, contains(PhoneNumberType.VOICEMAIL));
      expect(PhoneNumberType.values, contains(PhoneNumberType.UNKNOWN));
    });
  });

  group("Edge Cases and Error Handling", () {
    test("Should handle special characters in phone numbers", () async {
      final phoneNumber = PhoneNumber(
        phoneNumber: '+1 (555) 123-4567',
        dialCode: '+1',
        isoCode: 'US',
      );

      final parsed = phoneNumber.parseNumber();
      expect(parsed, contains('555'));
      expect(parsed, contains('123'));
      expect(parsed, contains('4567'));
    });

    test("Should handle phone numbers with spaces and dashes", () {
      final phoneNumber = PhoneNumber(
        phoneNumber: '+1-555-123-4567',
        dialCode: '+1',
        isoCode: 'US',
      );

      final parsed = phoneNumber.parseNumber();
      expect(parsed, equals('-555-123-4567'));
    });

    test("Should handle phone numbers with country code variations", () {
      final phoneNumber = PhoneNumber(
        phoneNumber: '001234567890',
        dialCode: '+1',
        isoCode: 'US',
      );

      final parsed = phoneNumber.parseNumber();
      expect(parsed, isNotEmpty);
    });
  });
}
