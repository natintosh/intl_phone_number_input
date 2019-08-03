import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';

class CountryProvider {
  static Future<List<Country>> getCountriesDataFromJsonFile(
      {@required BuildContext context}) async {
    var list = await DefaultAssetBundle.of(context).loadString(
        'packages/intl_phone_number_input/src/models/countries.json');
    List jsonList = jsonDecode(list);

    return jsonList.map((country) => Country.fromJson(country)).toList();
  }
}
