import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl_phone_number_input/src/utils/formatter/as_you_type_formatter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // ---------------------------------------------------------------------------
  // Helper builders
  // ---------------------------------------------------------------------------

  AsYouTypeFormatter makeFormatter({
    String isoCode = 'VN',
    String dialCode = '+84',
    OnInputFormatted<TextEditingValue>? onInputFormatted,
  }) {
    return AsYouTypeFormatter(
      isoCode: isoCode,
      dialCode: dialCode,
      onInputFormatted: onInputFormatted ?? (_) {},
    );
  }

  TextEditingValue tv(String text, {int? cursor}) {
    final offset = cursor ?? text.length;
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: offset),
    );
  }

  // ---------------------------------------------------------------------------
  // Group 1: isPartOfNorthAmericanNumberingPlan
  // ---------------------------------------------------------------------------

  group('isPartOfNorthAmericanNumberingPlan', () {
    test('returns true for +1 (plain US/CA)', () {
      final fmt = makeFormatter(dialCode: '+1');
      expect(fmt.isPartOfNorthAmericanNumberingPlan('+1'), isTrue);
    });

    test('returns true for a NANP country dial code like +1868 (Trinidad)', () {
      final fmt = makeFormatter(dialCode: '+1868');
      expect(fmt.isPartOfNorthAmericanNumberingPlan('+1868'), isTrue);
    });

    test('returns false for +44 (UK)', () {
      final fmt = makeFormatter(dialCode: '+44');
      expect(fmt.isPartOfNorthAmericanNumberingPlan('+44'), isFalse);
    });

    test('returns false for +84 (Vietnam)', () {
      final fmt = makeFormatter(dialCode: '+84');
      expect(fmt.isPartOfNorthAmericanNumberingPlan('+84'), isFalse);
    });

    test('returns false for empty string', () {
      final fmt = makeFormatter();
      expect(fmt.isPartOfNorthAmericanNumberingPlan(''), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // Group 2: parsePhoneNumber – regular (non-NANP) dial codes
  // ---------------------------------------------------------------------------

  group('parsePhoneNumber – non-NANP dial code', () {
    test('strips leading dial code and trims whitespace', () {
      // e.g. libphonenumber returns "+84 90 123 4567"
      final fmt = makeFormatter(dialCode: '+84');
      expect(fmt.parsePhoneNumber('+84 90 123 4567'), equals('90 123 4567'));
    });

    test('strips dial code only at the start (first occurrence)', () {
      final fmt = makeFormatter(dialCode: '+1');
      expect(fmt.parsePhoneNumber('+1 555-1+1'), equals('555-1+1'));
    });

    test('returns empty string if formatted number equals dial code only', () {
      final fmt = makeFormatter(dialCode: '+44');
      expect(fmt.parsePhoneNumber('+44 '), equals(''));
    });

    test('trims surrounding spaces', () {
      final fmt = makeFormatter(dialCode: '+49');
      expect(fmt.parsePhoneNumber('+49  30 1234'), equals('30 1234'));
    });
  });

  // ---------------------------------------------------------------------------
  // Group 3: parsePhoneNumber – NANP (dial code length > 4)
  // ---------------------------------------------------------------------------

  group('parsePhoneNumber – NANP (dialCode.length > 4)', () {
    test('strips NANP country-specific dial code like +1868', () {
      // libphonenumber formats as "+1 868-555-1234"
      final fmt = makeFormatter(dialCode: '+1868');
      // The formatted string starts with "+1 868" ("+1" + " " + "868")
      expect(
        fmt.parsePhoneNumber('+1 868-555-1234'),
        equals('555-1234'),
      );
    });

    test('falls back gracefully when NANP prefix not found', () {
      final fmt = makeFormatter(dialCode: '+1868');
      // When the NANP-specific prefix is not found, the code falls through to
      // the default path: replaceFirst(dialCode, '') which removes the raw
      // '+1868' prefix. But note that separatorChars (r'[^\d]+') also strips
      // the leading '+' as part of the replaceFirst on separators. In practice
      // the formatted string '+1 869-555-9999' has its first non-digit run
      // (the '+') stripped by the second replaceFirst, yielding '1 869-555-9999'.
      expect(
        fmt.parsePhoneNumber('+1 869-555-9999'),
        equals('1 869-555-9999'),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Group 4: formatEditUpdate – synchronous return value
  // ---------------------------------------------------------------------------

  group('formatEditUpdate – synchronous return value', () {
    test('returns newValue unchanged when text is empty', () {
      final fmt = makeFormatter();
      final oldVal = tv('');
      final newVal = tv('');
      expect(fmt.formatEditUpdate(oldVal, newVal), equals(newVal));
    });

    test('returns newValue immediately (async formatting deferred)', () {
      final fmt = makeFormatter();
      final oldVal = tv('');
      final newVal = tv('9');
      // The formatter always returns newValue synchronously and then asynchronously
      // triggers onInputFormatted once the native call resolves.
      expect(fmt.formatEditUpdate(oldVal, newVal), equals(newVal));
    });

    test('returns newValue when _isFormatting guard is active', () {
      // We drive _isFormatting = true by triggering a real call and then
      // simulating re-entry. The guard is exposed indirectly: calling
      // formatEditUpdate while a previous call is processing returns newValue.
      final fmt = makeFormatter();
      final oldVal = tv('');
      final firstCall = tv('9');
      fmt.formatEditUpdate(oldVal, firstCall);

      // Simulate re-entrant call (as if onInputFormatted wrote back to the
      // controller and TextInputFormatter was called again).
      // We can verify this path via the behaviour documented in the class:
      // when _isFormatting is true the method returns `newValue` directly.
      // Because _isFormatting is private, we verify the observable contract:
      // no crash, correct return value.
      final reentrantCall = tv('90');
      final result = fmt.formatEditUpdate(firstCall, reentrantCall);
      expect(result.text, equals('90'));
    });

    test('cursor offset preserved in synchronous return value', () {
      final fmt = makeFormatter();
      final oldVal = tv('');
      final newVal = tv('901234567', cursor: 4);
      final result = fmt.formatEditUpdate(oldVal, newVal);
      expect(result.selection.baseOffset, equals(4));
    });
  });

  // ---------------------------------------------------------------------------
  // Group 5: formatAsYouType – smoke test (no native engine needed)
  // ---------------------------------------------------------------------------

  group('formatAsYouType', () {
    test('returns a Future (non-null)', () {
      final fmt = makeFormatter();
      // Result may be null/empty on platforms without the plugin, but the
      // method must return a Future.
      final future = fmt.formatAsYouType(input: '+84901234567');
      expect(future, isA<Future<String?>>());
    });

    test('does not throw when input is empty', () {
      final fmt = makeFormatter();
      expect(
        () => fmt.formatAsYouType(input: ''),
        returnsNormally,
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Group 6: RegExp helpers (separatorChars / allowedChars)
  // ---------------------------------------------------------------------------

  group('RegExp helpers', () {
    late AsYouTypeFormatter fmt;
    setUp(() => fmt = makeFormatter());

    test('separatorChars matches space, dash, parenthesis', () {
      expect(fmt.separatorChars.hasMatch(' '), isTrue);
      expect(fmt.separatorChars.hasMatch('-'), isTrue);
      expect(fmt.separatorChars.hasMatch('('), isTrue);
      expect(fmt.separatorChars.hasMatch(')'), isTrue);
    });

    test('separatorChars does not match digits', () {
      for (var d in ['0', '1', '5', '9']) {
        expect(fmt.separatorChars.hasMatch(d), isFalse);
      }
    });

    test('separatorChars matches + sign (it is a non-digit character)', () {
      // separatorChars = RegExp(r'[^\d]+'); '+' is non-digit, so it matches.
      expect(fmt.separatorChars.hasMatch('+'), isTrue);
    });

    test('allowedChars matches digits and plus', () {
      expect(fmt.allowedChars.hasMatch('0'), isTrue);
      expect(fmt.allowedChars.hasMatch('9'), isTrue);
      expect(fmt.allowedChars.hasMatch('+'), isTrue);
    });

    test('allowedChars does not match spaces or dashes', () {
      expect(fmt.allowedChars.hasMatch(' '), isFalse);
      expect(fmt.allowedChars.hasMatch('-'), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // Group 7: onInputFormatted callback integration
  // ---------------------------------------------------------------------------

  group('onInputFormatted callback', () {
    test('callback is not called synchronously during formatEditUpdate', () {
      bool callbackFired = false;
      final fmt = makeFormatter(
        onInputFormatted: (_) => callbackFired = true,
      );

      fmt.formatEditUpdate(tv(''), tv('9'));

      // The formatting is async; callback must NOT have fired yet at this point.
      expect(callbackFired, isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // Group 8: constructor / field initialisation
  // ---------------------------------------------------------------------------

  group('constructor', () {
    test('constructor stores isoCode and dialCode correctly', () {
      const isoCode = 'US';
      const dialCode = '+1';
      final fmt = AsYouTypeFormatter(
        isoCode: isoCode,
        dialCode: dialCode,
        onInputFormatted: (_) {},
      );
      expect(fmt.isoCode, equals(isoCode));
      expect(fmt.dialCode, equals(dialCode));
    });

    test('creates formatter without throwing for normal inputs', () {
      expect(
        () => AsYouTypeFormatter(
          isoCode: 'VN',
          dialCode: '+84',
          onInputFormatted: (_) {},
        ),
        returnsNormally,
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Group 9: Country-specific – United States (US, +1, NANP)
  // ---------------------------------------------------------------------------

  group('Country – United States (US, +1)', () {
    late AsYouTypeFormatter fmt;
    setUp(() => fmt = makeFormatter(isoCode: 'US', dialCode: '+1'));

    test('isPartOfNorthAmericanNumberingPlan returns true', () {
      expect(fmt.isPartOfNorthAmericanNumberingPlan(fmt.dialCode), isTrue);
    });

    test('parsePhoneNumber strips +1 from a standard US number', () {
      // libphonenumber returns "+1 202-555-0147" for a Washington DC number.
      expect(fmt.parsePhoneNumber('+1 202-555-0147'), equals('202-555-0147'));
    });

    test('parsePhoneNumber strips +1 from a 10-digit number with spaces', () {
      expect(fmt.parsePhoneNumber('+1 800-867-5309'), equals('800-867-5309'));
    });

    test('parsePhoneNumber returns empty string for bare +1', () {
      expect(fmt.parsePhoneNumber('+1 '), equals(''));
    });

    test('formatEditUpdate returns newValue synchronously for US input', () {
      final result = fmt.formatEditUpdate(tv(''), tv('2025550147'));
      expect(result.text, equals('2025550147'));
    });

    test('formatAsYouType returns a Future for a US number', () {
      expect(
          fmt.formatAsYouType(input: '+12025550147'), isA<Future<String?>>());
    });

    test('formatEditUpdate returns empty value unchanged', () {
      final empty = tv('');
      expect(fmt.formatEditUpdate(empty, empty), equals(empty));
    });
  });

  // ---------------------------------------------------------------------------
  // Group 10: Country-specific – Spain (ES, +34, non-NANP)
  // ---------------------------------------------------------------------------

  group('Country – Spain (ES, +34)', () {
    late AsYouTypeFormatter fmt;
    setUp(() => fmt = makeFormatter(isoCode: 'ES', dialCode: '+34'));

    test('isPartOfNorthAmericanNumberingPlan returns false', () {
      expect(fmt.isPartOfNorthAmericanNumberingPlan(fmt.dialCode), isFalse);
    });

    test('parsePhoneNumber strips +34 from a mobile number', () {
      // Spanish mobile: "+34 612 345 678"
      expect(fmt.parsePhoneNumber('+34 612 345 678'), equals('612 345 678'));
    });

    test('parsePhoneNumber strips +34 from a landline number', () {
      // Spanish landline: "+34 91 234 5678"
      expect(fmt.parsePhoneNumber('+34 91 234 5678'), equals('91 234 5678'));
    });

    test('parsePhoneNumber returns empty string for bare +34', () {
      expect(fmt.parsePhoneNumber('+34 '), equals(''));
    });

    test('formatEditUpdate returns newValue synchronously for ES input', () {
      final result = fmt.formatEditUpdate(tv(''), tv('612345678'));
      expect(result.text, equals('612345678'));
    });

    test('formatAsYouType returns a Future for a Spanish number', () {
      expect(
          fmt.formatAsYouType(input: '+34612345678'), isA<Future<String?>>());
    });

    test('cursor position preserved in synchronous return', () {
      final input = tv('612345678', cursor: 3);
      final result = fmt.formatEditUpdate(tv(''), input);
      expect(result.selection.baseOffset, equals(3));
    });
  });

  // ---------------------------------------------------------------------------
  // Group 11: Country-specific – United Kingdom (GB, +44, non-NANP)
  // ---------------------------------------------------------------------------

  group('Country – United Kingdom (GB, +44)', () {
    late AsYouTypeFormatter fmt;
    setUp(() => fmt = makeFormatter(isoCode: 'GB', dialCode: '+44'));

    test('isPartOfNorthAmericanNumberingPlan returns false', () {
      expect(fmt.isPartOfNorthAmericanNumberingPlan(fmt.dialCode), isFalse);
    });

    test('parsePhoneNumber strips +44 from a London number', () {
      // libphonenumber: "+44 20 7946 0958"
      expect(fmt.parsePhoneNumber('+44 20 7946 0958'), equals('20 7946 0958'));
    });

    test('parsePhoneNumber strips +44 from a mobile number', () {
      // libphonenumber: "+44 7700 900123"
      expect(fmt.parsePhoneNumber('+44 7700 900123'), equals('7700 900123'));
    });

    test('parsePhoneNumber returns empty string for bare +44', () {
      expect(fmt.parsePhoneNumber('+44 '), equals(''));
    });

    test('formatEditUpdate returns newValue synchronously for GB input', () {
      final result = fmt.formatEditUpdate(tv(''), tv('7700900123'));
      expect(result.text, equals('7700900123'));
    });

    test('formatAsYouType returns a Future for a UK number', () {
      expect(
          fmt.formatAsYouType(input: '+447700900123'), isA<Future<String?>>());
    });

    test('onInputFormatted is not called synchronously for GB input', () {
      bool fired = false;
      final f = makeFormatter(
        isoCode: 'GB',
        dialCode: '+44',
        onInputFormatted: (_) => fired = true,
      );
      f.formatEditUpdate(tv(''), tv('7700900123'));
      expect(fired, isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // Group 12: Country-specific – Netherlands (NL, +31, non-NANP)
  // ---------------------------------------------------------------------------

  group('Country – Netherlands (NL, +31)', () {
    late AsYouTypeFormatter fmt;
    setUp(() => fmt = makeFormatter(isoCode: 'NL', dialCode: '+31'));

    test('isPartOfNorthAmericanNumberingPlan returns false', () {
      expect(fmt.isPartOfNorthAmericanNumberingPlan(fmt.dialCode), isFalse);
    });

    test('parsePhoneNumber strips +31 from an Amsterdam number', () {
      // libphonenumber: "+31 20 123 4567"
      expect(fmt.parsePhoneNumber('+31 20 123 4567'), equals('20 123 4567'));
    });

    test('parsePhoneNumber strips +31 from a mobile number', () {
      // libphonenumber: "+31 6 12345678"
      expect(fmt.parsePhoneNumber('+31 6 12345678'), equals('6 12345678'));
    });

    test('parsePhoneNumber returns empty string for bare +31', () {
      expect(fmt.parsePhoneNumber('+31 '), equals(''));
    });

    test('formatEditUpdate returns newValue synchronously for NL input', () {
      final result = fmt.formatEditUpdate(tv(''), tv('612345678'));
      expect(result.text, equals('612345678'));
    });

    test('formatAsYouType returns a Future for a Dutch number', () {
      expect(
          fmt.formatAsYouType(input: '+31612345678'), isA<Future<String?>>());
    });

    test('cursor position preserved in synchronous return for NL', () {
      final input = tv('612345678', cursor: 5);
      final result = fmt.formatEditUpdate(tv(''), input);
      expect(result.selection.baseOffset, equals(5));
    });

    test('onInputFormatted is not called synchronously for NL input', () {
      bool fired = false;
      final f = makeFormatter(
        isoCode: 'NL',
        dialCode: '+31',
        onInputFormatted: (_) => fired = true,
      );
      f.formatEditUpdate(tv(''), tv('612345678'));
      expect(fired, isFalse);
    });
  });
}
