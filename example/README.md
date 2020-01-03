```dart

import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(title: Text('Demo')),
          body: MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
//    getPhoneNumber('234 708 228 6079');
    return Form(
      key: formKey,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                print(number.phoneNumber);
              },
              isEnabled: true,
              autoValidate: true,
              formatInput: true,
            ),
            SizedBox(
              height: 20.0,
            ),
            InternationalPhoneNumberInput.withCustomBorder(
              onInputChanged: (PhoneNumber number) {
                print(number.phoneNumber);
              },
              isEnabled: true,
              autoValidate: true,
              formatInput: true,
              hintText: 'Invalid phone number',
              inputBorder: OutlineInputBorder(),
              onInputValidated: (bool value) {
                print(value);
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            InternationalPhoneNumberInput.withCustomDecoration(
              onInputChanged: (PhoneNumber number) {
                print(number.phoneNumber);
              },
              isEnabled: true,
              autoValidate: true,
              formatInput: true,
              inputDecoration: InputDecoration(border: UnderlineInputBorder()),
              onInputValidated: (bool value) {
                print(value);
              },
            ),
            RaisedButton(
              onPressed: () {
                formKey.currentState.validate();
              },
              child: Text('Validate'),
            )
          ],
        ),
      ),
    );
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber);
    String parsableNumber = number.parseNumber();

    print(parsableNumber);
  }
}

```