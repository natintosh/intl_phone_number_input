import 'package:intl_phone_number_input/src/models/country_list.dart';
import 'package:libphonenumber/libphonenumber.dart';

class PhoneNumber {
  final String phoneNumber;
  final String dialCode;
  final String isoCode;

  PhoneNumber({this.phoneNumber, this.dialCode, this.isoCode});

  @override
  String toString() {
    return phoneNumber;
  }

  static Future<PhoneNumber> getRegionInfoFromPhoneNumber(
    String phoneNumber, [
    String isoCode = '',
  ]) async {
    RegionInfo regionInfo = await PhoneNumberUtil.getRegionInfo(
        phoneNumber: phoneNumber, isoCode: isoCode);

    String internationalPhoneNumber =
        await PhoneNumberUtil.normalizePhoneNumber(
            phoneNumber: phoneNumber, isoCode: regionInfo.isoCode);

    return PhoneNumber(
        phoneNumber: internationalPhoneNumber,
        dialCode: regionInfo.regionPrefix,
        isoCode: regionInfo.isoCode);
  }

  static String getParsableNumber(String phoneNumber, String dialCode) {
    return phoneNumber.replaceAll(RegExp('^([\\+?$dialCode\\s?]+)'), '');
  }

  String parseNumber() {
    return this
        .phoneNumber
        .replaceAll(RegExp('^([\\+?${this.dialCode}\\s?]+)'), '');
  }

  ///For predefined phone number - get the initial country ISO2 code from the dial code for you to pass as the [initialCountry2LetterCode]
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
