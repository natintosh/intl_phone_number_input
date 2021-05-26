import 'package:intl_phone_number_input/src/utils/phone_number.dart';
import 'package:libphonenumber_plugin/libphonenumber_plugin.dart' as p;

/// A wrapper class [PhoneNumberUtil] that basically switch between plugin available for `Web` or `Android or IOS` and `Other platforms` when available.
class PhoneNumberUtil {
  /// Accepts [phoneNumber] and [isoCode]
  /// Returns [Future<String>]
  static Future<String?> getNameForNumber(
      {required String phoneNumber, required String isoCode}) async {
    return p.PhoneNumberUtil.getNameForNumber(phoneNumber, isoCode);
  }

  /// [isValidNumber] checks if a [phoneNumber] is valid.
  /// Accepts [phoneNumber] and [isoCode]
  /// Returns [Future<bool>].
  static Future<bool?> isValidNumber(
      {required String phoneNumber, required String isoCode}) async {
    if (phoneNumber.length < 2) {
      return false;
    }
    return p.PhoneNumberUtil.isValidPhoneNumber(phoneNumber, isoCode);
  }

  /// [normalizePhoneNumber] normalizes a string of characters representing a phone number
  /// Accepts [phoneNumber] and [isoCode]
  /// Returns [Future<String>]
  static Future<String?> normalizePhoneNumber(
      {required String phoneNumber, required String isoCode}) async {
    return p.PhoneNumberUtil.normalizePhoneNumber(phoneNumber, isoCode);
  }

  /// Accepts [phoneNumber] and [isoCode]
  /// Returns [Future<RegionInfo>] of all information available about the [phoneNumber]
  static Future<RegionInfo> getRegionInfo(
      {required String phoneNumber, required String isoCode}) async {
    var response = await p.PhoneNumberUtil.getRegionInfo(phoneNumber, isoCode);

    return RegionInfo(
        regionPrefix: response.regionPrefix,
        isoCode: response.isoCode,
        formattedPhoneNumber: response.formattedPhoneNumber);
  }

  /// Accepts [phoneNumber] and [isoCode]
  /// Returns [Future<PhoneNumberType>] type of phone number
  static Future<PhoneNumberType> getNumberType(
      {required String phoneNumber, required String isoCode}) async {
    final dynamic type =
        await p.PhoneNumberUtil.getNumberType(phoneNumber, isoCode);

    return PhoneNumberTypeUtil.getType(type.index);
  }

  /// [formatAsYouType] uses Google's libphonenumber input format as you type.
  /// Accepts [phoneNumber] and [isoCode]
  /// Returns [Future<String>]
  static Future<String?> formatAsYouType(
      {required String phoneNumber, required String isoCode}) async {
    return p.PhoneNumberUtil.formatAsYouType(phoneNumber, isoCode);
  }
}

/// [RegionInfo] contains regional information about a phone number.
/// [isoCode] current region/country code of the phone number
/// [regionPrefix] dialCode of the phone number
/// [formattedPhoneNumber] national level formatting rule apply to the phone number
class RegionInfo {
  String? regionPrefix;
  String? isoCode;
  String? formattedPhoneNumber;

  RegionInfo({this.regionPrefix, this.isoCode, this.formattedPhoneNumber});

  RegionInfo.fromJson(Map<String, dynamic> json) {
    regionPrefix = json['regionCode'];
    isoCode = json['isoCode'];
    formattedPhoneNumber = json['formattedPhoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['regionCode'] = this.regionPrefix;
    data['isoCode'] = this.isoCode;
    data['formattedPhoneNumber'] = this.formattedPhoneNumber;
    return data;
  }

  @override
  String toString() {
    return '[RegionInfo prefix=$regionPrefix, iso=$isoCode, formatted=$formattedPhoneNumber]';
  }
}

/// [PhoneNumberTypeUtil] helper class for `PhoneNumberType`
class PhoneNumberTypeUtil {
  /// Returns [PhoneNumberType] for index [value]
  static PhoneNumberType getType(int? value) {
    switch (value) {
      case 0:
        return PhoneNumberType.FIXED_LINE;
      case 1:
        return PhoneNumberType.MOBILE;
      case 2:
        return PhoneNumberType.FIXED_LINE_OR_MOBILE;
      case 3:
        return PhoneNumberType.TOLL_FREE;
      case 4:
        return PhoneNumberType.PREMIUM_RATE;
      case 5:
        return PhoneNumberType.SHARED_COST;
      case 6:
        return PhoneNumberType.VOIP;
      case 7:
        return PhoneNumberType.PERSONAL_NUMBER;
      case 8:
        return PhoneNumberType.PAGER;
      case 9:
        return PhoneNumberType.UAN;
      case 10:
        return PhoneNumberType.VOICEMAIL;
      default:
        return PhoneNumberType.UNKNOWN;
    }
  }
}

/// Extension on PhoneNumberType
extension phonenumbertypeproperties on PhoneNumberType {
  /// Returns the index [int] of the current `PhoneNumberType`
  int get value {
    switch (this) {
      case PhoneNumberType.FIXED_LINE:
        return 0;
      case PhoneNumberType.MOBILE:
        return 1;
      case PhoneNumberType.FIXED_LINE_OR_MOBILE:
        return 2;
      case PhoneNumberType.TOLL_FREE:
        return 3;
      case PhoneNumberType.PREMIUM_RATE:
        return 4;
      case PhoneNumberType.SHARED_COST:
        return 5;
      case PhoneNumberType.VOIP:
        return 6;
      case PhoneNumberType.PERSONAL_NUMBER:
        return 7;
      case PhoneNumberType.PREMIUM_RATE:
        return 8;
      case PhoneNumberType.UAN:
        return 9;
      case PhoneNumberType.VOICEMAIL:
        return 10;
      default:
        return -1;
    }
  }
}
