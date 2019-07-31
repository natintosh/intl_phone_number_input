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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  String phoneNumber;
  bool valid = false;

  void onPhoneNumberChanged(String phoneNumber) {
    setState(() {
      this.phoneNumber = phoneNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Text('International Default Constructor'),
            ),
            InternationalPhoneNumberInput(
              onInputChange: onPhoneNumberChanged,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Text('International Default Constructor'),
            ),
            InternationalPhoneNumberInput(
              onInputChange: onPhoneNumberChanged,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Text('International Default Constructor'),
            ),
            InternationalPhoneNumberInput(
              onInputChange: onPhoneNumberChanged,
            ),
          ],
        ),
      ),
    );
  }
}
