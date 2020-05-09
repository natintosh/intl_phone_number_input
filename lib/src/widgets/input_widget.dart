import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/providers/country_provider.dart';
import 'package:intl_phone_number_input/src/providers/input_provider.dart';
import 'package:intl_phone_number_input/src/utils/formatter/as_you_type_formatter.dart';
import 'package:intl_phone_number_input/src/utils/phone_number.dart';
import 'package:intl_phone_number_input/src/utils/test/test_helper.dart';
import 'package:intl_phone_number_input/src/utils/util.dart';
import 'package:intl_phone_number_input/src/widgets/countries_search_list_widget.dart';
import 'package:libphonenumber/libphonenumber.dart';
import 'package:provider/provider.dart';

enum PhoneInputSelectorType { DROPDOWN, BOTTOM_SHEET, DIALOG }

class InternationalPhoneNumberInput extends StatelessWidget {
  final PhoneInputSelectorType selectorType;

  final ValueChanged<PhoneNumber> onInputChanged;
  final ValueChanged<bool> onInputValidated;

  final VoidCallback onSubmit;
  final TextEditingController textFieldController;
  final TextInputAction keyboardAction;

  final PhoneNumber initialValue;
  final String hintText;
  final String errorMessage;

  final bool isEnabled;
  final bool formatInput;
  final bool autoFocus;
  final bool autoValidate;
  final bool ignoreBlank;
  final bool countrySelectorScrollControlled;

  final String locale;

  /// The style to use for the text being edited.
  ///
  /// This text style is also used as the base style for the [decoration].
  ///
  /// If null, defaults to the `subhead` text style from the current [Theme].
  final TextStyle textStyle;
  final InputBorder inputBorder;
  final InputDecoration inputDecoration;
  final InputDecoration searchBoxDecoration;

  final FocusNode focusNode;

  final List<String> countries;

  const InternationalPhoneNumberInput(
      {Key key,
      this.selectorType,
      @required this.onInputChanged,
      this.onInputValidated,
      this.focusNode,
      this.textFieldController,
      this.onSubmit,
      this.keyboardAction,
      this.countries,
      this.textStyle,
      this.inputBorder,
      this.inputDecoration,
      this.searchBoxDecoration,
      this.initialValue,
      this.hintText = 'Phone Number',
      this.isEnabled = true,
      this.autoFocus = false,
      this.autoValidate = false,
      this.formatInput = true,
      this.errorMessage = 'Invalid phone number',
      this.ignoreBlank = false,
      this.locale,
      this.countrySelectorScrollControlled = true})
      : super(key: key);

  factory InternationalPhoneNumberInput.withCustomDecoration({
    PhoneInputSelectorType selectorType,
    @required ValueChanged<PhoneNumber> onInputChanged,
    ValueChanged<bool> onInputValidated,
    FocusNode focusNode,
    TextEditingController textFieldController,
    VoidCallback onSubmit,
    TextInputAction keyboardAction,
    List<String> countries,
    TextStyle textStyle,
    String errorMessage,
    @required InputDecoration inputDecoration,
    InputDecoration searchBoxDecoration,
    PhoneNumber initialValue,
    bool isEnabled = true,
    bool formatInput = true,
    bool autoFocus = false,
    bool autoValidate = false,
    bool ignoreBlank = false,
    bool countrySelectorScrollControlled = true,
    String locale,
  }) {
    return InternationalPhoneNumberInput(
      selectorType: selectorType,
      onInputChanged: onInputChanged,
      onInputValidated: onInputValidated,
      focusNode: focusNode,
      textFieldController: textFieldController,
      onSubmit: onSubmit,
      keyboardAction: keyboardAction,
      countries: countries,
      textStyle: textStyle,
      inputDecoration: inputDecoration,
      searchBoxDecoration: searchBoxDecoration,
      initialValue: initialValue,
      isEnabled: isEnabled,
      formatInput: formatInput,
      autoFocus: autoFocus,
      autoValidate: autoValidate,
      ignoreBlank: ignoreBlank,
      errorMessage: errorMessage,
      locale: locale,
      countrySelectorScrollControlled: countrySelectorScrollControlled,
    );
  }

