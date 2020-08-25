import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/providers/country_provider.dart';
import 'package:intl_phone_number_input/src/utils/phone_number.dart';
import 'package:intl_phone_number_input/src/utils/test/test_helper.dart';
import 'package:intl_phone_number_input/src/utils/util.dart';
import 'package:intl_phone_number_input/src/utils/widget_view.dart';
import 'package:intl_phone_number_input/src/widgets/selector_button.dart';

import '../../intl_phone_number_input.dart';

enum PhoneInputSelectorType { DROPDOWN, BOTTOM_SHEET, DIALOG }

class InternationalPhoneNumberInput extends StatefulWidget {
  final SelectorConfig selectorConfig;
  final ValueChanged<PhoneNumber> onChanged;
  final ValueChanged<bool> onInputValidated;
  final ValueChanged<String> onFieldSubmitted;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final PhoneNumber initialValue;
  final InputDecoration decoration;
  final double selectorButtonOnErrorPadding;
  final int maxLength;
  final bool enabled;
  final bool autofocus;
  final bool autofocusSearch;
  final bool autovalidate;
  final bool ignoreBlank;
  final bool countrySelectorScrollControlled;
  final String locale;
  final TextStyle style;
  final TextStyle selectorTextStyle;
  final FormFieldValidator<String> validator;
  final InputBorder inputBorder;
  final InputDecoration searchBoxDecoration;
  final FocusNode focusNode;
  final List<String> countries;

  InternationalPhoneNumberInput({
    Key key,
    this.selectorConfig = const SelectorConfig(),
    this.onChanged,
    this.onInputValidated,
    this.onFieldSubmitted,
    this.controller,
    this.textInputAction,
    this.initialValue,
    this.decoration,
    this.selectorButtonOnErrorPadding = 24,
    this.maxLength = 15,
    this.enabled = true,
    this.autofocus = false,
    this.autofocusSearch = false,
    this.autovalidate = false,
    this.ignoreBlank = false,
    this.countrySelectorScrollControlled = true,
    this.locale,
    this.style,
    this.selectorTextStyle,
    this.validator,
    this.inputBorder,
    this.searchBoxDecoration,
    this.focusNode,
    this.countries,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InternationalPhoneNumberInput> {
  TextEditingController controller;
  double selectorButtonBottomPadding = 0;

  Country country;
  List<Country> countries = [];

  @override
  void initState() {
    Future.delayed(Duration.zero, () => loadCountries(context));
    controller = widget.controller ?? TextEditingController();
    controller.text = widget.initialValue?.phoneNumber;
    super.initState();
  }

  @override
  void setState(fn) {
    if (this.mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _InputWidgetView(
      state: this,
    );
  }

  @override
  void didUpdateWidget(InternationalPhoneNumberInput oldWidget) {
    if (oldWidget.initialValue != widget.initialValue ||
        oldWidget.initialValue?.hash != widget.initialValue?.hash) {
      loadCountries(context);
    }
    super.didUpdateWidget(oldWidget);
  }

  void loadCountries(BuildContext context) {
    if (this.mounted) {
      List<Country> countries =
          CountryProvider.getCountriesData(countries: widget.countries);

      Country country = Utils.getInitialSelectedCountry(
        countries,
        widget.initialValue?.isoCode ?? '',
      );

      setState(() {
        this.countries = countries;
        this.country = country;
      });
    }
  }

  void onCountryChanged(Country country) {
    setState(() {
      this.country = country;
      widget.onChanged(
        PhoneNumber(
          phoneNumber: controller.text,
          dialCode: country.dialCode,
          isoCode: country.countryCode,
        ),
      );
    });
  }
}

class _InputWidgetView
    extends WidgetView<InternationalPhoneNumberInput, _InputWidgetState> {
  final _InputWidgetState state;

  _InputWidgetView({Key key, @required this.state})
      : super(key: key, state: state);

  @override
  Widget build(BuildContext context) {
    final countryCode = state?.country?.countryCode ?? '';
    final dialCode = state?.country?.dialCode ?? '';

    return Container(
      child: Row(
        textDirection: TextDirection.ltr,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SelectorButton(
                country: state.country,
                countries: state.countries,
                onCountryChanged: state.onCountryChanged,
                selectorConfig: widget.selectorConfig,
                selectorTextStyle: widget.selectorTextStyle,
                searchBoxDecoration: widget.searchBoxDecoration,
                locale: widget.locale,
                isEnabled: widget.enabled,
                autoFocusSearchField: widget.autofocusSearch,
                isScrollControlled: widget.countrySelectorScrollControlled,
              ),
              SizedBox(
                height: state.selectorButtonBottomPadding,
              ),
            ],
          ),
          SizedBox(width: 12),
          Flexible(
            child: Container(
              height: 70,
              child: TextFormField(
                key: Key(TestHelper.TextInputKeyValue),
                textDirection: TextDirection.ltr,
                controller: state.controller,
                focusNode: widget.focusNode,
                enabled: widget.enabled,
                autofocus: widget.autofocus,
                keyboardType: TextInputType.phone,
                textInputAction: widget.textInputAction,
                style: widget.style,
                decoration: widget.decoration,
                onEditingComplete: () {
                  widget.onFieldSubmitted(state.controller.text);
                },
                onFieldSubmitted: widget.onFieldSubmitted,
                autovalidate: widget.autovalidate,
                validator: widget.validator,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(widget.maxLength),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (String value) {
                  widget.onChanged(
                    PhoneNumber(
                      phoneNumber: value,
                      dialCode: dialCode,
                      isoCode: countryCode,
                    ),
                  );
                },
                maxLength: widget.maxLength,
              ),
            ),
          )
        ],
      ),
    );
  }
}
