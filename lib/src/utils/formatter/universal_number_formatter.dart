import 'package:flutter/services.dart';

class UniversalNumberFormatter extends TextInputFormatter {
  static const Map<String, String> _localizedToEnglishDigits = {
    // Arabic Digits
    '٠': '0', '١': '1', '٢': '2', '٣': '3', '٤': '4',
    '٥': '5', '٦': '6', '٧': '7', '٨': '8', '٩': '9',
    // Persian Digits
    '۰': '0', '۱': '1', '۲': '2', '۳': '3', '۴': '4',
    '۵': '5', '۶': '6', '۷': '7', '۸': '8', '۹': '9',
    // Devanagari Digits
    '०': '0', '१': '1', '२': '2', '३': '3', '४': '4',
    '५': '5', '६': '6', '७': '7', '८': '8', '९': '9',
    // Bengali Digits
    '০': '0', '১': '1', '২': '2', '৩': '3', '৪': '4',
    '৫': '5', '৬': '6', '৭': '7', '৮': '8', '৯': '9',
    // Tamil Digits
    '௦': '0', '௧': '1', '௨': '2', '௩': '3', '௪': '4',
    '௫': '5', '௬': '6', '௭': '7', '௮': '8', '௯': '9',
    // Telugu Digits
    '౦': '0', '౧': '1', '౨': '2', '౩': '3', '౪': '4',
    '౫': '5', '౬': '6', '౭': '7', '౮': '8', '౯': '9',
    // Thai Digits
    '๐': '0', '๑': '1', '๒': '2', '๓': '3', '๔': '4',
    '๕': '5', '๖': '6', '๗': '7', '๘': '8', '๙': '9',
    // Chinese Digits (Simplified & Traditional)
    '〇': '0', '一': '1', '二': '2', '三': '3', '四': '4',
    '五': '5', '六': '6', '七': '7', '八': '8', '九': '9',
    // Hebrew Digits
    'א': '1', 'ב': '2', 'ג': '3', 'ד': '4', 'ה': '5',
    'ו': '6', 'ז': '7', 'ח': '8', 'ט': '9', '׳': '0',
    // Gujarati Digits
    '૦': '0', '૧': '1', '૨': '2', '૩': '3', '૪': '4', '૫': '5', '૬': '6',
    '૭': '7', '૮': '8', '૯': '9',
    // Gurmukhi (Punjabi) Digits
    '੦': '0', '੧': '1', '੨': '2', '੩': '3', '੪': '4', '੫': '5', '੬': '6',
    '੭': '7', '੮': '8', '੯': '9',
    // Kannada Digits
    '೦': '0', '೧': '1', '೨': '2', '೩': '3', '೪': '4', '೫': '5', '೬': '6',
    '೭': '7', '೮': '8', '೯': '9',
    // Malayalam Digits
    '൦': '0', '൧': '1', '൨': '2', '൩': '3', '൪': '4', '൫': '5', '൬': '6',
    '൭': '7', '൮': '8', '൯': '9',
    // Oriya (Odia) Digits
    '୦': '0', '୧': '1', '୨': '2', '୩': '3', '୪': '4', '୫': '5', '୬': '6',
    '୭': '7', '୮': '8', '୯': '9',
    // Myanmar Digits
    '၀': '0', '၁': '1', '၂': '2', '၃': '3', '၄': '4', '၅': '5', '၆': '6',
    '၇': '7', '၈': '8', '၉': '9',
    // Lao Digits
    '໐': '0', '໑': '1', '໒': '2', '໓': '3', '໔': '4', '໕': '5', '໖': '6',
    '໗': '7', '໘': '8', '໙': '9',
  };

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String convertedText = formatNumber(newValue.text);

    return newValue.copyWith(
      text: convertedText,
      selection: TextSelection.collapsed(offset: convertedText.length),
    );
  }

  static String formatNumber(String value) {
    return value.split('').map((char) {
      return _localizedToEnglishDigits[char] ?? char;
    }).join();
  }
}
