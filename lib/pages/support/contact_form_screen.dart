import 'package:flutter/material.dart';
import 'package:linexo_demo/providers/contact_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../providers/auth_service.dart';
import '../../helpers/app_localizations.dart';
import '../widgets/image_picker_widget.dart';

class ContactFormScreen extends StatefulWidget {
  const ContactFormScreen({super.key});

  @override
  _ContactFormScreenState createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final List<File?> _selectedImages = List<File?>.filled(3, null);
  String? _selectedTopic;
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _phone = '';
  String _message = '';
  bool _agreedToTerms = false;
  bool _isLoading = true;

  final List<String> _topics = [
    'Versicherungstarif',
    'App',
    'Feedback',
    'Es geht um etwas anderes',
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      final userData = await authService.fetchUserData();
      if (userData != null) {
        final generalData = userData['general'] ?? {};
        final phoneData = userData['phone'] ?? {};

        setState(() {
          _firstName = generalData['firstName'] ?? '';
          _lastName = generalData['lastName'] ?? '';
          _email = userData['email'] ?? '';
          _phone = phoneData['mobile'] ?? '';
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      try {
        final contactService = Provider.of<FeedbackProvider>(context, listen: false);
        final contactDoc = await contactService.submitContactForm({
          'topic': _selectedTopic,
          'first_name': _firstName,
          'last_name': _lastName,
          'email': _email,
          'phone': _phone,
          'message': _message,
        });

        for (var i = 0; i < _selectedImages.length; i++) {
          if (_selectedImages[i] != null) {
            await contactService.uploadImage(_selectedImages[i]!, contactDoc.id, i);
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).translate('form_submission_success'))),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).translate('error_generic', {'error': e.toString()}))),
        );
      }
    }
  }

  Future<void> _pickImage(int index) async {
    if (index > 0 && _selectedImages[index - 1] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).translate('select_previous_image'))),
      );
      return;
    }

    final source = await _showImageSourceDialog();
    if (source != null) {
      final permissionStatus = source == ImageSource.camera
          ? await Permission.camera.request()
          : await Permission.photos.request();

      if (permissionStatus.isGranted) {
        final pickedFile = await _picker.pickImage(source: source);
        if (pickedFile != null) {
          setState(() {
            _selectedImages[index] = File(pickedFile.path);
          });
        }
      } else if (permissionStatus.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).translate('permission_denied'))),
        );
      } else if (permissionStatus.isPermanentlyDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).translate('permission_permanently_denied'))),
        );
        openAppSettings();
      }
    }
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    return await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate('select_image_source')),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.camera),
            label: Text(AppLocalizations.of(context).translate('camera')),
            onPressed: () {
              Navigator.of(context).pop(ImageSource.camera);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate('contact_form')),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Consumer<FeedbackProvider>(
      builder: (context, contactService, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).translate('contact_form')),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).translate('select_topic'),
                      border: const OutlineInputBorder(),
                    ),
                    items: _topics
                        .map((topic) => DropdownMenuItem(
                      value: topic,
                      child: Text(AppLocalizations.of(context).translate(topic)),
                    ))
                        .toList(),
                    onChanged: (value) => setState(() => _selectedTopic = value),
                    validator: (value) =>
                    value == null ? AppLocalizations.of(context).translate('select_topic_error') : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _firstName,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).translate('first_name'),
                      border: const OutlineInputBorder(),
                    ),
                    enabled: _firstName.isEmpty,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context).translate('first_name_error');
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _firstName = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _lastName,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).translate('last_name'),
                      border: const OutlineInputBorder(),
                    ),
                    enabled: _lastName.isEmpty,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context).translate('last_name_error');
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _lastName = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _email,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).translate('email'),
                      border: const OutlineInputBorder(),
                    ),
                    enabled: false,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).translate('phone'),
                      border: const OutlineInputBorder(),
                    ),
                    enabled: _phone.isEmpty,
                    keyboardType: TextInputType.phone,
                    initialValue: _phone.isEmpty ? null : _phone,
                    onChanged: (value) {
                      _phone = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).translate('message_hint'),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.fromLTRB(14, 16, 0, 0),
                    ),
                    maxLength: 800,
                    maxLines: 3,
                    initialValue: _message,
                    validator: (value) => value?.isEmpty ?? true
                        ? AppLocalizations.of(context).translate('message_error')
                        : null,
                    onChanged: (value) => _message = value,
                  ),
                  const SizedBox(height: 20),
                  ImagePickerWidget(
                    selectedImages: _selectedImages,
                    onPickImage: _pickImage,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: _agreedToTerms,
                        onChanged: (value) =>
                            setState(() => _agreedToTerms = value ?? false),
                      ),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context).translate('terms_agreement'),
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _agreedToTerms ? _submitForm : null,
                    child: contactService.isUploading
                        ? const CircularProgressIndicator()
                        : Text(AppLocalizations.of(context).translate('send_message')),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
