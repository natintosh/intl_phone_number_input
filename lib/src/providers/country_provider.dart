import 'package:intl_phone_number_input/src/models/country_list.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';

const String PropertyName = 'alpha_2_code';

/// [CountryProvider] provides helper classes that involves manipulations.
/// of Countries from [Countries.countryList]
class CountryProvider {
  /// Get data of Countries.
  ///
  /// Returns List of [Country].
  ///
  ///  * If [countries] is `null` or empty it returns a list of all [Countries.countryList].
  ///  * If [countries] is not empty it returns a filtered list containing
  ///    counties as specified.
  static List<Country> getCountriesData(
      {required List<String>? countries, List<String>? prioritizedCountries}) {
    List jsonList = Countries.countryList;

    if (prioritizedCountries != null) {
      if (countries != null) {
        List filteredList = jsonList.where((country) {
          return countries.contains(country[PropertyName]);
        }).toList();
        jsonList = filteredList;
      }

      List customSortList = [];
      for (var item in prioritizedCountries) {
        customSortList.addAll(jsonList.where((country) {
          return item == country[PropertyName];
        }).toList());
      }
      customSortList.addAll(jsonList);
      return customSortList
          .map((country) => Country.fromJson(country))
          .toList();
    }

    if (countries == null || countries.isEmpty) {
      return jsonList.map((country) => Country.fromJson(country)).toList();
    }
    List filteredList = jsonList.where((country) {
      return countries.contains(country[PropertyName]);
    }).toList();

    return filteredList.map((country) => Country.fromJson(country)).toList();
  }
}
