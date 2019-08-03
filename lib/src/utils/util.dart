import 'package:intl_phone_number_input/src/models/country_model.dart';

class Utils {
  static Country getInitialSelectedCountry(
      List<Country> countries, String countryCode) {
    return countries.firstWhere((country) => country.countryCode == countryCode,
        orElse: () => countries[0]);
  }

  static void validatePhoneNumber(String phoneNumber) {}
}
