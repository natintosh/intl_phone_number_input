import 'package:intl_phone_number_input/src/models/country_model.dart';

/// [Utils] class contains utility methods for `intl_phone_number_input` library
class Utils {
  ///  Returns a [Country] form list of [countries] passed that matches [countryCode].
  ///  Returns the first [Country] in the list if no match is available.
  static Country getInitialSelectedCountry(
      List<Country> countries, String countryCode) {
    return countries.firstWhere((country) => country.alpha2Code == countryCode,
        orElse: () => countries[0]);
  }


  /// Returns a [String] which will be the unicode of a Flag Emoji,
  /// from a country [countryCode] passed as a parameter.
  static final Map<String, String> _flagCache = {};

  static String generateFlagEmojiUnicode(String countryCode) {
    // Return from cache if available
    if (_flagCache.containsKey(countryCode)) {
      return _flagCache[countryCode]!;
    }

    if (countryCode.isEmpty) return '';

    final base = 127397;
    final flag = countryCode.codeUnits
        .map((e) => String.fromCharCode(base + e))
        .join();

    // Store in cache for future use
    _flagCache[countryCode] = flag;
    return flag;
  }

  /// Filters the list of Country by text from the search box.
  static List<Country> filterCountries({
    required List<Country> countries,
    required String? locale,
    required String value,
  }) {
    if (value.isNotEmpty) {
      return countries
          .where(
            (Country country) =>
                country.alpha3Code!
                    .toLowerCase()
                    .startsWith(value.toLowerCase()) ||
                country.name!.toLowerCase().contains(value.toLowerCase()) ||
                Utils.getCountryName(country, locale)!
                    .toLowerCase()
                    .contains(value.toLowerCase()) ||
                country.dialCode!.contains(value.toLowerCase()),
          )
          .toList();
    }

    return countries;
  }

  /// Returns the country name of a [Country]. if the locale is set and translation in available.
  /// returns the translated name.
  static String? getCountryName(Country country, String? locale) {
    if (locale != null && country.nameTranslations != null) {
      String? translated = country.nameTranslations![locale];
      if (translated != null && translated.isNotEmpty) {
        return translated;
      }
    }
    return country.name;
  }
}
