import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

/// Example demonstrating comprehensive form validation with phone number input
void main() => runApp(ValidationExampleApp());

class ValidationExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone Number Validation Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ValidationExamplePage(),
    );
  }
}

class ValidationExamplePage extends StatefulWidget {
  @override
  _ValidationExamplePageState createState() => _ValidationExamplePageState();
}

class _ValidationExamplePageState extends State<ValidationExamplePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  PhoneNumber? _phoneNumber;
  bool _isValidPhoneNumber = false;
  bool _isSubmitting = false;
  String? _submissionResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Validation Example'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'User Registration Form',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
              ),
              SizedBox(height: 24),

              // Name field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name *',
                  hintText: 'Enter your full name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  if (value.length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Email field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address *',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Phone number field with comprehensive validation
              InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  setState(() {
                    _phoneNumber = number;
                  });
                },
                onInputValidated: (bool value) {
                  setState(() {
                    _isValidPhoneNumber = value;
                  });
                },
                selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  setSelectorButtonAsPrefixIcon: true,
                  leadingPadding: 20,
                  trailingSpace: false,
                ),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                selectorTextStyle: TextStyle(color: Colors.black),
                textFieldController: _phoneController,
                formatInput: true,
                keyboardType: TextInputType.phone,
                inputDecoration: InputDecoration(
                  labelText: 'Phone Number *',
                  hintText: 'Enter your phone number',
                  border: OutlineInputBorder(),
                  helperText: 'We\'ll use this to verify your account',
                  helperStyle: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (!_isValidPhoneNumber) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
                onSaved: (PhoneNumber number) {
                  _phoneNumber = number;
                },
              ),
              SizedBox(height: 24),

              // Validation status indicator
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getValidationStatusColor().withValues(alpha: 0.1),
                  border: Border.all(color: _getValidationStatusColor()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getValidationStatusIcon(),
                      color: _getValidationStatusColor(),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getValidationStatusText(),
                        style: TextStyle(
                          color: _getValidationStatusColor(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Phone number details display
              if (_phoneNumber != null) ...[
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phone Number Details:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                          'Full Number: ${_phoneNumber!.phoneNumber ?? 'N/A'}'),
                      Text('Country Code: ${_phoneNumber!.isoCode ?? 'N/A'}'),
                      Text('Dial Code: ${_phoneNumber!.dialCode ?? 'N/A'}'),
                      Text('Valid: ${_isValidPhoneNumber ? 'Yes' : 'No'}'),
                    ],
                  ),
                ),
                SizedBox(height: 24),
              ],

              // Submit button
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isSubmitting
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Submitting...'),
                        ],
                      )
                    : Text(
                        'Submit Registration',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
              SizedBox(height: 16),

              // Clear button
              OutlinedButton(
                onPressed: _clearForm,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Clear Form'),
              ),

              // Submission result
              if (_submissionResult != null) ...[
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _submissionResult!,
                    style: TextStyle(color: Colors.green[800]),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getValidationStatusColor() {
    if (_phoneController.text.isEmpty) {
      return Colors.grey;
    }
    return _isValidPhoneNumber ? Colors.green : Colors.red;
  }

  IconData _getValidationStatusIcon() {
    if (_phoneController.text.isEmpty) {
      return Icons.info_outline;
    }
    return _isValidPhoneNumber
        ? Icons.check_circle_outline
        : Icons.error_outline;
  }

  String _getValidationStatusText() {
    if (_phoneController.text.isEmpty) {
      return 'Enter a phone number to validate';
    }
    return _isValidPhoneNumber
        ? 'Phone number is valid and ready to use'
        : 'Phone number format is invalid';
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fix the errors in the form'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isSubmitting = false;
      _submissionResult = '''Registration submitted successfully!
Name: ${_nameController.text}
Email: ${_emailController.text}
Phone: ${_phoneNumber?.phoneNumber}
Country: ${_phoneNumber?.isoCode}''';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Registration submitted successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    setState(() {
      _phoneNumber = null;
      _isValidPhoneNumber = false;
      _submissionResult = null;
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
