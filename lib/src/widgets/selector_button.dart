import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/widgets/item.dart';

class SelectorButton extends StatelessWidget {
  final List<Country> countries;
  final Country country;
  final TextStyle selectorTextStyle;
  final InputDecoration searchBoxDecoration;
  final String locale;
  final bool isEnabled;
  final bool isScrollControlled;

  final ValueChanged<Country> onCountryChanged;

  const SelectorButton({
    Key key,
    @required this.countries,
    @required this.country,
    @required this.selectorTextStyle,
    @required this.searchBoxDecoration,
    @required this.locale,
    @required this.onCountryChanged,
    @required this.isEnabled,
    @required this.isScrollControlled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return countries.isNotEmpty && countries.length > 1
        ? DropdownButtonHideUnderline(
            child: DropdownButton<Country>(
                hint: Item(country: country, textStyle: selectorTextStyle),
                value: country,
                items: mapCountryToDropdownItem(countries),
                onChanged: isEnabled ? onCountryChanged : null))
        : Item(country: country, textStyle: selectorTextStyle);
  }

  List<DropdownMenuItem<Country>> mapCountryToDropdownItem(List<Country> countries) {
    return countries.map((country) {
      return DropdownMenuItem<Country>(
          value: country,
          child: Item(
              textStyle: selectorTextStyle,
              country: country,
              withCountryNames: false));
    }).toList();
  }
}
