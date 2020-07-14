import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/src/models/country_list.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/providers/country_provider.dart';
import 'package:intl_phone_number_input/src/utils/phone_number.dart';
import 'package:intl_phone_number_input/src/utils/util.dart';
import 'package:intl_phone_number_input/src/utils/widget_view.dart';
import 'package:intl_phone_number_input/src/widgets/selector_button.dart';

/// A [TextFormField] for [InternationalPhoneNumberInput].
///
/// [initialValue] accepts a [PhoneNumber] this is used to set initial values
/// for phone the input field and the selector button
///
/// [selectorButtonOnErrorPadding] is a double which is used to align the selector
/// button with the input field when an error occurs
///
/// [locale] accepts a country locale which will be used to translation, if the
/// translation exist
///
/// [countries] accepts list of string on Country isoCode, if specified filters
/// available countries to match the [countries] specified.
class InternationalPhoneNumberInput extends StatefulWidget {
  final ValueChanged<PhoneNumber> onInputChanged;
  final ValueChanged<bool> onInputValidated;

  final VoidCallback onSubmit;
  final TextEditingController textFieldController;
  final TextInputAction keyboardAction;

  final PhoneNumber initialValue;
  final String hintText;
  final String errorMessage;

  final double selectorButtonOnErrorPadding;
  final int maxLength;

  final bool isEnabled;
  final bool formatInput;
  final bool autoFocus;
  final bool autoValidate;
  final bool ignoreBlank;
  final bool countrySelectorScrollControlled;

  final String locale;

  final TextStyle textStyle;
  final TextStyle selectorTextStyle;
  final InputBorder inputBorder;
  final InputDecoration inputDecoration;
  final InputDecoration searchBoxDecoration;

  final FocusNode focusNode;

  final List<String> countries;

  InternationalPhoneNumberInput(
      {Key key,
      this.onInputChanged,
      this.onInputValidated,
      this.onSubmit,
      this.textFieldController,
      this.keyboardAction,
      this.initialValue,
      this.hintText = 'Phone number',
      this.errorMessage = 'Invalid phone number',
      this.selectorButtonOnErrorPadding = 24,
      this.maxLength = 15,
      this.isEnabled = true,
      this.formatInput = true,
      this.autoFocus = false,
      this.autoValidate = false,
      this.ignoreBlank = false,
      this.countrySelectorScrollControlled = true,
      this.locale,
      this.textStyle,
      this.selectorTextStyle,
      this.inputBorder,
      this.inputDecoration,
      this.searchBoxDecoration,
      this.focusNode,
      this.countries})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InternationalPhoneNumberInput> {
  TextEditingController controller;
  double selectorButtonBottomPadding = 0;

  Country country;
  List<Country> countries = [];
  bool isNotValid = true;

  @override
  void initState() {
    Future.delayed(Duration.zero, () => loadCountries(context));
    final _number = widget.initialValue?.phoneNumber;
    controller = widget.textFieldController ?? TextEditingController(text: _number ?? '');
    initialiseWidget();
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
    return _InputWidgetView(state: this);
  }

  /// [initialiseWidget] sets initial values of the widget
  void initialiseWidget() async {
    if (widget.initialValue != null) {
      if (widget.initialValue.phoneNumber != null &&
          widget.initialValue.phoneNumber.isNotEmpty) {
        phoneNumberControllerListener();
      }
    }
  }

  /// loads countries from [Countries.countryList] and selected Country
  void loadCountries(BuildContext context) {
    if (this.mounted) {
      List<Country> countries = CountryProvider.getCountriesData(countries: widget.countries);

      Country country = Utils.getInitialSelectedCountry(countries, widget.initialValue?.isoCode ?? '');

      setState(() {
        this.countries = countries;
        this.country = country;
      });
    }
  }

  /// Listener that validates changes from the widget, returns a bool to
  /// the `ValueCallback` [widget.onInputValidated]
  void phoneNumberControllerListener() {
    if (this.mounted) {
      String parsedPhoneNumberString = controller.text.replaceAll(RegExp(r'[^\d+]'), '');
      if (parsedPhoneNumberString == null) {
        String phoneNumber = '${this.country?.dialCode}$parsedPhoneNumberString';

        if (widget.onInputChanged != null) {
          widget.onInputChanged(PhoneNumber(
              phoneNumber: phoneNumber,
              isoCode: this.country?.countryCode,
              dialCode: this.country?.dialCode));
        }

        if (widget.onInputValidated != null) {
          widget.onInputValidated(false);
        }
        this.isNotValid = true;
      } else {
        if (widget.onInputChanged != null) {
          widget.onInputChanged(PhoneNumber(
              phoneNumber: parsedPhoneNumberString,
              isoCode: this.country?.countryCode,
              dialCode: this.country?.dialCode));
        }

        if (widget.onInputValidated != null) {
          widget.onInputValidated(true);
        }
        this.isNotValid = false;
      }
    }
  }

  /// Creates or Select [InputDecoration]
  InputDecoration getInputDecoration(InputDecoration decoration) {
    return decoration ??
        InputDecoration(
            border: widget.inputBorder ?? UnderlineInputBorder(),
            hintText: widget.hintText);
  }

  /// Validate the phone number when a change occurs
  void onChanged(String value) {
    phoneNumberControllerListener();
  }

  /// Validate and returns a validation error when [FormState] validate is called.
  ///
  /// Also updates [selectorButtonBottomPadding]
  String validator(String value) {
    bool isValid = this.isNotValid && (value.isNotEmpty || widget.ignoreBlank == false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (isValid && widget.errorMessage != null) {
        setState(() {
          this.selectorButtonBottomPadding =
              widget.selectorButtonOnErrorPadding ?? 24;
        });
      } else {
        setState(() {
          this.selectorButtonBottomPadding = 0;
        });
      }
    });

    return isValid ? widget.errorMessage : null;
  }

  /// Changes Selector Button Country and Validate Change.
  void onCountryChanged(Country country) {
    setState(() {
      this.country = country;
    });
    phoneNumberControllerListener();
  }
}

class _InputWidgetView extends WidgetView<InternationalPhoneNumberInput, _InputWidgetState> {
  final _InputWidgetState state;

  _InputWidgetView({Key key, @required this.state}) : super(key: key, state: state);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
            textDirection: TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            SelectorButton(
                country: state.country,
                countries: state.countries,
                onCountryChanged: state.onCountryChanged,
                selectorTextStyle: widget.selectorTextStyle,
                searchBoxDecoration: widget.searchBoxDecoration,
                locale: widget.locale,
                isEnabled: widget.isEnabled,
                isScrollControlled: widget.countrySelectorScrollControlled),
            SizedBox(height: state.selectorButtonBottomPadding)
          ]),
          SizedBox(width: 12),
          Flexible(
              child: TextFormField(
                  textDirection: TextDirection.ltr,
                  controller: state.controller,
                  focusNode: widget.focusNode,
                  enabled: widget.isEnabled,
                  autofocus: widget.autoFocus,
                  keyboardType: TextInputType.phone,
                  textInputAction: widget.keyboardAction,
                  style: widget.textStyle,
                  decoration: state.getInputDecoration(widget.inputDecoration),
                  onEditingComplete: widget.onSubmit,
                  autovalidate: widget.autoValidate,
                  validator: state.validator,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(widget.maxLength),
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  onChanged: state.onChanged))
        ]));
  }
}
