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
  final String hintText;
  final String titleText;
  final TextStyle? titleTextStyle;

  CountrySearchListWidget(
    this.countries,
    this.locale, {
    this.searchBoxDecoration,
    this.scrollController,
    this.showFlags,
    this.useEmoji,
    this.autoFocus = false,
    this.titleText = 'Choose Country',
    this.hintText = 'Search by country name or dial code',
    this.titleTextStyle,
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
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xff8D8D91),
          ),
          fillColor: Color(0xffF8F8F9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xffF8F8F9)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xffF8F8F9)),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.titleText,
                style: widget.titleTextStyle ??
                    TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              FloatingActionButton.small(
                onPressed: () {
                  Navigator.pop(context);
                },
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                child: Center(
                  child: Icon(Icons.close, color: Color(0xffC7C7CC), size: 20),
                ),
              ),
            ],
          ),
          TextFormField(
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
          Flexible(
            child: ListView.builder(
              controller: widget.scrollController,
              shrinkWrap: true,
              itemCount: filteredCountries.length,
              itemBuilder: (BuildContext context, int index) {
                Country country = filteredCountries[index];

                return DirectionalCountryRow(
                  country: country,
                  locale: widget.locale,
                  showFlags: widget.showFlags!,
                  useEmoji: widget.useEmoji!,
                );

                // return DirectionalCountryListTile(
                //   country: country,
                //   locale: widget.locale,
                //   showFlags: widget.showFlags!,
                //   useEmoji: widget.useEmoji!,
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

  const DirectionalCountryListTile({
    Key? key,
    required this.country,
    required this.locale,
    required this.showFlags,
    required this.useEmoji,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
      leading: (showFlags ? _Flag(country: country, useEmoji: useEmoji) : null),
      title: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          '${Utils.getCountryName(country, locale)}',
          textDirection: Directionality.of(context),
          textAlign: TextAlign.start,
        ),
      ),
      subtitle: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          '${country.dialCode ?? ''}',
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.start,
        ),
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

  const DirectionalCountryRow({
    Key? key,
    required this.country,
    required this.locale,
    required this.showFlags,
    required this.useEmoji,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(country),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            if (!showFlags) ...[
              Container(
                child: _Flag(country: country, useEmoji: useEmoji),
              ),
              const SizedBox(width: 16),
            ],
            SizedBox(
              width: 50,
              child: Text(
                '${country.dialCode ?? ''}',
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                '${Utils.getCountryName(country, locale)}',
                textDirection: Directionality.of(context),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
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
