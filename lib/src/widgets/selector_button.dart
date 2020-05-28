import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/utils/test/test_helper.dart';
import 'package:intl_phone_number_input/src/widgets/countries_search_list_widget.dart';
import 'package:intl_phone_number_input/src/widgets/input_widget.dart';
import 'package:intl_phone_number_input/src/widgets/item.dart';

class SelectorButton extends StatelessWidget {
  final List<Country> countries;
  final Country country;
  final PhoneInputSelectorType selectorType;
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
    @required this.selectorType,
    @required this.selectorTextStyle,
    @required this.searchBoxDecoration,
    @required this.locale,
    @required this.onCountryChanged,
    @required this.isEnabled,
    @required this.isScrollControlled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return selectorType == PhoneInputSelectorType.DROPDOWN
        ? countries.isNotEmpty && countries.length > 1
            ? DropdownButtonHideUnderline(
                child: DropdownButton<Country>(
                  key: Key(TestHelper.DropdownButtonKeyValue),
                  hint: Item(
                    country: country,
                    textStyle: selectorTextStyle,
                  ),
                  value: country,
                  items: mapCountryToDropdownItem(countries),
                  onChanged: isEnabled ? onCountryChanged : null,
                ),
              )
            : Item(
                country: country,
                textStyle: selectorTextStyle,
              )
        : FlatButton(
            key: Key(TestHelper.DropdownButtonKeyValue),
            padding: EdgeInsetsDirectional.only(start: 12, end: 4),
            onPressed: countries.isNotEmpty && countries.length > 1
                ? () async {
                    Country selected;
                    if (selectorType == PhoneInputSelectorType.BOTTOM_SHEET) {
                      selected = await showCountrySelectorBottomSheet(
                          context, countries);
                    } else {
                      selected =
                          await showCountrySelectorDialog(context, countries);
                    }

                    if (selected != null) {
                      onCountryChanged(selected);
                    }
                  }
                : null,
            child: Item(
              country: country,
              textStyle: selectorTextStyle,
            ),
          );
  }

  List<DropdownMenuItem<Country>> mapCountryToDropdownItem(
      List<Country> countries) {
    return countries.map((country) {
      return DropdownMenuItem<Country>(
        value: country,
        child: Item(
          key: Key(TestHelper.countryItemKeyValue(country.countryCode)),
          textStyle: selectorTextStyle,
          country: country,
          withCountryNames: false,
        ),
      );
    }).toList();
  }

  Future<Country> showCountrySelectorDialog(
      BuildContext context, List<Country> countries) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => AlertDialog(
        content: Container(
          width: double.maxFinite,
          child: CountrySearchListWidget(
            countries,
            locale,
            searchBoxDecoration: searchBoxDecoration,
          ),
        ),
      ),
    );
  }

  Future<Country> showCountrySelectorBottomSheet(
      BuildContext context, List<Country> countries) {
    return showModalBottomSheet(
      context: context,
      clipBehavior: Clip.hardEdge,
      isScrollControlled: isScrollControlled ?? true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          builder: (BuildContext context, ScrollController controller) {
            return Container(
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
              ),
              child: CountrySearchListWidget(
                countries,
                locale,
                searchBoxDecoration: searchBoxDecoration,
                scrollController: controller,
              ),
            );
          },
        );
      },
    );
  }
}
