import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/src/providers/country_provider.dart';
import 'package:intl_phone_number_input/src/providers/input_provider.dart';
import 'package:intl_phone_number_input/src/utils/formatter/as_you_type_formatter.dart';
import 'package:intl_phone_number_input/src/utils/phone_number.dart';
import 'package:intl_phone_number_input/src/utils/test/test_helper.dart';
import 'package:intl_phone_number_input/src/utils/util.dart';
import 'package:intl_phone_number_input/src/utils/widget_view.dart';
import 'package:intl_phone_number_input/src/widgets/selector_button.dart';
import 'package:libphonenumber/libphonenumber.dart';
import 'package:provider/provider.dart';

enum PhoneInputSelectorType { DROPDOWN, BOTTOM_SHEET, DIALOG }

typedef InputChanged<T> = void Function(T value);

class InternationalPhoneNumberInput extends StatelessWidget {
  final GlobalKey<_InputWidgetState> inputStateKey =
      GlobalKey<_InputWidgetState>();

  final PhoneInputSelectorType selectorType;

  final InputChanged<PhoneNumber> onInputChanged;
  final InputChanged<bool> onInputValidated;

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

  final TextStyle textStyle;
  final TextStyle selectorTextStyle;
  final InputBorder inputBorder;
  final InputDecoration inputDecoration;
  final InputDecoration searchBoxDecoration;

  final FocusNode focusNode;

  final List<String> countries;

  InternationalPhoneNumberInput(
      {Key key,
      this.selectorType,
      this.onInputChanged,
      this.onInputValidated,
      this.onSubmit,
      this.textFieldController,
      this.keyboardAction,
      this.initialValue,
      this.hintText,
      this.errorMessage,
      this.isEnabled,
      this.formatInput,
      this.autoFocus,
      this.autoValidate,
      this.ignoreBlank,
      this.countrySelectorScrollControlled,
      this.locale,
      this.textStyle,
      this.selectorTextStyle,
      this.inputBorder,
      this.inputDecoration,
      this.searchBoxDecoration,
      this.focusNode,
      this.countries})
      : super(key: key);

  factory InternationalPhoneNumberInput.withCustomDecoration({
    Key key,
    PhoneInputSelectorType selectorType,
    @required InputChanged<PhoneNumber> onInputChanged,
    InputChanged<bool> onInputValidated,
    FocusNode focusNode,
    TextEditingController textFieldController,
    VoidCallback onSubmit,
    TextInputAction keyboardAction,
    List<String> countries,
    TextStyle textStyle,
    TextStyle selectorTextStyle,
    String errorMessage,
    @required InputDecoration inputDecoration,
    InputDecoration searchBoxDecoration,
    PhoneNumber initialValue,
    bool isEnabled,
    bool formatInput,
    bool autoFocus,
    bool autoValidate,
    bool ignoreBlank,
    bool countrySelectorScrollControlled,
    String locale,
  }) {
    return InternationalPhoneNumberInput(
      key: key,
      selectorType: selectorType,
      onInputChanged: onInputChanged,
      onInputValidated: onInputValidated,
      focusNode: focusNode,
      textFieldController: textFieldController,
      onSubmit: onSubmit,
      keyboardAction: keyboardAction,
      countries: countries,
      textStyle: textStyle,
      selectorTextStyle: selectorTextStyle,
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
    Key key,
    PhoneInputSelectorType selectorType,
    @required InputChanged<PhoneNumber> onInputChanged,
    @required InputChanged<bool> onInputValidated,
    FocusNode focusNode,
    TextEditingController textFieldController,
    VoidCallback onSubmit,
    TextInputAction keyboardAction,
    List<String> countries,
    TextStyle textStyle,
    TextStyle selectorTextStyle,
    @required InputBorder inputBorder,
    @required String hintText,
    PhoneNumber initialValue,
    String errorMessage,
    bool isEnabled,
    bool formatInput,
    bool autoFocus,
    bool autoValidate,
    bool ignoreBlank,
    bool countrySelectorScrollControlled,
    String locale,
  }) {
    return InternationalPhoneNumberInput(
      key: key,
      selectorType: selectorType,
      onInputChanged: onInputChanged,
      onInputValidated: onInputValidated,
      focusNode: focusNode,
      textFieldController: textFieldController,
      onSubmit: onSubmit,
      keyboardAction: keyboardAction,
      countries: countries,
      textStyle: textStyle,
      selectorTextStyle: selectorTextStyle,
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
    return ChangeNotifierProvider<InputProvider>(
      key: ObjectKey(PhoneNumber),
      create: (BuildContext context) {
        return InputProvider();
      },
      child: _InputWidget(
        key: inputStateKey,
        selectorType: selectorType ?? PhoneInputSelectorType.DROPDOWN,
        onInputChanged: onInputChanged,
        onInputValidated: onInputValidated,
        onSubmit: onSubmit,
        textFieldController: textFieldController,
        focusNode: focusNode,
        keyboardAction: keyboardAction,
        initialValue: initialValue,
        hintText: hintText ?? 'Phone number',
        errorMessage: errorMessage ?? 'Invalid phone number',
        formatInput: formatInput ?? true,
        autoFocus: autoFocus ?? false,
        autoValidate: autoValidate ?? false,
        isEnabled: isEnabled ?? true,
        textStyle: textStyle,
        selectorTextStyle: selectorTextStyle,
        inputBorder: inputBorder,
        inputDecoration: inputDecoration,
        searchBoxDecoration: searchBoxDecoration,
        countries: countries,
        ignoreBlank: ignoreBlank ?? false,
        locale: locale,
        countrySelectorScrollControlled:
            countrySelectorScrollControlled ?? true,
      ),
    );
  }
}

class _InputWidget extends StatefulWidget {
  final PhoneInputSelectorType selectorType;

