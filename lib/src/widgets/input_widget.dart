import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/providers/country_provider.dart';
import 'package:intl_phone_number_input/src/utils/phone_input_formatter.dart';
import 'package:intl_phone_number_input/src/utils/util.dart';
import 'package:libphonenumber/libphonenumber.dart';

class InternationalPhoneNumberInput extends StatefulWidget {
  final ValueChanged<String> onInputChanged;
  final ValueChanged<bool> onInputValidated;

  final VoidCallback onSubmit;
  final TextEditingController textFieldController;
  final TextInputAction keyboardAction;

  final String initialCountry2LetterCode;
  final String hintText;
  final String errorMessage;

  final bool formatInput;
  final bool shouldParse;
  final bool shouldValidate;

  final InputBorder inputBorder;
  final InputDecoration inputDecoration;

  final FocusNode focusNode;

  final List<String> countries;

  const InternationalPhoneNumberInput({
    Key key,
    @required this.onInputChanged,
    this.onInputValidated,
    this.focusNode,
    this.textFieldController,
    this.onSubmit,
    this.keyboardAction,
    this.countries,
    this.inputBorder,
    this.inputDecoration,
    this.initialCountry2LetterCode = 'NG',
    this.hintText = '(800) 000-0001 23',
    this.shouldParse = true,
    this.shouldValidate = true,
    this.formatInput = true,
    this.errorMessage = 'Invalid phone number',
  }) : super(key: key);

  factory InternationalPhoneNumberInput.withCustomDecoration({
    @required ValueChanged<String> onInputChanged,
    ValueChanged<bool> onInputValidated,
    FocusNode focusNode,
    TextEditingController textFieldController,
    VoidCallback onSubmit,
    TextInputAction keyboardAction,
    List<String> countries,
    @required InputDecoration inputDecoration,
    String initialCountry2LetterCode = 'NG',
    bool formatInput = true,
    bool shouldParse = true,
    bool shouldValidate = true,
  }) {
    return InternationalPhoneNumberInput(
      onInputChanged: onInputChanged,
      onInputValidated: onInputValidated,
      focusNode: focusNode,
      textFieldController: textFieldController,
      onSubmit: onSubmit,
      keyboardAction: keyboardAction,
      countries: countries,
      inputDecoration: inputDecoration,
      initialCountry2LetterCode: initialCountry2LetterCode,
      formatInput: formatInput,
      shouldParse: shouldParse,
      shouldValidate: shouldValidate,
    );
  }

  factory InternationalPhoneNumberInput.withCustomBorder({
    @required ValueChanged<String> onInputChanged,
    @required ValueChanged<bool> onInputValidated,
    FocusNode focusNode,
    TextEditingController textFieldController,
    VoidCallback onSubmit,
    TextInputAction keyboardAction,
    List<String> countries,
    @required InputBorder inputBorder,
    @required String hintText,
    String initialCountry2LetterCode = 'NG',
    String errorMessage = 'Invalid phone number',
    bool formatInput = true,
    bool shouldParse = true,
    bool shouldValidate = true,
  }) {
    return InternationalPhoneNumberInput(
      onInputChanged: onInputChanged,
      onInputValidated: onInputValidated,
      focusNode: focusNode,
      textFieldController: textFieldController,
      onSubmit: onSubmit,
      keyboardAction: keyboardAction,
      countries: countries,
      inputBorder: inputBorder,
      hintText: hintText,
      initialCountry2LetterCode: initialCountry2LetterCode,
      errorMessage: errorMessage,
      formatInput: formatInput,
      shouldParse: shouldParse,
      shouldValidate: shouldValidate,
    );
  }

  @override
  State<StatefulWidget> createState() => _InternationalPhoneNumberInputState();
}

