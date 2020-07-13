import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:intl_phone_number_input/src/models/country_list.dart';

/// [PhoneNumber] contains detailed information about a phone number
class PhoneNumber extends Equatable {
  /// Either formatted or unformatted String of the phone number
  final String phoneNumber;

  /// The Country [dialCode] of the phone number
  final String dialCode;

  /// Country [isoCode] of the phone number
  final String isoCode;
  final int _hash;

  /// Returns an integer generated after the object was initialised.
  /// Used to compare different instances of [PhoneNumber]
  int get hash => _hash;

  @override
  List<Object> get props => [phoneNumber, dialCode];

  PhoneNumber({this.phoneNumber, this.dialCode, this.isoCode})
      : _hash = 1000 + Random().nextInt(99999 - 1000);

  @override
  String toString() {
    return phoneNumber;
  }

  /// Returns a String of [phoneNumber] without [dialCode]
  String parseNumber() {
    return this
        .phoneNumber
        .replaceAll(RegExp('^([\\+]?${this.dialCode}[\\s]?)'), '');
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
}
