import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

/// Example demonstrating advanced features and API usage
void main() => runApp(AdvancedExampleApp());

class AdvancedExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Phone Number Features',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AdvancedExamplePage(),
    );
  }
}

class AdvancedExamplePage extends StatefulWidget {
  @override
  _AdvancedExamplePageState createState() => _AdvancedExamplePageState();
}

class _AdvancedExamplePageState extends State<AdvancedExamplePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advanced Features'),
        backgroundColor: Colors.teal,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'API Usage'),
            Tab(text: 'Controllers'),
            Tab(text: 'Callbacks'),
            Tab(text: 'Real-time'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ApiUsageTab(),
          ControllersTab(),
          CallbacksTab(),
          RealTimeTab(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

/// Tab demonstrating PhoneNumber API usage
class ApiUsageTab extends StatefulWidget {
  @override
  _ApiUsageTabState createState() => _ApiUsageTabState();
}

class _ApiUsageTabState extends State<ApiUsageTab> {
  final TextEditingController _phoneController = TextEditingController();
  PhoneNumber? _currentNumber;
  Map<String, dynamic> _apiResults = {};
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PhoneNumber API Methods',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
          ),
          SizedBox(height: 16),
          InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) {
              setState(() {
                _currentNumber = number;
              });
            },
            textFieldController: _phoneController,
            selectorConfig: SelectorConfig(
              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
            ),
            inputDecoration: InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed:
                      _currentNumber != null ? _analyzePhoneNumber : null,
                  child: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text('Analyze Number'),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: _getParsableNumber,
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: Text('Get Parsable'),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Analysis Results:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Expanded(
                      child: ListView(
                        children: _apiResults.entries.map((entry) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    '${entry.key}:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    entry.value.toString(),
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _analyzePhoneNumber() async {
    if (_currentNumber == null) return;

    setState(() {
      _isLoading = true;
      _apiResults.clear();
    });

    try {
      // Basic info
      _apiResults['Phone Number'] = _currentNumber!.phoneNumber ?? 'N/A';
      _apiResults['ISO Code'] = _currentNumber!.isoCode ?? 'N/A';
      _apiResults['Dial Code'] = _currentNumber!.dialCode ?? 'N/A';
      _apiResults['Hash'] = _currentNumber!.hash.toString();

      // Try to get parsable number
      try {
        String parsable = await PhoneNumber.getParsableNumber(_currentNumber!);
        _apiResults['Parsable Number'] = parsable;
      } catch (e) {
        _apiResults['Parsable Error'] = e.toString();
      }
    } catch (e) {
      _apiResults['Error'] = e.toString();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _getParsableNumber() async {
    if (_currentNumber == null) return;

    try {
      String parsable = await PhoneNumber.getParsableNumber(_currentNumber!);
      setState(() {
        _apiResults['Parsable Number'] = parsable;
      });
    } catch (e) {
      setState(() {
        _apiResults['Parsable Error'] = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}

/// Tab demonstrating controller usage
class ControllersTab extends StatefulWidget {
  @override
  _ControllersTabState createState() => _ControllersTabState();
}

class _ControllersTabState extends State<ControllersTab> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Controller Examples',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
          ),
          SizedBox(height: 16),

          // First phone input
          Text('Primary Phone:', style: TextStyle(fontWeight: FontWeight.w500)),
          SizedBox(height: 8),
          InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) {},
            textFieldController: _controller1,
            focusNode: _focusNode1,
            inputDecoration: InputDecoration(
              labelText: 'Primary Phone',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),

          // Second phone input
          Text('Secondary Phone:',
              style: TextStyle(fontWeight: FontWeight.w500)),
          SizedBox(height: 8),
          InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) {},
            textFieldController: _controller2,
            focusNode: _focusNode2,
            inputDecoration: InputDecoration(
              labelText: 'Secondary Phone',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 24),

          // Control buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: () {
                  _controller1.text = '5551234567';
                },
                child: Text('Set US Number'),
              ),
              ElevatedButton(
                onPressed: () {
                  _controller1.text = '442071234567';
                },
                child: Text('Set UK Number'),
              ),
              ElevatedButton(
                onPressed: () {
                  _controller1.clear();
                  _controller2.clear();
                },
                child: Text('Clear All'),
              ),
              ElevatedButton(
                onPressed: () {
                  _focusNode1.requestFocus();
                },
                child: Text('Focus Primary'),
              ),
              ElevatedButton(
                onPressed: () {
                  _focusNode2.requestFocus();
                },
                child: Text('Focus Secondary'),
              ),
            ],
          ),
          SizedBox(height: 24),

          // Display controller values
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Controller Values:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Primary: ${_controller1.text}'),
                  Text('Secondary: ${_controller2.text}'),
                  SizedBox(height: 8),
                  Text(
                    'Focus States:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Primary focused: ${_focusNode1.hasFocus}'),
                  Text('Secondary focused: ${_focusNode2.hasFocus}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    super.dispose();
  }
}

/// Tab demonstrating callback usage
class CallbacksTab extends StatefulWidget {
  @override
  _CallbacksTabState createState() => _CallbacksTabState();
}

class _CallbacksTabState extends State<CallbacksTab> {
  List<String> _eventLog = [];
  PhoneNumber? _lastNumber;
  bool _isValid = false;
  String? _savedNumber;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Callback Events',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
          ),
          SizedBox(height: 16),

          Form(
            child: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                setState(() {
                  _lastNumber = number;
                  _eventLog.insert(0, 'onInputChanged: ${number.phoneNumber}');
                  if (_eventLog.length > 10) _eventLog.removeLast();
                });
              },
              onInputValidated: (bool value) {
                setState(() {
                  _isValid = value;
                  _eventLog.insert(0, 'onInputValidated: $value');
                  if (_eventLog.length > 10) _eventLog.removeLast();
                });
              },
              onSaved: (PhoneNumber number) {
                setState(() {
                  _savedNumber = number.phoneNumber;
                  _eventLog.insert(0, 'onSaved: ${number.phoneNumber}');
                  if (_eventLog.length > 10) _eventLog.removeLast();
                });
              },
              onFieldSubmitted: (String value) {
                setState(() {
                  _eventLog.insert(0, 'onFieldSubmitted: $value');
                  if (_eventLog.length > 10) _eventLog.removeLast();
                });
              },
              validator: (String? value) {
                _eventLog.insert(0, 'validator called: $value');
                if (_eventLog.length > 10) _eventLog.removeLast();
                return null; // Always valid for demo
              },
              autoValidateMode: AutovalidateMode.onUserInteraction,
              inputDecoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                helperText: 'Type to see callback events',
              ),
            ),
          ),
          SizedBox(height: 16),

          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Form.of(context).save();
                },
                child: Text('Save Form'),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _eventLog.clear();
                  });
                },
                child: Text('Clear Log'),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Status indicators
          Row(
            children: [
              _buildStatusChip('Valid', _isValid, Colors.green),
              SizedBox(width: 8),
              _buildStatusChip('Has Number', _lastNumber != null, Colors.blue),
              SizedBox(width: 8),
              _buildStatusChip('Saved', _savedNumber != null, Colors.orange),
            ],
          ),
          SizedBox(height: 16),

          // Event log
          Expanded(
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Event Log (Most Recent First):',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _eventLog.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          dense: true,
                          leading: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.teal,
                            child: Text(
                              '${index + 1}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                          title: Text(
                            _eventLog[index],
                            style: TextStyle(fontSize: 12),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, bool isActive, Color color) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.grey[600],
          fontSize: 12,
        ),
      ),
      backgroundColor: isActive ? color : Colors.grey[200],
    );
  }
}

