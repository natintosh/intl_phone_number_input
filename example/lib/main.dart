import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var darkTheme = ThemeData.dark().copyWith(primaryColor: Colors.blue);

    return MaterialApp(
      title: 'Demo',
      themeMode: ThemeMode.dark,
      darkTheme: darkTheme,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
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
  FocusNode _focusNode = FocusNode();

  String _userNameErrorText = 'Invalid Phone Number';

  @override
  Widget build(BuildContext context) {
    return DismissKeyboardOnTap(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InternationalPhoneNumberInput(
              focusNode: _focusNode,
              errorMessage: _userNameErrorText,
              onInputChanged: (PhoneNumber number) {
                // print(number.phoneNumber);
              },
              inputDecoration: InputDecoration(
                errorBorder: _focusNode.hasFocus
                    ? OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      )
                    : OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                errorStyle: _focusNode.hasFocus
                    ? TextStyle(fontSize: 0, height: 0)
                    : null,
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
              onInputValidated: (bool value) {},
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.CUSTOM,
                showFlags: false,
                setSelectorButtonAsPrefixIcon: true,
              ),
              onCustomSelectionWidget: (List<Country> countries) async {
                return await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CustomSearchScreen(countries: countries),
                  ),
                );
              },
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.disabled,
              selectorTextStyle: TextStyle(color: Colors.black),
              initialValue: number,
              textFieldController: controller,
              formatInput: false,
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              inputBorder: OutlineInputBorder(),
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

class CustomSearchScreen extends StatelessWidget {
  final List<Country> countries;
  const CustomSearchScreen({Key key, this.countries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('countries list'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.pop(context, countries[index]);
            },
            title: Text(
              '${countries[index].name} (${countries[index].dialCode})',
              style: TextStyle(color: Colors.black),
            ),
          );
        },
        itemCount: countries.length,
      ),
    );
  }
}

class DismissKeyboardOnTap extends StatelessWidget {
  const DismissKeyboardOnTap({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: child,
    );
  }
}