class _InternationalPhoneNumberInputState
    extends State<InternationalPhoneNumberInput> {
  final PhoneInputFormatter _kPhoneInputFormatter = PhoneInputFormatter();

  bool _isNotValid = false;

  List<Country> _countries = [];
  Country _selectedCountry;

  TextEditingController _controller;

  List<TextInputFormatter> _buildInputFormatter() {
    List<TextInputFormatter> formatter = [
      LengthLimitingTextInputFormatter(20),
      WhitelistingTextInputFormatter.digitsOnly,
    ];
    if (widget.formatInput) {
      formatter.add(_kPhoneInputFormatter);
    }

    return formatter;
  }

  _loadCountries(BuildContext context) async {
    List<Country> data = await _getCountriesDataFromJsonFile(
        context: context, countries: widget.countries);
    setState(() {
      _countries = data;
      _selectedCountry = Utils.getInitialSelectedCountry(
          _countries, widget.initialCountry2LetterCode);
    });
  }

  Future<List<Country>> _getCountriesDataFromJsonFile(
      {@required BuildContext context,
      @required List<String> countries}) async {
    var list = await CountryProvider.getCountriesDataFromJsonFile(
        context: context, countries: countries);
    return list;
  }

  void _phoneNumberControllerListener() {
    _isNotValid = false;
    String parsedPhoneNumberString =
        _controller.text.replaceAll(RegExp(r'([\(\1\)\1\s\-])'), '');

    if (widget.shouldParse) {
      getParsedPhoneNumber(
              parsedPhoneNumberString, _selectedCountry.countryCode)
          .then((phoneNumber) {
        if (phoneNumber == null) {
          if (widget.onInputValidated != null) {
            widget.onInputValidated(false);
          }
          if (widget.shouldValidate) {
            setState(() {
              _isNotValid = true;
            });
          }
        } else {
          widget.onInputChanged(phoneNumber);
          if (widget.onInputValidated != null) {
            widget.onInputValidated(true);
          }
          if (widget.shouldValidate) {
            setState(() {
              _isNotValid = false;
            });
          }
        }
      });
    } else {
      String phoneNumber =
          '${_selectedCountry.dialCode}$parsedPhoneNumberString';
      widget.onInputChanged(phoneNumber);
    }
  }

  static Future<String> getParsedPhoneNumber(
      String phoneNumber, String iso) async {
    if (phoneNumber.isNotEmpty) {
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

  void _formatTextField() {
    bool isFormatted = _controller.text.contains(RegExp(r'([\(\1\)\1\s\-])'));
    bool isNotEmpty = _controller.text.isNotEmpty;
    if (!isFormatted && isNotEmpty && widget.formatInput) {
      TextEditingValue textEditingValue =
          TextEditingValue(text: _controller.text);
      textEditingValue = _kPhoneInputFormatter.formatEditUpdate(
          _controller.value, textEditingValue);
      _controller.text = textEditingValue.text;
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () => _loadCountries(context));
    _controller = widget.textFieldController ?? TextEditingController();
    _controller.addListener(_phoneNumberControllerListener);
    _controller.addListener(_formatTextField);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          DropdownButtonHideUnderline(
            child: DropdownButton<Country>(
              value: _selectedCountry,
              items: _mapCountryToDropdownItem(_countries),
              onChanged: (value) {
                setState(() {
                  _selectedCountry = value;
                });
                _phoneNumberControllerListener();
              },
            ),
          ),
          Flexible(
            child: TextField(
              controller: _controller,
              focusNode: widget.focusNode,
              keyboardType: TextInputType.phone,
              textInputAction: widget.keyboardAction,
              inputFormatters: _buildInputFormatter(),
              onEditingComplete: widget.onSubmit,
              onChanged: (text) {
                _phoneNumberControllerListener();
              },
              decoration: _getInputDecoration(widget.inputDecoration),
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
          errorText: _isNotValid ? widget.errorMessage : null,
        );
  }

  List<DropdownMenuItem<Country>> _mapCountryToDropdownItem(
          List<Country> countries) =>
      countries
          .map(
            (country) => DropdownMenuItem<Country>(
              value: country,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    country.flagUri,
                    width: 32.0,
                    package: 'intl_phone_number_input',
                  ),
                  SizedBox(width: 12.0),
                  Text(
                    country.dialCode,
                  )
                ],
              ),
            ),
          )
          .toList();
}
