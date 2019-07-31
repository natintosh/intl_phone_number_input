import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:intl_phone_number_input/models/country_model.dart';

class CountryProvider {
  Future<List<Country>> getCountriesDataFromJsonFile(
      {@required BuildContext context}) async {
    var list = await DefaultAssetBundle.of(context)
        .loadString('assets/countries.json');
    List jsonList = jsonDecode(list);

    return jsonList.map((country) => Country.fromJson(country)).toList();
  }
}
