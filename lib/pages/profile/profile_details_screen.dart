import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../providers/auth_service.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  _ProfileDetailsScreenState createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKeyGeneral = GlobalKey<FormState>();
  final _formKeyAddress = GlobalKey<FormState>();
  final _formKeyPhone = GlobalKey<FormState>();

  final _generalData = <String, dynamic>{};
  final _addressData = <String, dynamic>{};
  final _phoneData = <String, dynamic>{};
  String _email = '';

  final TextEditingController _birthDateController = TextEditingController();

  String? _errorMessage;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchUserData();
  }

  @override
  void dispose() {
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      final userData = await authService.fetchUserData();
      if (userData != null) {
        setState(() {
          _generalData.addAll(userData['general'] ?? {});
          _addressData.addAll(userData['address'] ?? {});
          _phoneData.addAll(userData['phone'] ?? {});
          _birthDateController.text = _generalData['birthDate'] ?? '01/01/1990';
          _email = userData['email'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching user data.';
        _isLoading = false;
      });
    }
  }

  Future<void> _saveGeneralData() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    setState(() {
      _isSaving = true;
    });
    try {
      await authService.saveGeneralData(_generalData);
      await _fetchUserData();
      Fluttertoast.showToast(msg: 'General data saved successfully!', backgroundColor: Colors.green);
    } catch (e) {
      setState(() {
        _errorMessage = 'Error saving general data.';
      });
      Fluttertoast.showToast(msg: _errorMessage!, backgroundColor: Colors.red);
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  Future<void> _saveAddressData() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    setState(() {
      _isSaving = true;
    });
    try {
      await authService.saveAddressData(_addressData);
      await _fetchUserData();
      Fluttertoast.showToast(msg: 'Address data saved successfully!', backgroundColor: Colors.green);
    } catch (e) {
      setState(() {
        _errorMessage = 'Error saving address data.';
      });
      Fluttertoast.showToast(msg: _errorMessage!, backgroundColor: Colors.red);
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  Future<void> _savePhoneData() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    setState(() {
      _isSaving = true; // Start loading indicator
    });
    try {
      await authService.savePhoneData(_phoneData);
      await _fetchUserData();
      Fluttertoast.showToast(msg: 'Phone data saved successfully!', backgroundColor: Colors.green);
    } catch (e) {
      setState(() {
        _errorMessage = 'Error saving phone data.';
      });
      Fluttertoast.showToast(msg: _errorMessage!, backgroundColor: Colors.red);
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.appBarTheme.backgroundColor,
          elevation: 8,
          centerTitle: true,
          title: const Text('Persönliches'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.appBarTheme.backgroundColor,
          elevation: 8,
          centerTitle: true,
          title: const Text('Persönliches'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'ALLGEMEIN'),
              Tab(text: 'ADRESSE'),
              Tab(text: 'TELEFON'),
            ],
          ),
        ),
        body: Stack(
          children: [
            TabBarView(
              controller: _tabController,
              children: [
                _buildGeneralTab(),
                _buildAddressTab(),
                _buildPhoneTab(),
              ],
            ),
            if (_isSaving) // Show loading indicator when saving
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralTab() {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKeyGeneral,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              DropdownButtonFormField<String>(
                value: _generalData['salutation'] ?? 'Herr',
                items: ['Herr', 'Frau', 'Divers', 'Firma'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _generalData['salutation'] = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Anrede*',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _generalData['firstName'],
                decoration: const InputDecoration(
                  labelText: 'Vorname*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte geben Sie Ihren Vornamen ein.';
                  }
                  return null;
                },
                onChanged: (value) {
                  _generalData['firstName'] = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _generalData['lastName'],
                decoration: const InputDecoration(
                  labelText: 'Nachname*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte geben Sie Ihren Nachnamen ein.';
                  }
                  return null;
                },
                onChanged: (value) {
                  _generalData['lastName'] = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                enabled: false,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _birthDateController,
                decoration: InputDecoration(
                  labelText: 'Geburtsdatum*',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today, color: theme.primaryColor),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _birthDateController.text.isNotEmpty
                            ? DateTime.parse(_birthDateController.text.split('/').reversed.join('-'))
                            : DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _generalData['birthDate'] = "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
                          _birthDateController.text = _generalData['birthDate'];
                        });
                      }
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte wählen Sie Ihr Geburtsdatum aus.';
                  }
                  return null;
                },
                readOnly: true,
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKeyGeneral.currentState!.validate()) {
                      _saveGeneralData();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Speichern'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressTab() {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKeyAddress,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              TextFormField(
                initialValue: _addressData['street'],
                decoration: const InputDecoration(
                  labelText: 'Straße*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte geben Sie Ihre Straße ein.';
                  }
                  return null;
                },
                onChanged: (value) {
                  _addressData['street'] = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _addressData['houseNumber'],
                decoration: const InputDecoration(
                  labelText: 'Hausnummer*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte geben Sie Ihre Hausnummer ein.';
                  }
                  return null;
                },
                onChanged: (value) {
                  _addressData['houseNumber'] = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _addressData['additionalAddress'],
                decoration: const InputDecoration(
                  labelText: 'Adresszusatz',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _addressData['additionalAddress'] = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _addressData['postalCode'],
                decoration: const InputDecoration(
                  labelText: 'PLZ*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte geben Sie Ihre PLZ ein.';
                  }
                  return null;
                },
                onChanged: (value) {
                  _addressData['postalCode'] = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _addressData['city'],
                decoration: const InputDecoration(
                  labelText: 'Ort*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte geben Sie Ihre Stadt ein.';
                  }
                  return null;
                },
                onChanged: (value) {
                  _addressData['city'] = value;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _addressData['country'] ?? 'Deutschland',
                items: ['Deutschland', 'Österreich'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _addressData['country'] = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Land*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Bitte wählen Sie Ihr Land aus.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKeyAddress.currentState!.validate()) {
                      _saveAddressData();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Speichern'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneTab() {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKeyPhone,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              TextFormField(
                initialValue: _phoneData['landline'],
                decoration: const InputDecoration(
                  labelText: 'Festnetz',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  _phoneData['landline'] = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _phoneData['mobile'],
                decoration: const InputDecoration(
                  labelText: 'Mobil',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  _phoneData['mobile'] = value;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKeyPhone.currentState!.validate()) {
                      _savePhoneData();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Speichern'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