  factory InternationalPhoneNumberInput.withCustomBorder({
    PhoneInputSelectorType selectorType,
    @required ValueChanged<PhoneNumber> onInputChanged,
    @required ValueChanged<bool> onInputValidated,
    FocusNode focusNode,
    TextEditingController textFieldController,
    VoidCallback onSubmit,
    TextInputAction keyboardAction,
    List<String> countries,
    TextStyle textStyle,
    @required InputBorder inputBorder,
    @required String hintText,
    PhoneNumber initialValue,
    String errorMessage = 'Invalid phone number',
    bool isEnabled = true,
    bool formatInput = true,
    bool autoFocus = false,
    bool autoValidate = false,
    bool ignoreBlank = false,
    bool countrySelectorScrollControlled = true,
    String locale,
  }) {
    return InternationalPhoneNumberInput(
      selectorType: selectorType,
      onInputChanged: onInputChanged,
      onInputValidated: onInputValidated,
      focusNode: focusNode,
      textFieldController: textFieldController,
      onSubmit: onSubmit,
      keyboardAction: keyboardAction,
      countries: countries,
      textStyle: textStyle,
      inputBorder: inputBorder,
      hintText: hintText,
      initialValue: initialValue,
      errorMessage: errorMessage,
      formatInput: formatInput,
      isEnabled: isEnabled,
      autoFocus: autoFocus,
      autoValidate: autoValidate,
      ignoreBlank: ignoreBlank,
      locale: locale,
      countrySelectorScrollControlled: countrySelectorScrollControlled,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return InputProvider();
      },
      child: _InputWidget(
          key: UniqueKey(),
          selectorType: selectorType ?? PhoneInputSelectorType.DROPDOWN,
          onInputChanged: onInputChanged,
          onInputValidated: onInputValidated,
          onSubmit: onSubmit,
          textFieldController: textFieldController,
          focusNode: focusNode,
          keyboardAction: keyboardAction,
          initialValue: initialValue,
          hintText: hintText,
          errorMessage: errorMessage,
          autoFormatInput: formatInput,
          autoFocus: autoFocus,
          autoValidate: autoValidate,
          isEnabled: isEnabled,
          textStyle: textStyle,
          inputBorder: inputBorder,
          inputDecoration: inputDecoration,
          searchBoxDecoration: searchBoxDecoration,
          countries: countries,
          ignoreBlank: ignoreBlank,
          locale: locale,
          countrySelectorScrollControlled: countrySelectorScrollControlled),
    );
  }
}

class _InputWidget extends StatefulWidget {
  final PhoneInputSelectorType selectorType;

  final ValueChanged<PhoneNumber> onInputChanged;
  final ValueChanged<bool> onInputValidated;

  final VoidCallback onSubmit;
  final TextEditingController textFieldController;
  final TextInputAction keyboardAction;

  final PhoneNumber initialValue;
  final String hintText;
  final String errorMessage;

  final bool isEnabled;
  final bool autoFormatInput;
  final bool autoFocus;
  final bool autoValidate;
  final bool ignoreBlank;
  final bool countrySelectorScrollControlled;

  final String locale;

  /// The style to use for the text being edited.
  ///
  /// This text style is also used as the base style for the [decoration].
  ///
  /// If null, defaults to the `subhead` text style from the current [Theme].
  final TextStyle textStyle;
  final InputBorder inputBorder;
  final InputDecoration inputDecoration;
  final InputDecoration searchBoxDecoration;

  final FocusNode focusNode;

  final List<String> countries;

