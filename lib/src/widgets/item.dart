import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';

class Item extends StatelessWidget {
  final Country country;
  final bool withCountryNames;
  final TextStyle textStyle;

  const Item(
      {Key key, this.country, this.withCountryNames = false, this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        textDirection: TextDirection.ltr,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          country?.flagUri != null
              ? Image.asset(
                  country?.flagUri,
                  width: 32.0,
                  package: 'intl_phone_number_input',
                )
              : SizedBox.shrink(),
          SizedBox(width: 12.0),
          Text(
            '${country?.dialCode ?? ''}',
            textDirection: TextDirection.ltr,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
