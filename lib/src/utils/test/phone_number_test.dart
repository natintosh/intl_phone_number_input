import 'dart:async';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:intl_phone_number_input/src/models/country_list.dart';
import 'package:intl_phone_number_input/src/utils/phone_number/phone_number_util.dart';

class PhoneNumberTest {
  final String? phoneNumber;
  final String? dialCode;
  final String? isoCode;

  PhoneNumberTest({this.phoneNumber, this.dialCode, this.isoCode});

  @override
  String toString() {
    return phoneNumber!;
  }

  static Future<PhoneNumberTest> getRegionInfoFromPhoneNumber(
    String phoneNumber, [
    String isoCode = '',
  ]) async {
    RegionInfo regionInfo = await PhoneNumberUtil.getRegionInfo(
        phoneNumber: phoneNumber, isoCode: isoCode);

    String? internationalPhoneNumber =
        await PhoneNumberUtil.normalizePhoneNumber(
      phoneNumber: phoneNumber,
      isoCode: regionInfo.isoCode ?? isoCode,
    );

    return PhoneNumberTest(
        phoneNumber: internationalPhoneNumber,
        dialCode: regionInfo.regionPrefix,
        isoCode: regionInfo.isoCode);
  }

  static Future<String> getParsableNumber(PhoneNumberTest phoneNumber) async {
    if (phoneNumber.isoCode != null) {
      PhoneNumberTest number = await getRegionInfoFromPhoneNumber(
        phoneNumber.phoneNumber!,
        phoneNumber.isoCode!,
      );
      String? formattedNumber = await PhoneNumberUtil.formatAsYouType(
        phoneNumber: number.phoneNumber!,
        isoCode: number.isoCode!,
      );
      return formattedNumber!.replaceAll(
        RegExp('^([\\+]?${number.dialCode}[\\s]?)'),
        '',
      );
    } else {
      print('ISO Code is "${phoneNumber.isoCode}"');
      return '';
    }
  }

  String parseNumber() {
    return this
        .phoneNumber!
        .replaceAll(RegExp('^([\\+]?${this.dialCode}[\\s]?)'), '');
  }

  static String? getISO2CodeByPrefix(String prefix) {
    if (prefix.isNotEmpty) {
      prefix = prefix.startsWith('+') ? prefix : '+$prefix';
      var country = Countries.countryList
          .firstWhereOrNull((country) => country['dial_code'] == prefix);
      if (country != null && country['alpha_2_code'] != null) {
        return country['alpha_2_code'];
      }
    }
    return null;
  }
}
