import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/src/utils/phone_number/phone_number_util.dart';

typedef OnInputFormatted<T> = void Function(T value);

/// [AsYouTypeFormatter] is a custom formatter that extends [TextInputFormatter]
/// which provides as you type validation and formatting for phone number inputted.
class AsYouTypeFormatter extends TextInputFormatter {
  /// Contains characters allowed as seperators.
  final RegExp separatorChars = RegExp(r'[^\d]+');

  /// The [allowedChars] contains [RegExp] for allowable phone number characters.
  final RegExp allowedChars = RegExp(r'[\d+]');

  /// The [isoCode] of the [Country] formatting the phone number to
  final String isoCode;

  /// The [dialCode] of the [Country] formatting the phone number to
  final String dialCode;

  /// [onInputFormatted] is a callback that passes the formatted phone number
  final OnInputFormatted<TextEditingValue> onInputFormatted;

  /// Guard flag that prevents re-entrant async callbacks from firing
  /// [onInputFormatted] while a previous formatting pass is still in progress.
  bool _isFormatting = false;

  /// Tracks the last raw (digits-only) input that was dispatched to the async
  /// formatter so we can discard stale results from earlier keystrokes.
  String _lastRawInput = '';

  AsYouTypeFormatter({
    required this.isoCode,
    required this.dialCode,
    required this.onInputFormatted,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    int newValueLength = newValue.text.length;

    if (newValueLength > 0) {
      // Skip if we are already applying a formatted result back to the
      // controller – this is the spurious re-entry triggered by
      // `onInputFormatted` writing to the controller externally.
      if (_isFormatting) {
        return newValue;
      }

      String newValueText = newValue.text;
      String rawText = newValueText.replaceAll(separatorChars, '');
      String textToParse = dialCode + rawText;

      // Capture the raw input for this keystroke so the async callback can
      // detect and discard results that are no longer current.
      _lastRawInput = rawText;

      final _ = newValueText
          .substring(0, newValue.selection.end)
          .replaceAll(separatorChars, '');

      formatAsYouType(input: textToParse).then((String? value) {
        // Discard stale results – newer keystrokes have already been typed.
        if (rawText != _lastRawInput) return;

        String parsedText = parsePhoneNumber(value);

        // Nothing actually changed; skip the controller update to avoid a
        // superfluous rebuild and another (empty) formatEditUpdate round-trip.
        if (parsedText == newValueText) return;

        int currentOffset = newValue.selection.end == -1
            ? 0
            : newValue.selection.end;

        int digitOffset = 0;
        for (var index = 0; index < currentOffset; index++) {
          if (allowedChars.hasMatch(newValueText[index])) {
            digitOffset++;
          }
        }

        int newOffset = 0;
        int digitCount = 0;
        while (newOffset < parsedText.length && digitCount < digitOffset) {
          if (allowedChars.hasMatch(parsedText[newOffset])) {
            digitCount++;
          }
          newOffset++;
        }

        // Set the guard before calling back so that the controller assignment
        // inside [onInputFormatted] does not recursively trigger formatting.
        _isFormatting = true;
        try {
          this.onInputFormatted(
            TextEditingValue(
              text: parsedText,
              selection: TextSelection.collapsed(offset: newOffset),
            ),
          );
        } finally {
          _isFormatting = false;
        }
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
    if (dialCode.length > 4) {
      if (isPartOfNorthAmericanNumberingPlan(dialCode)) {
        String northAmericaDialCode = '+1';
        String countryDialCodeWithSpace =
            northAmericaDialCode +
            ' ' +
            dialCode.replaceFirst(northAmericaDialCode, '');

        return phoneNumber!
            .replaceFirst(countryDialCodeWithSpace, '')
            .replaceFirst(separatorChars, '')
            .trim();
      }
    }
    return phoneNumber!.replaceFirst(dialCode, '').trim();
  }

  /// Accepts a [dialCode]
  /// returns a [bool], true if the `dialCode` is part of North American Numbering Plan
  bool isPartOfNorthAmericanNumberingPlan(String dialCode) {
    return dialCode.contains('+1');
  }
}
