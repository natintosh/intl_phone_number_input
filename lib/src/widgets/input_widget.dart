import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/src/models/country_list.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/providers/country_provider.dart';
import 'package:intl_phone_number_input/src/utils/formatter/as_you_type_formatter.dart';
import 'package:intl_phone_number_input/src/utils/phone_number.dart';
import 'package:intl_phone_number_input/src/utils/phone_number/phone_number_util.dart';
import 'package:intl_phone_number_input/src/utils/selector_config.dart';
import 'package:intl_phone_number_input/src/utils/test/test_helper.dart';
import 'package:intl_phone_number_input/src/utils/util.dart';
import 'package:intl_phone_number_input/src/utils/widget_view.dart';
import 'package:intl_phone_number_input/src/widgets/selector_button.dart';

/// Enum for [SelectorButton] types.
///
/// Available type includes:
///   * [PhoneInputSelectorType.DROPDOWN]
///   * [PhoneInputSelectorType.BOTTOM_SHEET]
///   * [PhoneInputSelectorType.DIALOG]
enum PhoneInputSelectorType { DROPDOWN, BOTTOM_SHEET, DIALOG }

/// A customizable international phone number input widget for Flutter.
///
/// This widget provides a text field for phone number input with an integrated
/// country selector that supports multiple display modes (dropdown, bottom sheet, dialog).
/// It uses Google's libphonenumber for validation and formatting.
///
/// ## Features
/// * International phone number formatting as you type
/// * Country selection with flags (PNG or emoji)
/// * Multiple selector types: dropdown, bottom sheet, dialog
/// * Real-time validation
/// * RTL language support
/// * Highly customizable appearance
/// * Form integration with validation support
///
/// ## Basic Usage
/// ```dart
/// InternationalPhoneNumberInput(
///   onInputChanged: (PhoneNumber number) {
///     print(number.phoneNumber);
///   },
///   onInputValidated: (bool value) {
///     print('Is valid: $value');
///   },
///   selectorConfig: SelectorConfig(
///     selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
///   ),
///   ignoreBlank: false,
///   autoValidateMode: AutovalidateMode.disabled,
///   selectorTextStyle: TextStyle(color: Colors.black),
///   initialValue: PhoneNumber(isoCode: 'NG'),
///   textFieldController: myController,
///   formatInput: false,
///   keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
///   inputBorder: OutlineInputBorder(),
///   onSaved: (PhoneNumber number) {
///     print('On Saved: $number');
///   },
/// )
/// ```
///
/// ## Country Filtering
/// To limit available countries, provide a list of ISO codes:
/// ```dart
/// InternationalPhoneNumberInput(
///   countries: ['NG', 'US', 'GB', 'CA'],
///   // ... other parameters
/// )
/// ```
///
/// ## Validation
/// The widget provides built-in validation through [onInputValidated] callback.
/// For form integration, use the [validator] parameter:
/// ```dart
/// InternationalPhoneNumberInput(
///   validator: (String? value) {
///     if (value == null || value.isEmpty) {
///       return 'Please enter a phone number';
///     }
///     return null;
///   },
///   // ... other parameters
/// )
/// ```
///
/// See also:
/// * [SelectorConfig] for customizing the country selector appearance
/// * [PhoneNumber] for the data structure returned by callbacks
/// * [PhoneInputSelectorType] for available selector display modes
class InternationalPhoneNumberInput extends StatefulWidget {
  /// Configuration for the country selector button and popup.
  ///
  /// Controls the appearance and behavior of the country selector including
  /// display type (dropdown/bottom sheet/dialog), flags visibility, and styling.
  final SelectorConfig selectorConfig;

  /// Called whenever the phone number input changes.
  ///
  /// This callback is triggered on every keystroke and provides a [PhoneNumber]
  /// object containing the current phone number, dial code, and ISO country code.
  ///
  /// Example:
  /// ```dart
  /// onInputChanged: (PhoneNumber number) {
  ///   print('Phone: ${number.phoneNumber}');
  ///   print('Country: ${number.isoCode}');
  ///   print('Dial Code: ${number.dialCode}');
  /// },
  /// ```
  final ValueChanged<PhoneNumber>? onInputChanged;

