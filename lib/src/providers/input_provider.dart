import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';

class InputProvider extends ChangeNotifier {
  Country _country;
  List<Country> _countries;

  Country get country {
    return _country;
  }

  set country(Country country) {
    _country = country;
    notifyListeners();
  }

  List<Country> get countries {
    return _countries ?? [];
  }

  set countries(List<Country> countries) {
    _countries = countries;
    notifyListeners();
  }
}
