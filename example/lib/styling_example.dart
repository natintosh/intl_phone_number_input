import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';

/// Example demonstrating different styling and customization options
void main() => runApp(StylingExampleApp());

class StylingExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone Number Styling Examples',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StylingExamplePage(),
    );
  }
}

class StylingExamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Styling Examples'),
        backgroundColor: Colors.purple,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'Phone Number Input Styling Examples',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
          ),
          SizedBox(height: 24),
          _buildExampleCard(
            context,
            'Basic Style',
            BasicStyleExample(),
          ),
          _buildExampleCard(
            context,
            'Material Design',
            MaterialDesignExample(),
          ),
          _buildExampleCard(
            context,
            'Custom Colors',
            CustomColorsExample(),
          ),
          _buildExampleCard(
            context,
            'Rounded Borders',
            RoundedBordersExample(),
          ),
          _buildExampleCard(
            context,
            'Prefix Icon Style',
            PrefixIconExample(),
          ),
          _buildExampleCard(
            context,
            'Emoji Flags',
            EmojiFlagsExample(),
          ),
          _buildExampleCard(
            context,
            'Country Filtering',
            CountryFilteringExample(),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(BuildContext context, String title, Widget example) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple[700],
              ),
            ),
            SizedBox(height: 16),
            example,
          ],
        ),
      ),
    );
  }
}

class BasicStyleExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      onInputChanged: (PhoneNumber number) {
        print('Basic: ${number.phoneNumber}');
      },
      selectorConfig: SelectorConfig(
        selectorType: PhoneInputSelectorType.DROPDOWN,
      ),
      ignoreBlank: false,
      autoValidateMode: AutovalidateMode.disabled,
      inputDecoration: InputDecoration(
        labelText: 'Phone Number',
        border: OutlineInputBorder(),
      ),
    );
  }
}

class MaterialDesignExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      onInputChanged: (PhoneNumber number) {
        print('Material: ${number.phoneNumber}');
      },
      selectorConfig: SelectorConfig(
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        setSelectorButtonAsPrefixIcon: true,
      ),
      ignoreBlank: false,
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      inputDecoration: InputDecoration(
        labelText: 'Phone Number',
        labelStyle: TextStyle(color: Colors.purple),
        hintText: 'Enter your phone number',
        filled: true,
        fillColor: Colors.purple[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.purple, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

class CustomColorsExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      onInputChanged: (PhoneNumber number) {
        print('Custom Colors: ${number.phoneNumber}');
      },
      selectorConfig: SelectorConfig(
        selectorType: PhoneInputSelectorType.DROPDOWN,
      ),
      textStyle: TextStyle(
        color: Colors.orange[800],
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      selectorTextStyle: TextStyle(
        color: Colors.orange[600],
        fontWeight: FontWeight.bold,
      ),
      cursorColor: Colors.orange,
      inputDecoration: InputDecoration(
        labelText: 'Phone Number',
        labelStyle: TextStyle(color: Colors.orange[700]),
        hintText: 'Custom styled input',
        hintStyle: TextStyle(color: Colors.orange[300]),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange[300]!, width: 1),
        ),
      ),
    );
  }
}

class RoundedBordersExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      onInputChanged: (PhoneNumber number) {
        print('Rounded: ${number.phoneNumber}');
      },
      selectorConfig: SelectorConfig(
        selectorType: PhoneInputSelectorType.DIALOG,
        leadingPadding: 20,
      ),
      textStyle: TextStyle(fontSize: 16),
      inputDecoration: InputDecoration(
        labelText: 'Phone Number',
        hintText: 'Rounded borders style',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }
}

class PrefixIconExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      onInputChanged: (PhoneNumber number) {
        print('Prefix Icon: ${number.phoneNumber}');
      },
      selectorConfig: SelectorConfig(
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        setSelectorButtonAsPrefixIcon: true,
        leadingPadding: 16,
        trailingSpace: false,
      ),
      inputDecoration: InputDecoration(
        labelText: 'Phone Number',
        hintText: 'Country selector as prefix',
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.phone, color: Colors.green),
      ),
    );
  }
}

class EmojiFlagsExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      onInputChanged: (PhoneNumber number) {
        print('Emoji Flags: ${number.phoneNumber}');
      },
      selectorConfig: SelectorConfig(
        selectorType: PhoneInputSelectorType.DROPDOWN,
        useEmoji: true,
        showFlags: true,
      ),
      inputDecoration: InputDecoration(
        labelText: 'Phone Number',
        hintText: 'Using emoji flags',
        border: OutlineInputBorder(),
        helperText: 'Flags are displayed as emojis',
      ),
    );
  }
}

class CountryFilteringExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      onInputChanged: (PhoneNumber number) {
        print('Filtered: ${number.phoneNumber}');
      },
      countries: ['US', 'CA', 'GB', 'AU'], // Only show these countries
      selectorConfig: SelectorConfig(
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        countryComparator: (Country a, Country b) => a.name!.compareTo(b.name!),
      ),
      inputDecoration: InputDecoration(
        labelText: 'Phone Number',
        hintText: 'Limited to US, CA, GB, AU',
        border: OutlineInputBorder(),
        helperText: 'Only shows selected countries',
        helperStyle: TextStyle(color: Colors.grey[600]),
      ),
    );
  }
}