  /// Called when the phone number validation status changes.
  ///
  /// Provides a boolean indicating whether the current phone number is valid
  /// according to international phone number standards.
  ///
  /// Example:
  /// ```dart
  /// onInputValidated: (bool isValid) {
  ///   setState(() {
  ///     _isValidNumber = isValid;
  ///   });
  /// },
  /// ```
  final ValueChanged<bool>? onInputValidated;

  /// Called when the user taps the submit button (if provided).
  ///
  /// This is typically triggered by keyboard actions like "done" or "submit".
  final VoidCallback? onSubmit;

  /// Called when the text field is submitted with the current text value.
  ///
  /// Similar to [TextFormField.onFieldSubmitted], provides the raw text
  /// from the input field when submitted.
  final ValueChanged<String>? onFieldSubmitted;

  /// Validator function for form integration.
  ///
  /// Should return null if the input is valid, or an error message string
  /// if validation fails. Used with [Form] widgets for validation.
  ///
  /// Example:
  /// ```dart
  /// validator: (String? value) {
  ///   if (value == null || value.isEmpty) {
  ///     return 'Phone number is required';
  ///   }
  ///   if (!isValidPhoneNumber(value)) {
  ///     return 'Please enter a valid phone number';
  ///   }
  ///   return null;
  /// },
  /// ```
  final String? Function(String?)? validator;

  /// Called when the form is saved with the current [PhoneNumber].
  ///
  /// Used with [Form.save()] for form data collection.
  final ValueChanged<PhoneNumber>? onSaved;

  /// Key for the internal text field widget.
  ///
  /// Useful for testing or when you need to directly reference the text field.
  final Key? fieldKey;

  /// Controller for the text field.
  ///
  /// If not provided, an internal controller will be created. Use this to
  /// programmatically control the text field content or to listen to changes.
  final TextEditingController? textFieldController;

  /// The type of keyboard to display for the text input.
  ///
  /// Defaults to [TextInputType.phone] which shows a numeric keypad
  /// optimized for phone number entry.
  final TextInputType keyboardType;

  /// The action button to display in the keyboard.
  ///
  /// Examples: [TextInputAction.done], [TextInputAction.next], etc.
  final TextInputAction? keyboardAction;

  /// Initial phone number to display in the widget.
  ///
  /// Should include both the phone number and the country ISO code.
  /// The widget will format and validate this number on initialization.
  ///
  /// Example:
  /// ```dart
  /// initialValue: PhoneNumber(
  ///   phoneNumber: '+1234567890',
  ///   isoCode: 'US',
  ///   dialCode: '+1',
  /// ),
  /// ```
  final PhoneNumber? initialValue;

  /// Placeholder text displayed when the input is empty.
  ///
  /// Defaults to 'Phone number'.
  final String? hintText;

  /// Error message displayed when validation fails.
  ///
  /// Defaults to 'Invalid phone number'.
  final String? errorMessage;

  /// Bottom padding for the selector button when an error is displayed.
  ///
  /// This helps align the selector button with the text field when
  /// error text causes the text field to shift down. Defaults to 24.0.
  final double selectorButtonOnErrorPadding;

  /// Horizontal spacing between selector button and text field.
  ///
  /// This is ignored when [SelectorConfig.setSelectorButtonAsPrefixIcon] is true.
  /// Defaults to 12.0.
  final double spaceBetweenSelectorAndTextField;

  /// Maximum number of characters allowed in the input.
  ///
  /// Defaults to 15. Set to null for no limit.
  final int maxLength;

  /// Whether the input field is enabled for user interaction.
  ///
  /// When false, the field appears greyed out and cannot be edited.
  /// Defaults to true.
  final bool isEnabled;

  /// Whether to format the input as the user types.
  ///
  /// When true, applies international formatting (spaces, dashes) as the user
  /// types. When false, only digits are allowed. Defaults to true.
  final bool formatInput;

  /// Whether the text field should automatically get focus when created.
  ///
  /// Defaults to false.
  final bool autoFocus;

  /// Whether the country search field should automatically get focus.
  ///
  /// Applies when the selector popup (bottom sheet/dialog) is opened.
  /// Defaults to false.
  final bool autoFocusSearch;

