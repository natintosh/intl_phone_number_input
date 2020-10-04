import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:intl_phone_number_input/src/models/country_list.dart';
import 'package:libphonenumber/libphonenumber.dart';
import 'package:libphonenumber/libphonenumber.dart' as lib;

enum PhoneNumberType {
  FIXED_LINE,
  MOBILE,
  FIXED_LINE_OR_PHONE_NUMBER,
  TOLL_FREE,
  PREMIUM_RATE,
  SHARED_COST,
  VOIP,
  PERSONAL_NUMBER,
  PAGER,
  UAN,
  VOICE_MALE,
  UNKNOWN
}

/// [PhoneNumber] contains detailed information about a phone number
class PhoneNumber extends Equatable {
  /// Either formatted or unformatted String of the phone number
  final String phoneNumber;

  /// The Country [dialCode] of the phone number
  final String dialCode;

  /// Country [isoCode] of the phone number
  final String isoCode;

  /// [_hash] is used to compare instances of [PhoneNumber] object.
  final int _hash;

  /// Returns an integer generated after the object was initialised.
  /// Used to compare different instances of [PhoneNumber]
  int get hash => _hash;

  @override
  List<Object> get props => [phoneNumber, dialCode];

  PhoneNumber({
    this.phoneNumber,
    this.dialCode,
    this.isoCode,
  }) : _hash = 1000 + Random().nextInt(99999 - 1000);

  @override
  String toString() {
    return phoneNumber;
  }

  /// Returns [PhoneNumber] which contains region information about
  /// the [phoneNumber] and [isoCode] passed.
  static Future<PhoneNumber> getRegionInfoFromPhoneNumber(
    String phoneNumber, [
    String isoCode = '',
  ]) async {
    assert(isoCode != null);
    RegionInfo regionInfo = await PhoneNumberUtil.getRegionInfo(
        phoneNumber: phoneNumber ?? '', isoCode: isoCode);

    String internationalPhoneNumber =
        await PhoneNumberUtil.normalizePhoneNumber(
      phoneNumber: phoneNumber,
      isoCode: regionInfo.isoCode ?? isoCode,
    );

    return PhoneNumber(
      phoneNumber: internationalPhoneNumber,
      dialCode: regionInfo.regionPrefix,
      isoCode: regionInfo.isoCode,
    );
  }

  /// Accepts a [PhoneNumber] object and returns a formatted phone number String
  static Future<String> getParsableNumber(PhoneNumber phoneNumber) async {
    assert(phoneNumber != null);
    if (phoneNumber.isoCode != null) {
      PhoneNumber number = await getRegionInfoFromPhoneNumber(
        phoneNumber.phoneNumber,
        phoneNumber.isoCode,
      );
      String formattedNumber = await PhoneNumberUtil.formatAsYouType(
        phoneNumber: number.phoneNumber,
        isoCode: number.isoCode,
      );
      return formattedNumber.replaceAll(
        RegExp('^([\\+]?${number.dialCode}[\\s]?)'),
        '',
      );
    } else {
      print('ISO Code is "${phoneNumber.isoCode}"');
      return '';
    }
  }

  /// Returns a String of [phoneNumber] without [dialCode]
  String parseNumber() {
    return this.phoneNumber.replaceAll("${this.dialCode}", '');
  }

  /// For predefined phone number returns Country's [isoCode] from the dial code,
  /// Returns null if not found.
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

  /// Returns [PhoneNumberType] which is the type of phone number
  /// Accepts [phoneNumber] and [isoCode] and r
  static Future<PhoneNumberType> getPhoneNumberType(
      String phoneNumber, String isoCode) async {
    int index = lib.PhoneNumberType.values.indexOf(
        await lib.PhoneNumberUtil.getNumberType(
            phoneNumber: phoneNumber, isoCode: isoCode));

    return PhoneNumberType.values[index];
  }
}
