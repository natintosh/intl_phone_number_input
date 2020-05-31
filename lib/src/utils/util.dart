import 'package:intl_phone_number_input/src/models/country_model.dart';

/// [Utils] class contains utility methods for `intl_phone_number_input` library
class Utils {
  ///  Returns a [Country] form list of [countries] passed that matches [countryCode].
  ///  Returns the first [Country] in the list if no match is available.
  static Country getInitialSelectedCountry(
      List<Country> countries, String countryCode) {
    return countries.firstWhere((country) => country.countryCode == countryCode,
        orElse: () => countries[0]);
  }
}