  final InputChanged<PhoneNumber> onInputChanged;
  final InputChanged<bool> onInputValidated;

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

  final TextStyle textStyle;
  final TextStyle selectorTextStyle;
  final InputBorder inputBorder;
  final InputDecoration inputDecoration;
  final InputDecoration searchBoxDecoration;

  final FocusNode focusNode;

  final List<String> countries;

  const _InputWidget(
      {Key key,
      this.selectorType,
      this.onInputChanged,
      this.onInputValidated,
      this.onSubmit,
      this.textFieldController,
      this.keyboardAction,
      this.initialValue,
      this.hintText,
      this.errorMessage,
      this.isEnabled,
      this.formatInput,
      this.autoFocus,
      this.autoValidate,
      this.ignoreBlank,
      this.countrySelectorScrollControlled,
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

class _InputWidgetState extends State<_InputWidget> with AutomaticKeepAliveClientMixin{
  TextEditingController controller;
  FocusNode focusNode;

  @override
  void initState() {
    Future.delayed(Duration.zero, () => loadCountries(context));
    focusNode = widget.focusNode ?? FocusNode();
    controller = widget.textFieldController ?? TextEditingController();
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
    super.build(context);
    return _InputWidgetView(
      state: this,
    );
  }

  void initialiseWidget() async {
    if (widget.initialValue != null) {
      if (widget.initialValue.phoneNumber != null &&
          widget.initialValue.phoneNumber.isNotEmpty) {
        controller.text =
            await PhoneNumber.getParsableNumber(widget.initialValue);

        phoneNumberControllerListener();
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      if (widget.autoFocus && !focusNode.hasFocus) {
        FocusScope.of(context).requestFocus(focusNode);
      }
    });
  }

  void loadCountries(BuildContext context) {
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

  void phoneNumberControllerListener() {
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
          widget.onInputChanged(PhoneNumber(
              phoneNumber: phoneNumber,
              isoCode: provider.country?.countryCode,
              dialCode: provider.country?.dialCode));
          if (widget.onInputValidated != null) {
            widget.onInputValidated(false);
          }
          provider.isNotValid = true;
        } else {
          widget.onInputChanged(PhoneNumber(
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

  Future<String> getParsedPhoneNumber(String phoneNumber, String iso) async {
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

  InputDecoration getInputDecoration(InputDecoration decoration) {
    return decoration ??
        InputDecoration(
          border: widget.inputBorder ?? UnderlineInputBorder(),
          hintText: widget.hintText,
        );
  }

  void onChanged(String value) {
    phoneNumberControllerListener();
  }

  String validator(String value) {
    InputProvider provider = Provider.of<InputProvider>(context, listen: false);
    return provider.isNotValid &&
            (value.isNotEmpty || widget.ignoreBlank == false)
        ? widget.errorMessage
        : null;
  }

  @override
  bool get wantKeepAlive => true;
}

class _InputWidgetView extends WidgetView<_InputWidget, _InputWidgetState> {
  final _InputWidgetState state;

  _InputWidgetView({Key key, @required this.state})
      : super(key: key, state: state);

  @override
  Widget build(BuildContext context) {
    final countryCode = context.select<InputProvider, String>(
        (value) => value?.country?.countryCode ?? '');
    final dialCode = context.select<InputProvider, String>(
        (value) => value?.country?.dialCode ?? '');
    return Container(
      child: Row(
        textDirection: TextDirection.ltr,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SelectorButton(
            selectorType: widget.selectorType,
            selectorTextStyle: widget.selectorTextStyle,
            searchBoxDecoration: widget.searchBoxDecoration,
            locale: widget.locale,
            phoneNumberControllerListener: state.phoneNumberControllerListener,
            isEnabled: widget.isEnabled,
            isScrollControlled: widget.countrySelectorScrollControlled,
          ),
          SizedBox(width: 12),
          Flexible(
            child: TextFormField(
              key: Key(TestHelper.TextInputKeyValue),
              textDirection: TextDirection.ltr,
              controller: state.controller,
              focusNode: state.focusNode,
              enabled: widget.isEnabled,
              keyboardType: TextInputType.phone,
              textInputAction: widget.keyboardAction,
              style: widget.textStyle,
              decoration: state.getInputDecoration(widget.inputDecoration),
              onEditingComplete: widget.onSubmit,
              autovalidate: widget.autoValidate,
              validator: state.validator,
              inputFormatters: [
                LengthLimitingTextInputFormatter(15),
                widget.formatInput
                    ? AsYouTypeFormatter(
                        isoCode: countryCode,
                        dialCode: dialCode,
                        onInputFormatted: (TextEditingValue value) {
                          state.controller.value = value;
                        },
                      )
                    : WhitelistingTextInputFormatter.digitsOnly,
              ],
              onChanged: state.onChanged,
            ),
          )
        ],
      ),
    );
  }
}
