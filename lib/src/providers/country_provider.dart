import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';

const String PropertyName = 'alpha_2_code';

class CountryProvider {
  static Future<List<Country>> getCountriesDataFromJsonFile(
      {@required BuildContext context,
      @required List<String> countries}) async {
    var list = await DefaultAssetBundle.of(context).loadString(
        'packages/intl_phone_number_input/src/models/countries.json');
    List jsonList = jsonDecode(list);

    if (countries == null || countries.isEmpty) {
      return jsonList.map((country) => Country.fromJson(country)).toList();
    }
    List filteredList = jsonList.where((country) {
      return countries.contains(country[PropertyName]);
    }).toList();

    return filteredList.map((country) => Country.fromJson(country)).toList();
  }
}
