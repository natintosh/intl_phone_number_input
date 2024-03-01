import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var darkTheme = ThemeData.dark().copyWith(primaryColor: Colors.blue);

    return MaterialApp(
      title: 'Demo',
      // themeMode: ThemeMode.dark,
      // darkTheme: darkTheme,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(title: Text('Demo')),
          body: MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'NG';
  PhoneNumber number = PhoneNumber(isoCode: 'NG');

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InternationalPhoneNumberInput(
             isShowSelectorArrow: false,
              onInputChanged: (PhoneNumber number) {
                print(number.phoneNumber);
              },
              onInputValidated: (bool value) {
                print(value);
              },
              showSeparator: true,
              separatorBorderSide: BorderSide(
                color: Colors.grey,
                width: 1
              ),
              selectorDecoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(left: Radius.circular(8))
              ),
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                leadingPadding: 4,
                showFlags: true,
              ),
              inputDecoration: InputDecoration(
                  hintText: 'Phone number',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                )
              ),
              ignoreBlank: false,
              spaceBetweenSelectorAndTextField: 0,
              autoValidateMode: AutovalidateMode.disabled,
              selectorTextStyle: TextStyle(color: Colors.black),
              initialValue: number,
              textFieldController: controller,
              formatInput: false,
              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
              onSaved: (PhoneNumber number) {
                print('On Saved: $number');
              },
            ),
            ElevatedButton(
              onPressed: () {
                formKey.currentState?.validate();
              },
              child: Text('Validate'),
            ),
            ElevatedButton(
              onPressed: () {
                getPhoneNumber('+15417543010');
              },
              child: Text('Update'),
            ),
            ElevatedButton(
              onPressed: () {
                formKey.currentState?.save();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

    setState(() {
      this.number = number;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
