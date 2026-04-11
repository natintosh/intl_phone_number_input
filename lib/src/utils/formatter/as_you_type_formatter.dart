import 'dart:math';

import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/src/utils/phone_number/phone_number_util.dart';

typedef OnInputFormatted<T> = void Function(T value);

/// [AsYouTypeFormatter] is a custom formatter that extends [TextInputFormatter]
/// which provides as you type validation and formatting for phone number inputted.
class AsYouTypeFormatter extends TextInputFormatter {
  /// Contains characters allowed as seperators.
  // Treat ASCII digits and common Arabic numeral ranges as digits; everything else is a separator.
  final RegExp separatorChars = RegExp(
    r'[^\d\u0660-\u0669\u06F0-\u06F9]+',
    unicode: true,
  );

  /// The [allowedChars] contains [RegExp] for allowable phone number characters.
  final RegExp allowedChars = RegExp(
    r'[\d\u0660-\u0669\u06F0-\u06F9+]',
    unicode: true,
  );

  final RegExp bracketsBetweenDigitsOrSpace = RegExp(
    r'(?![\s\d])([()])(?=[\d\s])',
  );

  /// The [isoCode] of the [Country] formatting the phone number to
  final String isoCode;

  /// The [dialCode] of the [Country] formatting the phone number to
  final String dialCode;

  /// Locale code used to localize digits for display (e.g., 'en', 'ar', 'fa').
  final String locale;

  /// Optional map of locale prefixes to a 10-character string of digits 0-9.
  /// This allows consumers to add or override digit sets without modifying the library.
  /// Example: {'my': '၀၁၂၃၄၅၆၇၈၉'} for Myanmar.
  final Map<String, String>? localeDigitMaps;

  /// [onInputFormatted] is a callback that passes the formatted phone number
  final OnInputFormatted<TextEditingValue> onInputFormatted;

