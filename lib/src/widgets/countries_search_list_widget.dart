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

  CountrySearchListWidget(
    this.countries,
    this.locale, {
    this.searchBoxDecoration,
    this.scrollController,
    this.showFlags,
    this.useEmoji,
    this.autoFocus = false,
    required this.hintText,
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
          labelText: 'Choose Country ',
          labelStyle: TextStyle(
            color: Color(0xff8D8D91),
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'assets/fonts/istoria_regular.otf',
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            "Choose Country",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Color(0xff273443),
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: 'assets/fonts/istoria_regular.otf',
            ),
          ),

          // child: TextFormField(
          //   key: Key(TestHelper.CountrySearchInputKeyValue),
          //   decoration: getSearchBoxDecoration(),
          //   controller: _searchController,
          //   autofocus: widget.autoFocus,
          //   onChanged: (value) {
          //     final String value = _searchController.text.trim();
          //     return setState(
          //       () => filteredCountries = Utils.filterCountries(
          //         countries: widget.countries,
          //         locale: widget.locale,
          //         value: value,
          //       ),
          //     );
          //   },
          // ),
          TextFormField(
            key: Key(TestHelper.CountrySearchInputKeyValue),
            decoration: getSearchBoxDecoration(),
            controller: _searchController,
            autofocus: widget.autoFocus,
            // decoration: InputDecoration(
            //   hintText: widget.hintText,
            //   hintStyle: TextStyle(color: Color(0xff8D8D91)),
            //   filled: true,
            //   fillColor: Color(0xffF8F8F9),
            //   border: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(12.0),
            //     borderSide: BorderSide.none,
            //   ),
            //   contentPadding:
            //       EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            // ),
          ),

          Flexible(
            child: ListView.builder(
              controller: widget.scrollController,
              shrinkWrap: true,
              itemCount: filteredCountries.length,
              itemBuilder: (BuildContext context, int index) {
                Country country = filteredCountries[index];

                // return DirectionalCountryListTile(
                //   country: country,
                //   locale: widget.locale,
                //   showFlags: widget.showFlags!,
                //   useEmoji: widget.useEmoji!,
                // );
                return ListTile(
                  key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
                  // minLeadingWidth: 150,
                  leading: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${country.dialCode ?? ''}',
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Color(0xff8D8D91),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'assets/fonts/istoria_semibold.otf',
                        ),
                      ),
                      if (widget.showFlags!) ...[
                        SizedBox(width: 12),
                        _Flag(country: country, useEmoji: widget.useEmoji),
                      ],
                    ],
                  ),
                  title: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      '${Utils.getCountryName(country, widget.locale)}',
                      textDirection: Directionality.of(context),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Color(0xff101F29),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'assets/fonts/istoria_semibold.otf',
                      ),
                    ),
                  ),
                  // title: Align(
                  //   alignment: AlignmentDirectional.centerStart,
                  //   child: Text(
                  //     '${Utils.getCountryName(country, widget.locale)}',
                  //     textDirection: Directionality.of(context),
                  //     textAlign: TextAlign.start,
                  //   ),
                  // ),
                  // subtitle: Align(
                  //   alignment: AlignmentDirectional.centerStart,
                  //   child: Text(
                  //     '${country.dialCode ?? ''}',
                  //     textDirection: TextDirection.ltr,
                  //     textAlign: TextAlign.start,
                  //   ),
                  // ),
                  onTap: () => Navigator.of(context).pop(country),
                );
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
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(country),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
          children: [
            if (showFlags) _Flag(country: country, useEmoji: useEmoji),
            SizedBox(
              width: 100,
              child: Text(
                '${country.dialCode ?? ''}',
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color(0xff8D8D91),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'assets/fonts/istoria_semibold.otf',
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                '${Utils.getCountryName(country, locale)}',
                textDirection: Directionality.of(context),
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color(0xff101F29),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'assets/fonts/istoria_semibold.otf',
                ),
              ),
            ),
          ],
        ),
      ),
    );
    // return ListTile(
    //   key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
    //   leading: (showFlags ? _Flag(country: country, useEmoji: useEmoji) : null),
    //   title: Align(
    //     alignment: AlignmentDirectional.centerStart,
    //     child: Text(
    //       '${Utils.getCountryName(country, locale)}',
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
