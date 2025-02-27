import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/utils/test/test_helper.dart';
import 'package:intl_phone_number_input/src/utils/util.dart';

/// Creates a list of Countries with a search textfield.
class CountrySearchListWidget extends StatefulWidget {
  final List<Country> countries;
  final InputDecoration? searchBoxDecoration;
  final String? locale;
  final ScrollController? scrollController;
  final bool autoFocus;
  final bool? showFlags;
  final bool? useEmoji;
  final TextStyle? dialCodeTextStyle;
  final TextStyle? countryNameTextStyle;
  final TextStyle? titleTextStyle;
  final TextStyle? labelStyle;
  final String title;
  final String labelText;
  final Color? searchBarFillColor;

  CountrySearchListWidget(
    this.countries,
    this.locale, {
    this.searchBoxDecoration,
    this.scrollController,
    this.showFlags,
    this.useEmoji,
    this.autoFocus = false,
    this.dialCodeTextStyle,
    this.countryNameTextStyle,
    this.titleTextStyle,
    this.labelStyle,
    this.title = '',
    this.labelText = '',
    this.searchBarFillColor,
  });

  @override
  _CountrySearchListWidgetState createState() =>
      _CountrySearchListWidgetState();
}

class _CountrySearchListWidgetState extends State<CountrySearchListWidget> {
  late TextEditingController _searchController = TextEditingController();
  late List<Country> filteredCountries;

  @override
  void initState() {
    final String value = _searchController.text.trim();
    filteredCountries = Utils.filterCountries(
      countries: widget.countries,
      locale: widget.locale,
      value: value,
    );
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Returns [InputDecoration] of the search box
  InputDecoration getSearchBoxDecoration() {
    return widget.searchBoxDecoration ??
        InputDecoration(
          labelText: widget.labelText,
          labelStyle: widget.labelStyle ??
              TextStyle(
                color: Color(0xff8D8D91),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          // fillColor: Color(0xFFF8F8F9),
          fillColor: widget.searchBarFillColor ?? Color(0xffF8F8F9),
          hintStyle:
              TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: widget.titleTextStyle ??
                    TextStyle(
                      color: Color(0xff273443),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SizedBox(
                  height: 32,
                  width: 32,
                  child: Center(
                    child: Icon(Icons.close_rounded,
                        size: 22, color: Color(0xffC7C7CC)),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              key: Key(TestHelper.CountrySearchInputKeyValue),
              decoration: getSearchBoxDecoration(),
              controller: _searchController,
              autofocus: widget.autoFocus,
              onChanged: (value) {
                final String value = _searchController.text.trim();
                return setState(
                  () => filteredCountries = Utils.filterCountries(
                    countries: widget.countries,
                    locale: widget.locale,
                    value: value,
                  ),
                );
              },
            ),
          ),
          Flexible(
            child: ListView.builder(
              controller: widget.scrollController,
              shrinkWrap: true,
              itemCount: filteredCountries.length,
              itemBuilder: (BuildContext context, int index) {
                Country country = filteredCountries[index];

                // return DirectionalCountryRow(
                //   country: country,
                //   locale: widget.locale,
                //   showFlags: widget.showFlags!,
                //   useEmoji: widget.useEmoji!,
                //   countryNameTextStyle: widget.countryNameTextStyle,
                //   dialCodeTextStyle: widget.dialCodeTextStyle,
                // );
                return DirectionalCountryListTile(
                  country: country,
                  locale: widget.locale,
                  showFlags: widget.showFlags!,
                  useEmoji: widget.useEmoji!,
                  dialCodeTextStyle: widget.dialCodeTextStyle,
                  countryNameTextStyle: widget.countryNameTextStyle,
                );
                // return ListTile(
                //   key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
                //   leading: widget.showFlags!
                //       ? _Flag(country: country, useEmoji: widget.useEmoji)
                //       : null,
                //   title: Align(
                //     alignment: AlignmentDirectional.centerStart,
                //     child: Text(
                //       '${Utils.getCountryName(country, widget.locale)}',
                //       textDirection: Directionality.of(context),
                //       textAlign: TextAlign.start,
                //     ),
                //   ),
                //   subtitle: Align(
                //     alignment: AlignmentDirectional.centerStart,
                //     child: Text(
                //       '${country.dialCode ?? ''}',
                //       textDirection: TextDirection.ltr,
                //       textAlign: TextAlign.start,
                //     ),
                //   ),
                //   onTap: () => Navigator.of(context).pop(country),
                // );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

class DirectionalCountryListTile extends StatelessWidget {
  final Country country;
  final String? locale;
  final bool showFlags;
  final bool useEmoji;
  final TextStyle? dialCodeTextStyle;
  final TextStyle? countryNameTextStyle;

  const DirectionalCountryListTile({
    Key? key,
    required this.country,
    required this.locale,
    required this.showFlags,
    required this.useEmoji,
    this.dialCodeTextStyle,
    this.countryNameTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
      // leading: (showFlags ? _Flag(country: country, useEmoji: useEmoji) : null),
      title: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              '${country.dialCode ?? ''}',
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.start,
              style: dialCodeTextStyle ??
                  TextStyle(
                    color: Color(0xff8D8D91),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              '${Utils.getCountryName(country, locale)}',
              textDirection: Directionality.of(context),
              textAlign: TextAlign.start,
              style: countryNameTextStyle ??
                  TextStyle(
                    color: Color(0xff101F29),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
      onTap: () => Navigator.of(context).pop(country),
    );
  }
}

class DirectionalCountryRow extends StatelessWidget {
  final Country country;
  final String? locale;
  final bool showFlags;
  final bool useEmoji;
  final TextStyle? dialCodeTextStyle;
  final TextStyle? countryNameTextStyle;

  const DirectionalCountryRow({
    Key? key,
    required this.country,
    required this.locale,
    required this.showFlags,
    required this.useEmoji,
    this.dialCodeTextStyle,
    this.countryNameTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
        children: [
          if (showFlags) ...[
            Center(
              child: _Flag(country: country, useEmoji: useEmoji),
            ),
            SizedBox(width: 16),
          ],
          SizedBox(
            width: 80,
            child: Text(
              '${country.dialCode ?? ''}',
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.start,
              style: dialCodeTextStyle,
            ),
          ),
          Expanded(
            child: Text(
              '${Utils.getCountryName(country, locale)}',
              textDirection: Directionality.of(context),
              textAlign: TextAlign.start,
              style: countryNameTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class _Flag extends StatelessWidget {
  final Country? country;
  final bool? useEmoji;

  const _Flag({Key? key, this.country, this.useEmoji}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return country != null
        ? Container(
            child: useEmoji!
                ? Text(
                    Utils.generateFlagEmojiUnicode(country?.alpha2Code ?? ''),
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
                : country?.flagUri != null
                    ? CircleAvatar(
                        backgroundImage: AssetImage(
                          country!.flagUri,
                          package: 'intl_phone_number_input',
                        ),
                      )
                    : SizedBox.shrink(),
          )
        : SizedBox.shrink();
  }
}
