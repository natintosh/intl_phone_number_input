import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/utils/selector_config.dart';
import 'package:intl_phone_number_input/src/utils/test/test_helper.dart';
import 'package:intl_phone_number_input/src/widgets/countries_search_list_widget.dart';
import 'package:intl_phone_number_input/src/widgets/input_widget.dart';
import 'package:intl_phone_number_input/src/widgets/item.dart';

/// [SelectorButton]
class SelectorButton extends StatelessWidget {
  final List<Country> countries;
  final Country? country;
  final SelectorConfig selectorConfig;
  final TextStyle? selectorTextStyle;
  final InputDecoration? searchBoxDecoration;
  final bool autoFocusSearchField;
  final String? locale;
  final bool isEnabled;
  final bool isScrollControlled;

  final ValueChanged<Country?> onCountryChanged;

  const SelectorButton({
    Key? key,
    required this.countries,
    required this.country,
    required this.selectorConfig,
    required this.selectorTextStyle,
    required this.searchBoxDecoration,
    required this.autoFocusSearchField,
    required this.locale,
    required this.onCountryChanged,
    required this.isEnabled,
    required this.isScrollControlled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final underlineBorderSide = selectorConfig.underlineBorderSide;

    if (selectorConfig.selectorType == PhoneInputSelectorType.DROPDOWN) {
      if (countries.isNotEmpty && countries.length > 1) {
        final dropdown = DropdownButton<Country>(
          key: const Key(TestHelper.DropdownButtonKeyValue),
          hint: Item(
            country: country,
            showFlag: selectorConfig.showFlags,
            useEmoji: selectorConfig.useEmoji,
            leadingPadding: selectorConfig.leadingPadding,
            trailingSpace: selectorConfig.trailingSpace,
            textStyle: selectorTextStyle,
          ),
          value: country,
          underline: (underlineBorderSide != null)
              ? _buildUnderline(underlineBorderSide)
              : null,
          items: mapCountryToDropdownItem(countries),
          onChanged: isEnabled ? onCountryChanged : null,
        );

        if (selectorConfig.hideUnderline) {
          return DropdownButtonHideUnderline(
            child: dropdown,
          );
        }

        return dropdown;
      } else {
        return Item(
          country: country,
          showFlag: selectorConfig.showFlags,
          useEmoji: selectorConfig.useEmoji,
          leadingPadding: selectorConfig.leadingPadding,
          trailingSpace: selectorConfig.trailingSpace,
          textStyle: selectorTextStyle,
        );
      }
    }

    Widget child = MaterialButton(
      key: const Key(TestHelper.DropdownButtonKeyValue),
      padding: EdgeInsets.zero,
      minWidth: 0,
      onPressed: countries.isNotEmpty && countries.length > 1 && isEnabled
          ? () async {
              Country? selected;
              if (selectorConfig.selectorType ==
                  PhoneInputSelectorType.BOTTOM_SHEET) {
                selected =
                    await showCountrySelectorBottomSheet(context, countries);
              } else {
                selected = await showCountrySelectorDialog(context, countries);
              }

              if (selected != null) {
                onCountryChanged(selected);
              }
            }
          : null,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Item(
              country: country,
              showFlag: selectorConfig.showFlags,
              useEmoji: selectorConfig.useEmoji,
              leadingPadding: selectorConfig.leadingPadding,
              trailingSpace: selectorConfig.trailingSpace,
              textStyle: selectorTextStyle,
            ),
          ),
          if (selectorConfig.showTrailingArrow)
            const Icon(
              Icons.arrow_drop_down_outlined,
            ),
        ],
      ),
    );

    if (!selectorConfig.hideUnderline && underlineBorderSide != null) {
      return Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          child,
          Positioned(
            left: 0,
            right: 0,
            bottom: -underlineBorderSide.width,
            child: _buildUnderline(underlineBorderSide),
          ),
        ],
      );
    }
    return child;
  }

  Widget _buildUnderline(BorderSide? borderSide) {
    if (borderSide == null) {
      return const SizedBox();
    }
    return Container(
      height: borderSide.width,
      decoration: BoxDecoration(
        border: Border(
          bottom: borderSide,
        ),
      ),
    );
  }

  /// Converts the list [countries] to `DropdownMenuItem`
  List<DropdownMenuItem<Country>> mapCountryToDropdownItem(
    List<Country> countries,
  ) {
    return countries.map((country) {
      return DropdownMenuItem<Country>(
        value: country,
        child: Item(
          key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
          country: country,
          showFlag: selectorConfig.showFlags,
          useEmoji: selectorConfig.useEmoji,
          textStyle: selectorTextStyle,
          // withCountryNames: false,
          trailingSpace: selectorConfig.trailingSpace,
        ),
      );
    }).toList();
  }

  /// shows a Dialog with list [countries] if the [PhoneInputSelectorType.DIALOG] is selected
  Future<Country?> showCountrySelectorDialog(
    BuildContext inheritedContext,
    List<Country> countries,
  ) {
    return showDialog(
      context: inheritedContext,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          content: Directionality(
            textDirection: Directionality.of(inheritedContext),
            child: SizedBox(
              width: double.maxFinite,
              child: CountrySearchListWidget(
                countries,
                locale,
                searchBoxDecoration: searchBoxDecoration,
                showFlags: selectorConfig.showFlags,
                useEmoji: selectorConfig.useEmoji,
                autoFocus: autoFocusSearchField,
              ),
            ),
          ),
        );
      },
    );
  }

  /// shows a Dialog with list [countries] if the [PhoneInputSelectorType.BOTTOM_SHEET] is selected
  Future<Country?> showCountrySelectorBottomSheet(
      BuildContext inheritedContext, List<Country> countries) {
    return showModalBottomSheet(
      context: inheritedContext,
      clipBehavior: Clip.hardEdge,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      builder: (context) {
        return Stack(children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
          ),
          DraggableScrollableSheet(
            builder: (context, controller) {
              return Directionality(
                textDirection: Directionality.of(inheritedContext),
                child: Container(
                  decoration: ShapeDecoration(
                    color: Theme.of(context).colorScheme.onSurface,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                  ),
                  padding: selectorConfig.bottomSheetPadding,
                  child: CountrySearchListWidget(
                    countries,
                    locale,
                    searchBoxDecoration: searchBoxDecoration,
                    scrollController: controller,
                    showFlags: selectorConfig.showFlags,
                    useEmoji: selectorConfig.useEmoji,
                    autoFocus: autoFocusSearchField,
                  ),
                ),
              );
            },
          ),
        ]);
      },
    );
  }
}
