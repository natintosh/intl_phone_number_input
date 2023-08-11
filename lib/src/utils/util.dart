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
  static String generateFlagEmojiUnicode(String countryCode) {
    final base = 127397;

    return countryCode.codeUnits
        .map((e) => String.fromCharCode(base + e))
        .toList()
        .reduce((value, element) => value + element)
        .toString();
  }

  /// Filters the list of Country by text from the search box.
  static List<Country> filterCountries({
    required List<Country> countries,
    required String? locale,
    required String value,
  }) {
    if (value.isNotEmpty) {
      final filteredCountries = countries
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

      final matchDialCode = filteredCountries[0].dialCode!.contains(value);
      final matchLocaleName =
          Utils.getCountryName(filteredCountries[0], locale)!
              .toLowerCase()
              .contains(value);

      if (!matchDialCode && !matchLocaleName) return filteredCountries;

      return filteredCountries
        ..sort((a, b) {
          final compareLengthDialCode =
              a.dialCode!.length.compareTo(b.dialCode!.length);
          final compareLengthName = Utils.getCountryName(a, locale)!
              .toLowerCase()
              .length
              .compareTo(Utils.getCountryName(b, locale)!.toLowerCase().length);

          if (matchDialCode && compareLengthDialCode != 0) {
            return compareLengthDialCode;
          } else if (matchLocaleName && compareLengthName != 0) {
            return compareLengthName;
          }

          return matchDialCode
              ? a.dialCode!.compareTo(b.dialCode!)
              : Utils.getCountryName(a, locale)!.toLowerCase().length.compareTo(
                  Utils.getCountryName(b, locale)!
                      .toLowerCase()
                      .length); // Sort lexicographically
        });
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