/// Tab demonstrating real-time features
class RealTimeTab extends StatefulWidget {
  @override
  _RealTimeTabState createState() => _RealTimeTabState();
}

class _RealTimeTabState extends State<RealTimeTab> {
  PhoneNumber? _currentNumber;
  bool _formatInput = true;
  bool _ignoreBlank = false;
  int _maxLength = 15;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Real-time Configuration',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
          ),
          SizedBox(height: 16),

          // Real-time configurable phone input
          InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) {
              setState(() {
                _currentNumber = number;
              });
            },
            formatInput: _formatInput,
            ignoreBlank: _ignoreBlank,
            maxLength: _maxLength,
            autoValidateMode: AutovalidateMode.onUserInteraction,
            inputDecoration: InputDecoration(
              labelText: 'Configurable Phone Input',
              border: OutlineInputBorder(),
              helperText: 'Adjust settings below to see changes',
            ),
          ),
          SizedBox(height: 24),

          // Configuration controls
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Configuration:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  SwitchListTile(
                    title: Text('Format Input'),
                    subtitle: Text('Enable as-you-type formatting'),
                    value: _formatInput,
                    onChanged: (value) {
                      setState(() {
                        _formatInput = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: Text('Ignore Blank'),
                    subtitle: Text('Don\'t validate empty input'),
                    value: _ignoreBlank,
                    onChanged: (value) {
                      setState(() {
                        _ignoreBlank = value;
                      });
                    },
                  ),
                  Row(
                    children: [
                      Text('Max Length: $_maxLength'),
                      Expanded(
                        child: Slider(
                          value: _maxLength.toDouble(),
                          min: 10,
                          max: 20,
                          divisions: 10,
                          label: _maxLength.toString(),
                          onChanged: (value) {
                            setState(() {
                              _maxLength = value.round();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),

          // Current state display
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current State:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text('Phone: ${_currentNumber?.phoneNumber ?? 'None'}'),
                  Text('Country: ${_currentNumber?.isoCode ?? 'None'}'),
                  Text('Dial Code: ${_currentNumber?.dialCode ?? 'None'}'),
                  Text('Format Input: $_formatInput'),
                  Text('Ignore Blank: $_ignoreBlank'),
                  Text('Max Length: $_maxLength'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