  /// When to perform validation automatically.
  ///
  /// See [AutovalidateMode] for available options. Defaults to
  /// [AutovalidateMode.disabled].
  final AutovalidateMode autoValidateMode;

  /// Whether to ignore validation when the input is blank.
  ///
  /// When true, empty input is considered valid. Defaults to false.
  final bool ignoreBlank;

  /// Whether the country selector popup should be scroll controlled.
  ///
  /// When true, the popup will control its own scrolling behavior.
  /// Defaults to true.
  final bool countrySelectorScrollControlled;

  /// Locale code for internationalization.
  ///
  /// Used for translating country names and other text elements.
  /// Should be a valid locale code like 'en', 'es', 'fr', etc.
  final String? locale;

  /// Text style for the phone number input field.
  ///
  /// If not provided, uses the theme's default text field style.
  final TextStyle? textStyle;

  /// Text style for the country selector button.
  ///
  /// Applied to the country code and flag text in the selector button.
  final TextStyle? selectorTextStyle;

  /// Border decoration for the input field.
  ///
  /// If not provided, uses the default [InputDecoration] border.
  final InputBorder? inputBorder;

  /// Full decoration for the input field.
  ///
  /// Allows complete customization of the text field appearance including
  /// hint text, labels, icons, borders, etc. Takes precedence over [inputBorder].
  final InputDecoration? inputDecoration;

  /// Decoration for the country search box in selector popups.
  ///
  /// Customizes the appearance of the search field in bottom sheet and dialog selectors.
  final InputDecoration? searchBoxDecoration;

  /// Color of the text field cursor.
  ///
  /// If not provided, uses the theme's default cursor color.
  final Color? cursorColor;

  /// Horizontal alignment of the text within the input field.
  ///
  /// Defaults to [TextAlign.start].
  final TextAlign textAlign;

  /// Vertical alignment of the text within the input field.
  ///
  /// Defaults to [TextAlignVertical.center].
  final TextAlignVertical textAlignVertical;

  /// Padding around the text field when scrolled into view.
  ///
  /// Defaults to [EdgeInsets.all(20.0)].
  final EdgeInsets scrollPadding;

  /// Focus node for the text field.
  ///
  /// Use this to programmatically control focus or listen to focus changes.
  final FocusNode? focusNode;

  /// Autofill hints for the input field.
  ///
  /// Helps password managers and autofill services understand the field purpose.
  /// Example: [AutofillHints.telephoneNumber].
  final Iterable<String>? autofillHints;

  /// List of country ISO codes to filter available countries.
  ///
  /// When provided, only countries with these ISO codes will be available
  /// for selection. Useful for restricting input to specific regions.
  ///
  /// Example:
  /// ```dart
  /// countries: ['US', 'CA', 'MX'], // North America only
  /// ```
  final List<String>? countries;
  final List<String>? prioritizedCountries;

