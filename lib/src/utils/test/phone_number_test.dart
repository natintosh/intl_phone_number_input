import 'package:intl_phone_number_input/src/models/country_list.dart';

class PhoneNumberTest {
  final String phoneNumber;
  final String dialCode;
  final String isoCode;

  PhoneNumberTest({this.phoneNumber, this.dialCode, this.isoCode});

  @override
  String toString() {
    return phoneNumber;
  }

  String parseNumber() {
    return this
        .phoneNumber
        .replaceAll(RegExp('^([\\+]?${this.dialCode}[\\s]?)'), '');
  }

  static String getISO2CodeByPrefix(String prefix) {
    if (prefix != null && prefix.isNotEmpty) {
      prefix = prefix.startsWith('+') ? prefix : '+$prefix';
      var country = Countries.countryList.firstWhere(
          (country) => country['dial_code'] == prefix,
          orElse: () => null);
      if (country != null && country['alpha_2_code'] != null) {
        return country['alpha_2_code'];
      }
    }
    return null;
  }
}
