import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Intl Phone Number Input'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String phoneNumber = '';
  bool valid = false;

  void onPhoneNumberChanged(String phoneNumber) {
    print(phoneNumber);
    setState(() {
      this.phoneNumber = phoneNumber;
    });
  }

  void onInputChanged(bool value) {
    print(value);
    setState(() {
      valid = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Text(
                  'Default Constructor',
                  style: Theme.of(context)
                      .primaryTextTheme
                      .body1
                      .apply(fontSizeFactor: 1.5, color: Colors.black),
                ),
              ),
              InternationalPhoneNumberInput(
                onInputChange: onPhoneNumberChanged,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Text(
                  'Default Constructor with parsing set to false',
                  style: Theme.of(context)
                      .primaryTextTheme
                      .body1
                      .apply(fontSizeFactor: 1.5, color: Colors.black),
                ),
              ),
              InternationalPhoneNumberInput(
                onInputChange: onPhoneNumberChanged,
                shouldParse: false,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Text(
                  'Default Constructor with initialCountry set and hint text',
                  style: Theme.of(context)
                      .primaryTextTheme
                      .body1
                      .apply(fontSizeFactor: 1.5, color: Colors.black),
                ),
              ),
              InternationalPhoneNumberInput(
                onInputChange: onPhoneNumberChanged,
                shouldParse: true,
                shouldValidate: true,
                initialCountry2LetterCode: 'US',
                hintText: 'Insert phone number',
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Text(
                  'Custom Border ',
                  style: Theme.of(context)
                      .primaryTextTheme
                      .body1
                      .apply(fontSizeFactor: 1.5, color: Colors.black),
                ),
              ),
              InternationalPhoneNumberInput.withCustomBorder(
                onInputChange: onPhoneNumberChanged,
                inputBorder: OutlineInputBorder(),
                hintText: '(100) 123-4567 8901',
                initialCountry2LetterCode: 'US',
                errorMessage: 'Wrong number',
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Text(
                  'Custom Decoration without validation',
                  style: Theme.of(context)
                      .primaryTextTheme
                      .body1
                      .apply(fontSizeFactor: 1.5, color: Colors.black),
                ),
              ),
              InternationalPhoneNumberInput.withCustomDecoration(
                onInputChange: onPhoneNumberChanged,
                initialCountry2LetterCode: 'US',
                inputDecoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(40),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Text(
                  'Custom Decoration with validation',
                  style: Theme.of(context)
                      .primaryTextTheme
                      .body1
                      .apply(fontSizeFactor: 1.5, color: Colors.black),
                ),
              ),
              InternationalPhoneNumberInput.withCustomDecoration(
                onInputChange: onPhoneNumberChanged,
                onInputValidated: onInputChanged,
                initialCountry2LetterCode: 'US',
                inputDecoration: InputDecoration(
                  hintText: 'Enter phone number',
                  errorText: valid ? null : 'Invalid',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(40),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
