import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/providers/country_provider.dart';
import 'package:intl_phone_number_input/src/providers/input_provider.dart';
import 'package:intl_phone_number_input/src/utils/formatter/as_you_type_formatter.dart';
import 'package:intl_phone_number_input/src/utils/phone_number.dart';
import 'package:intl_phone_number_input/src/utils/util.dart';
import 'package:libphonenumber/libphonenumber.dart';
import 'package:provider/provider.dart';

class InternationalPhoneNumberInput extends StatelessWidget {
  final ValueChanged<PhoneNumber> onInputChanged;
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
    @required ValueChanged<PhoneNumber> onInputChanged,
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
    @required ValueChanged<PhoneNumber> onInputChanged,
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
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return InputProvider();
      },
      child: _InputWidget(
        onInputChanged: onInputChanged,
        onInputValidated: onInputValidated,
        onSubmit: onSubmit,
        textFieldController: textFieldController,
        focusNode: focusNode,
        keyboardAction: keyboardAction,
        initialCountry2LetterCode: initialCountry2LetterCode,
        hintText: hintText,
        errorMessage: errorMessage,
        formatInput: formatInput,
        shouldParse: shouldParse,
        shouldValidate: shouldValidate,
        inputBorder: inputBorder,
        inputDecoration: inputDecoration,
        countries: countries,
      ),
    );
  }
}

class _InputWidget extends StatefulWidget {
  final ValueChanged<PhoneNumber> onInputChanged;
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

  const _InputWidget({
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

  @override
  State<StatefulWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<_InputWidget> {
  bool isNotValid = false;

  TextEditingController controller;

  _loadCountries(BuildContext context) async {
    InputProvider provider = Provider.of<InputProvider>(context);

    provider.countries = await CountryProvider.getCountriesDataFromJsonFile(
        context: context, countries: widget.countries);

    provider.country = Utils.getInitialSelectedCountry(
        provider.countries, widget.initialCountry2LetterCode);
  }

  void _phoneNumberControllerListener() {
    InputProvider provider = Provider.of<InputProvider>(context);
    isNotValid = false;
    String parsedPhoneNumberString =
        controller.text.replaceAll(RegExp(r'[^\d+]'), '');

    if (widget.shouldParse) {
      getParsedPhoneNumber(
              parsedPhoneNumberString, provider.country?.countryCode)
          .then((phoneNumber) {
        if (phoneNumber == null) {
          if (widget.onInputValidated != null) {
            widget.onInputValidated(false);
          }
          if (widget.shouldValidate) {
            setState(() {
              isNotValid = true;
            });
          }
        } else {
          widget.onInputChanged(new PhoneNumber(
              phoneNumber: phoneNumber,
              isoCode: provider.country?.countryCode,
              dialCode: provider.country?.dialCode));
          if (widget.onInputValidated != null) {
            widget.onInputValidated(true);
          }
          if (widget.shouldValidate) {
            setState(() {
              isNotValid = false;
            });
          }
        }
      });
    } else {
      String phoneNumber =
          '${provider.country.dialCode}$parsedPhoneNumberString';
      widget.onInputChanged(new PhoneNumber(
          phoneNumber: phoneNumber,
          isoCode: provider.country?.countryCode,
          dialCode: provider.country?.dialCode));
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

  @override
  void initState() {
    Future.delayed(Duration.zero, () => _loadCountries(context));
    controller = widget.textFieldController ?? TextEditingController();
    controller.addListener(_phoneNumberControllerListener);
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    InputProvider provider = Provider.of<InputProvider>(context);

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          DropdownButtonHideUnderline(
            child: DropdownButton<Country>(
              value: provider.country,
              items: _mapCountryToDropdownItem(provider.countries),
              onChanged: (value) {
                provider.country = value;
                _phoneNumberControllerListener();
              },
            ),
          ),
          Flexible(
            child: TextField(
              controller: controller,
              focusNode: widget.focusNode,
              keyboardType: TextInputType.phone,
              textInputAction: widget.keyboardAction,
              inputFormatters: [
                LengthLimitingTextInputFormatter(20),
                AsYouTypeFormatter(
                  isoCode: provider.country?.countryCode ?? '',
                  dialCode: provider.country?.dialCode ?? '',
                  onInputFormatted: (TextEditingValue value) {
                    setState(() {
                      controller.value = value;
                    });
                  },
                ),
              ],
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
          errorText: isNotValid ? widget.errorMessage : null,
        );
  }

  List<DropdownMenuItem<Country>> _mapCountryToDropdownItem(
      List<Country> countries) {
    return countries
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
}