  InternationalPhoneNumberInput(
      {Key? key,
      this.selectorConfig = const SelectorConfig(),
      required this.onInputChanged,
      this.onInputValidated,
      this.onSubmit,
      this.onFieldSubmitted,
      this.validator,
      this.onSaved,
      this.fieldKey,
      this.textFieldController,
      this.keyboardAction,
      this.keyboardType = TextInputType.phone,
      this.initialValue,
      this.hintText = 'Phone number',
      this.errorMessage = 'Invalid phone number',
      this.selectorButtonOnErrorPadding = 24,
      this.spaceBetweenSelectorAndTextField = 12,
      this.maxLength = 15,
      this.isEnabled = true,
      this.formatInput = true,
      this.autoFocus = false,
      this.autoFocusSearch = false,
      this.autoValidateMode = AutovalidateMode.disabled,
      this.ignoreBlank = false,
      this.countrySelectorScrollControlled = true,
      this.locale,
      this.textStyle,
      this.selectorTextStyle,
      this.inputBorder,
      this.inputDecoration,
      this.searchBoxDecoration,
      this.textAlign = TextAlign.start,
      this.textAlignVertical = TextAlignVertical.center,
      this.scrollPadding = const EdgeInsets.all(20.0),
      this.focusNode,
      this.cursorColor,
      this.autofillHints,
      this.countries,
      this.prioritizedCountries})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InternationalPhoneNumberInput> {
  TextEditingController? controller;
  double selectorButtonBottomPadding = 0;

  Country? country;
  List<Country> countries = [];
  bool isNotValid = true;

  @override
  void initState() {
    super.initState();
    loadCountries();
    controller = widget.textFieldController ?? TextEditingController();
    initialiseWidget();
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
    loadCountries(previouslySelectedCountry: country);
    super.didUpdateWidget(oldWidget);
  }

  /// [initialiseWidget] sets initial values of the widget
  void initialiseWidget() async {
    if (widget.initialValue != null) {
      if (widget.initialValue!.phoneNumber != null &&
          widget.initialValue!.phoneNumber!.isNotEmpty &&
          (await PhoneNumberUtil.isValidNumber(
              phoneNumber: widget.initialValue!.phoneNumber!,
              isoCode: widget.initialValue!.isoCode!))!) {
        String phoneNumber =
            await PhoneNumber.getParsableNumber(widget.initialValue!);

        controller!.text = widget.formatInput
            ? phoneNumber
            : phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

        phoneNumberControllerListener();
      }
    }
  }

  /// loads countries from [Countries.countryList] and selected Country
  void loadCountries({Country? previouslySelectedCountry}) {
    if (this.mounted) {
      List<Country> countries = CountryProvider.getCountriesData(
          countries: widget.countries,
          prioritizedCountries: widget.prioritizedCountries);

      Country country = previouslySelectedCountry ??
          Utils.getInitialSelectedCountry(
            countries,
            widget.initialValue?.isoCode ?? '',
          );

      // Remove potential duplicates
      countries = countries.toSet().toList();

      final CountryComparator? countryComparator =
          widget.selectorConfig.countryComparator;
      if (countryComparator != null) {
        countries.sort(countryComparator);
      }

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
      String parsedPhoneNumberString =
          controller!.text.replaceAll(RegExp(r'[^\d+]'), '');

      getParsedPhoneNumber(parsedPhoneNumberString, this.country?.alpha2Code)
          .then((phoneNumber) {
        if (phoneNumber == null) {
          String phoneNumber =
              '${this.country?.dialCode}$parsedPhoneNumberString';

          if (widget.onInputChanged != null) {
            widget.onInputChanged!(PhoneNumber(
                phoneNumber: phoneNumber,
                isoCode: this.country?.alpha2Code,
                dialCode: this.country?.dialCode));
          }

          if (widget.onInputValidated != null) {
            widget.onInputValidated!(false);
          }
          this.isNotValid = true;
        } else {
          if (widget.onInputChanged != null) {
            widget.onInputChanged!(PhoneNumber(
                phoneNumber: phoneNumber,
                isoCode: this.country?.alpha2Code,
                dialCode: this.country?.dialCode));
          }

          if (widget.onInputValidated != null) {
            widget.onInputValidated!(true);
          }
          this.isNotValid = false;
        }
      });
    }
  }

  /// Returns a formatted String of [phoneNumber] with [isoCode], returns `null`
  /// if [phoneNumber] is not valid or if an [Exception] is caught.
  Future<String?> getParsedPhoneNumber(
      String phoneNumber, String? isoCode) async {
    if (phoneNumber.isNotEmpty && isoCode != null) {
      try {
        bool? isValidPhoneNumber = await PhoneNumberUtil.isValidNumber(
            phoneNumber: phoneNumber, isoCode: isoCode);

        if (isValidPhoneNumber!) {
          return await PhoneNumberUtil.normalizePhoneNumber(
              phoneNumber: phoneNumber, isoCode: isoCode);
        }
      } on Exception {
        return null;
      }
    }
    return null;
  }

  /// Creates or Select [InputDecoration]
  InputDecoration getInputDecoration(InputDecoration? decoration) {
    InputDecoration value = decoration ??
        InputDecoration(
          border: widget.inputBorder ?? UnderlineInputBorder(),
          hintText: widget.hintText,
        );

    if (widget.selectorConfig.setSelectorButtonAsPrefixIcon) {
      return value.copyWith(
          prefixIcon: SelectorButton(
        country: country,
        countries: countries,
        onCountryChanged: onCountryChanged,
        selectorConfig: widget.selectorConfig,
        selectorTextStyle: widget.selectorTextStyle,
        searchBoxDecoration: widget.searchBoxDecoration,
        locale: locale,
        isEnabled: widget.isEnabled,
        autoFocusSearchField: widget.autoFocusSearch,
        isScrollControlled: widget.countrySelectorScrollControlled,
      ));
    }

    return value;
  }

  /// Validate the phone number when a change occurs
  void onChanged(String value) {
    phoneNumberControllerListener();
  }

  /// Validate and returns a validation error when [FormState] validate is called.
  ///
  /// Also updates [selectorButtonBottomPadding]
  String? validator(String? value) {
    bool isValid =
        this.isNotValid && (value!.isNotEmpty || widget.ignoreBlank == false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (isValid && widget.errorMessage != null) {
        setState(() {
          this.selectorButtonBottomPadding =
              widget.selectorButtonOnErrorPadding;
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
  void onCountryChanged(Country? country) {
    setState(() {
      this.country = country;
    });
    phoneNumberControllerListener();
  }

  void _phoneNumberSaved() {
    if (this.mounted) {
      String parsedPhoneNumberString =
          controller!.text.replaceAll(RegExp(r'[^\d+]'), '');

      String phoneNumber =
          '${this.country?.dialCode ?? ''}' + parsedPhoneNumberString;

      widget.onSaved?.call(
        PhoneNumber(
            phoneNumber: phoneNumber,
            isoCode: this.country?.alpha2Code,
            dialCode: this.country?.dialCode),
      );
    }
  }

  /// Saved the phone number when form is saved
  void onSaved(String? value) {
    _phoneNumberSaved();
  }

  /// Corrects duplicate locale
  String? get locale {
    if (widget.locale == null) return null;

    if (widget.locale!.toLowerCase() == 'nb' ||
        widget.locale!.toLowerCase() == 'nn') {
      return 'no';
    }
    return widget.locale;
  }
}

class _InputWidgetView
    extends WidgetView<InternationalPhoneNumberInput, _InputWidgetState> {
  final _InputWidgetState state;

  _InputWidgetView({Key? key, required this.state})
      : super(key: key, state: state);

  @override
  Widget build(BuildContext context) {
    final countryCode = state.country?.alpha2Code ?? '';
    final dialCode = state.country?.dialCode ?? '';

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (!widget.selectorConfig.setSelectorButtonAsPrefixIcon) ...[
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
                  locale: state.locale,
                  isEnabled: widget.isEnabled,
                  autoFocusSearchField: widget.autoFocusSearch,
                  isScrollControlled: widget.countrySelectorScrollControlled,
                ),
                SizedBox(
                  height: state.selectorButtonBottomPadding,
                ),
              ],
            ),
            SizedBox(width: widget.spaceBetweenSelectorAndTextField),
          ],
          Flexible(
            child: TextFormField(
              key: widget.fieldKey ?? Key(TestHelper.TextInputKeyValue),
              textDirection: TextDirection.ltr,
              controller: state.controller,
              cursorColor: widget.cursorColor,
              focusNode: widget.focusNode,
              enabled: widget.isEnabled,
              autofocus: widget.autoFocus,
              keyboardType: widget.keyboardType,
              textInputAction: widget.keyboardAction,
              style: widget.textStyle,
              decoration: state.getInputDecoration(widget.inputDecoration),
              textAlign: widget.textAlign,
              textAlignVertical: widget.textAlignVertical,
              onEditingComplete: widget.onSubmit,
              onFieldSubmitted: widget.onFieldSubmitted,
              autovalidateMode: widget.autoValidateMode,
              autofillHints: widget.autofillHints,
              validator: widget.validator ?? state.validator,
              onSaved: state.onSaved,
              scrollPadding: widget.scrollPadding,
              inputFormatters: [
                LengthLimitingTextInputFormatter(widget.maxLength),
                widget.formatInput
                    ? AsYouTypeFormatter(
                        isoCode: countryCode,
                        dialCode: dialCode,
                        onInputFormatted: (TextEditingValue value) {
                          state.controller!.value = value;
                        },
                      )
                    : FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: state.onChanged,
            ),
          )
        ],
      ),
    );
  }
}
