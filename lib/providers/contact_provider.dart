import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FeedbackProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  Future<DocumentReference> submitContactForm(Map<String, dynamic> formData) async {
    return await _firestore.collection('contacts').add({
      ...formData,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> uploadImage(File image, String contactDocId, int index) async {
    _setUploading(true);
    try {
      final storageRef = _storage
          .ref()
          .child('contacts/$contactDocId/image_$index.jpg');
      await storageRef.putFile(image);
    } catch (e) {
      throw Exception('Image upload failed: $e');
    } finally {
      _setUploading(false);
    }
  }

  void _setUploading(bool value) {
    _isUploading = value;
    notifyListeners();
  }
}
