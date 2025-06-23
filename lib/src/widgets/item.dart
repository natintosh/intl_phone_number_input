import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/utils/util.dart';

/// [Item]
class Item extends StatelessWidget {
  final Country? country;
  final bool? showFlag;
  final bool? useEmoji;
  final TextStyle? textStyle;
  final bool withCountryNames;
  final double? leadingPadding;
  final bool trailingSpace;
  final BorderRadius? flagBorderRadius;
  final double emojiFlagSize;
  final double assetFlagWidth;
  final double? assetFlagHeight;

  const Item({
    Key? key,
    this.country,
    this.showFlag,
    this.useEmoji,
    this.textStyle,
    this.withCountryNames = false,
    this.leadingPadding = 12,
    this.trailingSpace = true,
    this.flagBorderRadius,
    this.emojiFlagSize = 24.0,
    this.assetFlagWidth = 32.0,
    this.assetFlagHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dialCode = (country?.dialCode ?? '');
    if (trailingSpace) {
      dialCode = dialCode.padRight(5, "   ");
    }
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(width: leadingPadding),
          _Flag(
            country: country,
            showFlag: showFlag,
            useEmoji: useEmoji,
            flagBorderRadius: flagBorderRadius,
            emojiFlagSize: emojiFlagSize,
            assetFlagWidth: assetFlagWidth,
            assetFlagHeight: assetFlagHeight,
          ),
          SizedBox(width: 12.0),
          Text(
            '$dialCode',
            textDirection: TextDirection.ltr,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}

class _Flag extends StatelessWidget {
  final Country? country;
  final bool? showFlag;
  final bool? useEmoji;
  final BorderRadius? flagBorderRadius;
  final double emojiFlagSize;
  final double assetFlagWidth;
  final double? assetFlagHeight;

  const _Flag({
    Key? key,
    this.country,
    this.showFlag,
    this.useEmoji,
    this.flagBorderRadius,
    this.emojiFlagSize = 24.0,
    this.assetFlagWidth = 32.0,
    this.assetFlagHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return country != null && showFlag!
        ? Container(
            child: useEmoji!
                ? Text(
                    Utils.generateFlagEmojiUnicode(country?.alpha2Code ?? ''),
                    style: TextStyle(fontSize: emojiFlagSize),
                  )
                : ClipRRect(
                    borderRadius: flagBorderRadius ?? BorderRadius.zero,
                    child: Image.asset(
                      country!.flagUri,
                      width: assetFlagWidth,
                      height: assetFlagHeight,
                      package: 'intl_phone_number_input',
                      errorBuilder: (context, error, stackTrace) {
                        return SizedBox.shrink();
                      },
                    ),
                  ),
          )
        : SizedBox.shrink();
  }
}
