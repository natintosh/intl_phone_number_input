import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/models/country_model.dart';
import 'package:intl_phone_number_input/providers/country_provider.dart';
import 'package:intl_phone_number_input/utils/phone_input_formatter.dart';
import 'package:intl_phone_number_input/utils/util.dart';
import 'package:libphonenumber/libphonenumber.dart';

class InternationalPhoneNumberInput extends StatefulWidget {
  final ValueChanged<String> onInputChange;
  final ValueChanged<bool> onInputValidated;

  final String initialCountry2LetterCode;
  final String hintText;
  final String errorMessage;

  final bool formatInput;
  final bool shouldValidateAndParse;

  final InputBorder inputBorder;
  final InputDecoration inputDecoration;

  const InternationalPhoneNumberInput(
      {Key key,
      @required this.onInputChange,
      this.onInputValidated,
      this.inputBorder,
      this.inputDecoration,
      this.initialCountry2LetterCode = 'NG',
      this.hintText = '(800) 000-0001 23',
      this.shouldValidateAndParse = true,
      this.formatInput = true,
      this.errorMessage = 'Invalid phone number'})
      : super(key: key);

  factory InternationalPhoneNumberInput.withCustomDecoration({
    @required ValueChanged<String> onInputChange,
    ValueChanged<bool> onInputValidated,
    @required InputDecoration inputDecoration,
    String initialCountry2LetterCode = 'NG',
    bool formatInput = true,
    bool shouldValidateAndParse = true,
  }) {
    return InternationalPhoneNumberInput(
      onInputChange: onInputChange,
      onInputValidated: onInputValidated,
      inputDecoration: inputDecoration,
      initialCountry2LetterCode: initialCountry2LetterCode,
      formatInput: formatInput,
      shouldValidateAndParse: shouldValidateAndParse,
    );
  }

  factory InternationalPhoneNumberInput.withCustomBorder({
    @required ValueChanged<String> onInputChange,
    @required InputBorder inputBorder,
    @required String hintText,
    String initialCountry2LetterCode = 'NG',
    String errorMessage = 'Invalid phone number',
    bool formatInput = true,
    bool shouldValidateAndParse = true,
  }) {
    return InternationalPhoneNumberInput(
      onInputChange: onInputChange,
      inputBorder: inputBorder,
      hintText: hintText,
      initialCountry2LetterCode: initialCountry2LetterCode,
      errorMessage: errorMessage,
      formatInput: formatInput,
      shouldValidateAndParse: shouldValidateAndParse,
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
    CountryProvider provider = CountryProvider();
    List<Country> data =
        await provider.getCountriesDataFromJsonFile(context: context);
    setState(() {
      _countries = data;
      _selectedCountry = Utils.getInitialSelectedCountry(
          _countries, widget.initialCountry2LetterCode);
    });
  }

  void _phoneNumberControllerListener() {
    _isNotValid = false;
    String parsedPhoneNumberString =
        _controller.text.replaceAll(RegExp(r'([\(\1\)\1\s\-])'), '');

    if (widget.shouldValidateAndParse) {
      getParsedPhoneNumber(
              parsedPhoneNumberString, _selectedCountry.countryCode)
          .then((phoneNumber) {
        if (phoneNumber == null) {
          widget.onInputValidated(false);
          setState(() {
            _isNotValid = true;
          });
        } else {
          widget.onInputChange(phoneNumber);
          widget.onInputValidated(true);
          setState(() {
            _isNotValid = false;
          });
        }
      });
    } else {
      String phoneNumber =
          '${_selectedCountry.dialCode}$parsedPhoneNumberString';
      widget.onInputChange(phoneNumber);
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

  @override
  void initState() {
    _controller = TextEditingController();
    _controller.addListener(_phoneNumberControllerListener);
    _loadCountries(context);
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
              },
            ),
          ),
          Expanded(
            flex: 7,
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.phone,
              inputFormatters: _buildInputFormatter(),
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
                mainAxisAlignment: MainAxisAlignment.center,
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
