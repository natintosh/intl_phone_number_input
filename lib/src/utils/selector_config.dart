import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/widgets/input_widget.dart';

/// [CountryComparator] takes two countries: A and B.
///
/// Should return -1 if A precedes B, 0 if A is equal to B and 1 if B precedes A
typedef CountryComparator = int Function(Country, Country);

/// [SelectorConfig] contains selector button configurations
class SelectorConfig {
  /// [selectorType], for selector button type
  final PhoneInputSelectorType selectorType;

  /// [showFlags], displays flag along side countries info on selector button
  /// and list items within the selector
  final bool showFlags;

  /// [useEmoji], uses emoji flags instead of png assets
  final bool useEmoji;

  /// [countryComparator], sort the country list according to the comparator.
  ///
  /// Sorting is disabled by default
  final CountryComparator? countryComparator;

  /// [setSelectorButtonAsPrefixIcon], this sets/places the selector button inside the [TextField] as a prefixIcon.
  final bool setSelectorButtonAsPrefixIcon;

  /// Space before the flag icon
  final double? leadingPadding;

  /// Add white space for short dial code
  final bool trailingSpace;

  const SelectorConfig({
    this.selectorType = PhoneInputSelectorType.DROPDOWN,
    this.showFlags = true,
    this.useEmoji = false,
    this.countryComparator,
    this.setSelectorButtonAsPrefixIcon = false,
    this.leadingPadding,
    this.trailingSpace = true,
  });
}