  const _InputWidget(
      {Key key,
      this.selectorType,
      @required this.onInputChanged,
      this.onInputValidated,
      this.focusNode,
      this.textFieldController,
      this.onSubmit,
      this.keyboardAction,
      this.countries,
      this.textStyle,
      this.inputBorder,
      this.inputDecoration,
      this.searchBoxDecoration,
      this.initialValue,
      this.hintText = 'Phone Number',
      this.isEnabled = true,
      this.autoFocus = false,
      this.autoValidate = false,
      this.autoFormatInput = true,
      this.errorMessage = 'Invalid phone number',
      this.ignoreBlank = false,
      this.countrySelectorScrollControlled = true,
      this.locale})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<_InputWidget> {
  TextEditingController controller;
  FocusNode focusNode;

  _loadCountries(BuildContext context) {
    if (this.mounted) {
      InputProvider provider =
          Provider.of<InputProvider>(context, listen: false);

      provider.countries = CountryProvider.getCountriesData(
          context: context, countries: widget.countries);

      provider.country = Utils.getInitialSelectedCountry(
        provider.countries,
        widget.initialValue?.isoCode ?? '',
      );
    }
  }

  void _phoneNumberControllerListener() {
    if (this.mounted) {
      InputProvider provider =
          Provider.of<InputProvider>(context, listen: false);
      provider.isNotValid = true;
      String parsedPhoneNumberString =
          controller.text.replaceAll(RegExp(r'[^\d+]'), '');

      getParsedPhoneNumber(
              parsedPhoneNumberString, provider.country?.countryCode)
          .then((phoneNumber) {
        if (phoneNumber == null) {
          String phoneNumber =
              '${provider.country?.dialCode}$parsedPhoneNumberString';
          widget.onInputChanged(new PhoneNumber(
              phoneNumber: phoneNumber,
              isoCode: provider.country?.countryCode,
              dialCode: provider.country?.dialCode));
          if (widget.onInputValidated != null) {
            widget.onInputValidated(false);
          }
          provider.isNotValid = true;
        } else {
          widget.onInputChanged(new PhoneNumber(
              phoneNumber: phoneNumber,
              isoCode: provider.country?.countryCode,
              dialCode: provider.country?.dialCode));
          if (widget.onInputValidated != null) {
            widget.onInputValidated(true);
          }
          provider.isNotValid = false;
        }
      });
    }
  }

  static Future<String> getParsedPhoneNumber(
      String phoneNumber, String iso) async {
    if (phoneNumber.isNotEmpty && iso != null) {
      try {
        bool isValidPhoneNumber = await PhoneNumberUtil.isValidPhoneNumber(
            phoneNumber: phoneNumber, isoCode: iso);

        if (isValidPhoneNumber) {
          return await PhoneNumberUtil.normalizePhoneNumber(
              phoneNumber: phoneNumber, isoCode: iso);
        }
      } on Exception {
        return null;
      }
    }
    return null;
  }

  void _initialiseWidget() async {
    if (controller.text.isEmpty && widget.initialValue != null) {
      if (widget.initialValue.phoneNumber != null &&
          widget.initialValue.phoneNumber.isNotEmpty) {
        controller.text =
            await PhoneNumber.getParsableNumber(widget.initialValue);

        _phoneNumberControllerListener();
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      if (widget.autoFocus && !focusNode.hasFocus) {
        FocusScope.of(context).requestFocus(focusNode);
      }
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () => _loadCountries(context));
    focusNode = widget.focusNode ?? FocusNode();
    controller = widget.textFieldController ?? TextEditingController();
    _initialiseWidget();
    super.initState();
  }

  @override
  void setState(fn) {
    if (this.mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    widget.textFieldController ?? controller?.dispose();
    widget.focusNode ?? focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    InputProvider provider = Provider.of<InputProvider>(context);

    return Container(
      child: Row(
        textDirection: TextDirection.ltr,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          widget.selectorType == PhoneInputSelectorType.DROPDOWN
              ? provider.countries.isNotEmpty && provider.countries.length > 1
                  ? DropdownButtonHideUnderline(
                      child: DropdownButton<Country>(
                        key: Key(TestHelper.DropdownButtonKeyValue),
                        hint: _Item(country: provider.country),
                        value: provider.country,
                        items: _mapCountryToDropdownItem(provider.countries),
                        onChanged: widget.isEnabled
                            ? (value) {
                                provider.country = value;
                                _phoneNumberControllerListener();
                              }
                            : null,
                      ),
                    )
                  : _Item(country: provider.country)
              : FlatButton(
                  key: Key(TestHelper.DropdownButtonKeyValue),
                  padding: EdgeInsetsDirectional.only(start: 12, end: 4),
                  onPressed: provider.countries.isNotEmpty &&
                          provider.countries.length > 1
                      ? () async {
                          Country selected;
                          if (widget.selectorType ==
                              PhoneInputSelectorType.BOTTOM_SHEET) {
                            selected =
                                await _showCountrySelectorBottomSheet(provider);
                          } else {
                            selected =
                                await _showCountrySelectorDialog(provider);
                          }

                          if (selected != null) {
                            provider.country = selected;
                            _phoneNumberControllerListener();
                          }
                        }
                      : null,
                  child: _Item(country: provider.country),
                ),
          SizedBox(width: 12),
          Flexible(
            child: TextFormField(
              key: Key(TestHelper.TextInputKeyValue),
              textDirection: TextDirection.ltr,
              controller: controller,
              focusNode: focusNode,
              enabled: widget.isEnabled,
              keyboardType: TextInputType.phone,
              textInputAction: widget.keyboardAction,
              style: widget.textStyle,
              decoration: _getInputDecoration(widget.inputDecoration),
              onEditingComplete: widget.onSubmit,
              autovalidate: widget.autoValidate,
              validator: (String value) {
                return provider.isNotValid &&
                        (value.isNotEmpty || widget.ignoreBlank == false)
                    ? widget.errorMessage
                    : null;
              },
              inputFormatters: [
                LengthLimitingTextInputFormatter(15),
                widget.autoFormatInput
                    ? AsYouTypeFormatter(
                        isoCode: provider.country?.countryCode ?? '',
                        dialCode: provider.country?.dialCode ?? '',
                        onInputFormatted: (TextEditingValue value) {
                          setState(() {
                            controller.value = value;
                          });
                        },
                      )
                    : WhitelistingTextInputFormatter.digitsOnly,
              ],
              onChanged: (text) {
                _phoneNumberControllerListener();
              },
            ),
          )
        ],
      ),
    );
  }

  InputDecoration _getInputDecoration(InputDecoration decoration) {
    return decoration ??
        InputDecoration(
          border: widget.inputBorder ?? UnderlineInputBorder(),
          hintText: widget.hintText,
        );
  }

  List<DropdownMenuItem<Country>> _mapCountryToDropdownItem(
      List<Country> countries) {
    return countries.map((country) {
      return DropdownMenuItem<Country>(
        value: country,
        child: _Item(
          key: Key(TestHelper.countryItemKeyValue(country.countryCode)),
          country: country,
          withCountryNames: false,
        ),
      );
    }).toList();
  }

  Future<Country> _showCountrySelectorBottomSheet(InputProvider provider) {
    return showModalBottomSheet(
      context: context,
      clipBehavior: Clip.hardEdge,
      isScrollControlled: widget.countrySelectorScrollControlled ?? true,
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
                provider.countries,
                widget.locale,
                searchBoxDecoration: widget.searchBoxDecoration,
                scrollController: controller,
              ),
            );
          },
        );
      },
    );
  }

  Future<Country> _showCountrySelectorDialog(InputProvider provider) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => AlertDialog(
        content: Container(
          width: double.maxFinite,
          child: CountrySearchListWidget(
            provider.countries,
            widget.locale,
            searchBoxDecoration: widget.searchBoxDecoration,
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final Country country;
  final bool withCountryNames;

  const _Item({Key key, this.country, this.withCountryNames = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        textDirection: TextDirection.ltr,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          country?.flagUri != null
              ? Image.asset(
                  country?.flagUri,
                  width: 32.0,
                  package: 'intl_phone_number_input',
                )
              : SizedBox.shrink(),
          SizedBox(width: 12.0),
          Text('${country?.dialCode ?? ''}', textDirection: TextDirection.ltr),
        ],
      ),
    );
  }
}
