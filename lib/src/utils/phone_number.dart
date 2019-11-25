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
}
