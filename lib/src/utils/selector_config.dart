import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/widgets/input_widget.dart';

/// Function signature for comparing two countries for sorting purposes.
///
/// Takes two [Country] objects (A and B) and should return:
/// * -1 if A should come before B
/// * 0 if A and B are equal
/// * 1 if B should come before A
///
/// Example:
/// ```dart
/// CountryComparator alphabetical = (Country a, Country b) {
///   return a.name!.compareTo(b.name!);
/// };
/// ```
typedef CountryComparator = int Function(Country, Country);

/// Configuration class for customizing the country selector appearance and behavior.
///
/// This class contains all the options for configuring how the country selector
/// button and popup are displayed and behave in the [InternationalPhoneNumberInput] widget.
///
/// ## Example Usage
/// ```dart
/// SelectorConfig(
///   selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
///   showFlags: true,
///   useEmoji: false,
///   setSelectorButtonAsPrefixIcon: true,
///   leadingPadding: 16.0,
///   trailingSpace: true,
///   useBottomSheetSafeArea: true,
///   countryComparator: (Country a, Country b) {
///     return a.name!.compareTo(b.name!);
///   },
/// )
/// ```
class SelectorConfig {
  /// The type of selector interface to display.
  ///
  /// Available options:
  /// * [PhoneInputSelectorType.DROPDOWN] - Shows countries in a dropdown menu
  /// * [PhoneInputSelectorType.BOTTOM_SHEET] - Shows countries in a bottom sheet
  /// * [PhoneInputSelectorType.DIALOG] - Shows countries in a dialog popup
  ///
  /// Defaults to [PhoneInputSelectorType.DROPDOWN].
  final PhoneInputSelectorType selectorType;

  /// Whether to display country flags alongside country information.
  ///
  /// When true, shows flags next to country names and dial codes in both
  /// the selector button and the country list. When false, only text is shown.
  ///
  /// Defaults to true.
  final bool showFlags;

  /// Whether to use emoji flags instead of PNG image assets.
  ///
  /// When true, uses Unicode emoji flags (🇺🇸, 🇬🇧, etc.) instead of
  /// PNG flag images. Emoji flags are smaller and load faster but may
  /// not display consistently across all devices and platforms.
  ///
  /// Defaults to false (uses PNG assets).
  final bool useEmoji;

  /// Custom function for sorting the country list.
  ///
  /// When provided, countries will be sorted according to this comparator function.
  /// If null, countries are displayed in their default order (usually alphabetical).
  ///
  /// Example - Sort by dial code length:
  /// ```dart
  /// countryComparator: (Country a, Country b) {
  ///   return a.dialCode!.length.compareTo(b.dialCode!.length);
  /// }
  /// ```
  ///
  /// Defaults to null (no custom sorting).
  final CountryComparator? countryComparator;

  /// Whether to place the selector button inside the text field as a prefix icon.
  ///
  /// When true, the country selector appears as a prefix icon within the
  /// text field border. When false, it appears as a separate button next
  /// to the text field.
  ///
  /// Note: When true, [spaceBetweenSelectorAndTextField] is ignored.
  ///
  /// Defaults to false.
  final bool setSelectorButtonAsPrefixIcon;

  /// Additional padding space before the flag icon in the selector button.
  ///
  /// This adds extra spacing to the left of the flag icon, useful for
  /// fine-tuning the visual alignment of the selector button.
  ///
  /// If null, uses the default spacing. Measured in logical pixels.
  final double? leadingPadding;

  /// Whether to add trailing space for short dial codes.
  ///
  /// When true, adds extra spacing after short dial codes (like +1, +7)
  /// to maintain consistent button width regardless of dial code length.
  /// This helps prevent layout shifts when changing countries.
  ///
  /// Defaults to true.
  final bool trailingSpace;

  /// Whether to use safe area padding for bottom sheet selector.
  ///
  /// When true and [selectorType] is [PhoneInputSelectorType.BOTTOM_SHEET],
  /// the bottom sheet will respect the device's safe area (avoiding notches,
  /// home indicators, etc.).
  ///
  /// Only applies to bottom sheet selector type.
  ///
  /// Defaults to false.
  final bool useBottomSheetSafeArea;

  /// Creates a new [SelectorConfig] with the specified options.
  ///
  /// All parameters have sensible defaults and can be omitted if not needed.
  ///
  /// Example:
  /// ```dart
  /// // Basic configuration
  /// SelectorConfig()
  ///
  /// // Custom configuration
  /// SelectorConfig(
  ///   selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
  ///   showFlags: true,
  ///   useEmoji: false,
  ///   setSelectorButtonAsPrefixIcon: true,
  /// )
  /// ```
  const SelectorConfig({
    this.selectorType = PhoneInputSelectorType.DROPDOWN,
    this.showFlags = true,
    this.useEmoji = false,
    this.countryComparator,
    this.setSelectorButtonAsPrefixIcon = false,
    this.leadingPadding,
    this.trailingSpace = true,
    this.useBottomSheetSafeArea = false,
  });
}
