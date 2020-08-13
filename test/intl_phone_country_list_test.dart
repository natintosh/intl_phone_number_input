import 'package:flutter_test/flutter_test.dart';
import 'package:intl_phone_number_input/src/models/country_list.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Countries are loaded test', () {
    test('Json is correctly loaded in to memory', () async {
      expect(Countries.countryList.length, greaterThan(0));

      Countries.countryList.forEach((Map<String, dynamic> data) {
        Country country = Country.fromJson(data);

        expect(country.name.length, greaterThan(0));
        expect(country.countryCode.length, greaterThan(0));
        expect(country.dialCode.length, greaterThan(0));
        expect(country.flagUri.length, greaterThan(0));
        expect(country.nameTranslations.length, equals(12));

        expect(country.nameTranslations.containsKey('sk'), true);
        expect(country.nameTranslations.containsKey('se'), true);
        expect(country.nameTranslations.containsKey('pl'), true);
        expect(country.nameTranslations.containsKey('no'), true);
        expect(country.nameTranslations.containsKey('ja'), true);
        expect(country.nameTranslations.containsKey('it'), true);
        expect(country.nameTranslations.containsKey('zh'), true);
        expect(country.nameTranslations.containsKey('nl'), true);
        expect(country.nameTranslations.containsKey('de'), true);
        expect(country.nameTranslations.containsKey('fr'), true);
        expect(country.nameTranslations.containsKey('en'), true);
        expect(country.nameTranslations.containsKey('es'), true);
      });
    });
  });
}
