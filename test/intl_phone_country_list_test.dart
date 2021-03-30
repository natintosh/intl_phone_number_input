import 'package:flutter_test/flutter_test.dart';
import 'package:intl_phone_number_input/src/models/country_list.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Countries are loaded test', () {
    test('Json is correctly loaded in to memory', () async {
      expect(Countries.countryList.length, greaterThan(0));

      const List<String> expectedTranslations = [
        'sk',
        'se',
        'pl',
        'no',
        'ja',
        'it',
        'zh',
        'nl',
        'de',
        'fr',
        'en',
        'es',
        'pt_BR',
        'sr-Cyrl',
        'sr-Latn',
        "zh_TW"
      ];

      Countries.countryList.forEach((Map<String, dynamic> data) {
        Country country = Country.fromJson(data);

        expect(country.name!.length, greaterThan(0));
        expect(country.alpha2Code!.length, greaterThan(0));
        expect(country.alpha3Code!.length, greaterThan(0));
        expect(country.dialCode!.length, greaterThan(0));
        expect(country.flagUri.length, greaterThan(0));
        expect(country.nameTranslations!.length,
            equals(expectedTranslations.length));
        expectedTranslations.forEach((language) =>
            expect(country.nameTranslations!.containsKey(language), true));
      });
    });
  });
}
