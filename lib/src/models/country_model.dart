import 'package:flutter/foundation.dart';

class Country {
  final String name;
  final String countryCode;
  final String dialCode;
  final String flagUri;
  final Map<String, String> nameTranslations;

  Country({
    @required this.name,
    @required this.countryCode,
    @required this.dialCode,
    @required this.flagUri,
    this.nameTranslations,
  });

  factory Country.fromJson(Map<String, dynamic> data) {
    return Country(
      name: data['en_short_name'],
      countryCode: data['alpha_2_code'],
      dialCode: data['dial_code'],
      flagUri: 'assets/flags/${data['alpha_2_code'].toLowerCase()}.png',
      nameTranslations: data['nameTranslations'],
    );
  }
}