  AsYouTypeFormatter({
    required this.isoCode,
    required this.dialCode,
    required this.locale,
    required this.onInputFormatted,
    this.localeDigitMaps,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    int oldValueLength = oldValue.text.length;
    int newValueLength = newValue.text.length;

    if (newValueLength > 0 && newValueLength > oldValueLength) {
      String newValueText = newValue.text;
      String rawText = newValueText.replaceAll(separatorChars, '');

      int rawCursorPosition = newValue.selection.end;

      int digitsBeforeCursor = 0, digitsAfterCursor = 0;

      if (rawCursorPosition > 0 && rawCursorPosition <= newValueText.length) {
        final rawTextBeforeCursor = newValueText
            .substring(0, rawCursorPosition)
            .replaceAll(separatorChars, '');
        final rawTextAfterCursor = newValueText
            .substring(rawCursorPosition)
            .replaceAll(separatorChars, '');

        digitsBeforeCursor = rawTextBeforeCursor.length;
        digitsAfterCursor = rawTextAfterCursor.length;
      }

      final normalizedRaw = _convertDigitsToWestern(rawText);

      String textToParse = dialCode + normalizedRaw;

      formatAsYouType(input: textToParse).then((String? value) {
        String parsedText = parsePhoneNumber(value);

        int newCursorPosition = 0;

        if (digitsBeforeCursor > 0 || digitsAfterCursor > 0) {
          for (var i = 0; i < parsedText.length; i++) {
            final startCursor = i;

            if (allowedChars.hasMatch(parsedText[startCursor])) {
              if (digitsBeforeCursor > 0) {
                digitsBeforeCursor--;
              } else {
                newCursorPosition = startCursor + 1;
                break;
              }
            }

            final endCursor = parsedText.length - 1 - i;

            if (allowedChars.hasMatch(parsedText[endCursor])) {
              if (digitsAfterCursor > 0) {
                digitsAfterCursor--;
              } else {
                newCursorPosition = endCursor + 1;
                break;
              }
            }
          }
        }

        final displayText = _convertDigitsToLocale(parsedText);
        // // If we couldn't compute a caret position (no digits context), default to end
        if (digitsBeforeCursor == 0 && digitsAfterCursor == 0) {
          newCursorPosition = displayText.length;
        }
        newCursorPosition = min(max(newCursorPosition, 0), displayText.length);

        String arabicText = newValueText;

        if (locale == "ar") {
          // Map Western digits to Eastern Arabic digits
          final Map<String, String> numbersMap = {
            '0': '٠',
            '1': '١',
            '2': '٢',
            '3': '٣',
            '4': '٤',
            '5': '٥',
            '6': '٦',
            '7': '٧',
            '8': '٨',
            '9': '٩',
          };

          numbersMap.forEach((english, arabic) {
            arabicText = arabicText.replaceAll(english, arabic);
          });
        }

        this.onInputFormatted(
          TextEditingValue(
            text: locale == "ar" ? arabicText : displayText,
            selection: TextSelection.collapsed(
                offset: locale == "ar" ? arabicText.length : newCursorPosition),
          ),
        );
      });
    }

    return newValue;
  }

  /// Accepts [input], unformatted phone number and
  /// returns a [Future<String>] of the formatted phone number.
  Future<String?> formatAsYouType({required String input}) async {
    try {
      String? formattedPhoneNumber = await PhoneNumberUtil.formatAsYouType(
        phoneNumber: input,
        isoCode: isoCode,
      );
      return formattedPhoneNumber;
    } on Exception {
      return '';
    }
  }

  /// Accepts a formatted [phoneNumber]
  /// returns a [String] of `phoneNumber` with the dialCode replaced with an empty String
  String parsePhoneNumber(String? phoneNumber) {
    final filteredPhoneNumber = phoneNumber?.replaceAll(
      bracketsBetweenDigitsOrSpace,
      '',
    );

    if (dialCode.length > 4) {
      if (isPartOfNorthAmericanNumberingPlan(dialCode)) {
        String northAmericaDialCode = '+1';
        String countryDialCodeWithSpace = northAmericaDialCode +
            ' ' +
            dialCode.replaceFirst(northAmericaDialCode, '');

        return filteredPhoneNumber!
            .replaceFirst(countryDialCodeWithSpace, '')
            .replaceFirst(separatorChars, '')
            .trim();
      }
    }
    return filteredPhoneNumber!.replaceFirst(dialCode, '').trim();
  }

  /// Accepts a [dialCode]
  /// returns a [bool], true if the `dialCode` is part of North American Numbering Plan
  bool isPartOfNorthAmericanNumberingPlan(String dialCode) {
    return dialCode.contains('+1');
  }

  /// Normalize localized numerals to Western digits 0-9.
  ///
  /// This recognizes:
  /// - Built-in numeral sets (Arabic-Indic, Eastern Arabic-Indic, Devanagari)
  /// - Any custom sets provided via [localeDigitMaps]
  ///
  /// Unknown characters are left unchanged.
  String _convertDigitsToWestern(String input) {
    const westernDigits = '0123456789';

    // Collect all known digit sets (length 10) for reverse mapping.
    final List<String> digitSets = [];
    if (localeDigitMaps != null && localeDigitMaps!.isNotEmpty) {
      localeDigitMaps!.values
          .where((v) => v.length == 10)
          .forEach(digitSets.add);
    }

    const builtInSets = <String>[
      // Arabic-Indic (U+0660..U+0669)
      '٠١٢٣٤٥٦٧٨٩',
      // Eastern Arabic-Indic (U+06F0..U+06F9)
      '۰۱۲۳۴۵۶۷۸۹',
      // Devanagari (U+0966..U+096F)
      '०१२३४५६७८९',
    ];
    digitSets.addAll(builtInSets);

    if (digitSets.isEmpty) return input;

    final Map<String, String> reverseMap = {};
    for (final set in digitSets) {
      if (set.length != 10) continue;
      for (var i = 0; i < 10; i++) {
        reverseMap[set[i]] = westernDigits[i];
      }
    }

    final buffer = StringBuffer();
    for (final ch in input.split('')) {
      buffer.write(reverseMap[ch] ?? ch);
    }
    return buffer.toString();
  }

  /// Convert Western digits to locale-specific numerals.
  ///
  /// - Uses [localeDigitMaps] if provided by the consumer. The map keys are
  ///   locale prefixes (e.g., 'ar', 'fa', 'ur', 'hi'), and the values are
  ///   a 10-character string representing digits 0-9 in that numeral system.
  /// - Falls back to built-in defaults for common locales.
  /// - If no mapping is found, returns the input unchanged.
  String _convertDigitsToLocale(String input) {
    final lc = locale.toLowerCase();

    // Western digits as source
    const westernDigits = '0123456789';

    // Built-in defaults
    const builtInMaps = <String, String>{
      // Arabic-Indic (U+0660..U+0669)
      'ar': '٠١٢٣٤٥٦٧٨٩',
      // Eastern Arabic-Indic (Persian, Urdu) U+06F0..U+06F9
      'fa': '۰۱۲۳۴۵۶۷۸۹',
      'ur': '۰۱۲۳۴۵۶۷۸۹',
      // Devanagari (Hindi)
      'hi': '०१२३४५६७८९',
    };

    // Determine the best mapping: explicit override > locale prefix in built-in
    String? digits;
    if (localeDigitMaps != null && localeDigitMaps!.isNotEmpty) {
      // Match by exact, then by prefix before '-'
      digits = localeDigitMaps![lc] ?? localeDigitMaps![lc.split('-').first];
    }
    digits ??= builtInMaps[lc] ?? builtInMaps[lc.split('-').first];

    if (digits == null || digits.length != 10) return input;

    return input.replaceAllMapped(RegExp(r'\d'), (match) {
      final ch = match.group(0)!;
      final idx = westernDigits.indexOf(ch);
      return idx != -1 ? digits![idx] : ch;
    });
  }
}
