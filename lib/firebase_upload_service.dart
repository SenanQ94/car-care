import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart'; // For working with file paths
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;

final Map<String, List<Map<String, String>>> categoryArticles = {
  'Ausrüstung & Zubehör': [
    {
      'image': 'assets/images/equipment_1.jpg',
      'title': 'Die besten Helme für Fahrradtouren 2024',
    },
    {
      'image': 'assets/images/equipment_2.jpg',
      'title': 'Must-Have Zubehör für Ihr Fahrrad',
    },
    {
      'image': 'assets/images/equipment_1.jpg',
      'title': 'Die besten Helme für Fahrradtouren 2024',
    },
    {
      'image': 'assets/images/equipment_1.jpg',
      'title': 'Die besten Helme für Fahrradtouren 2024',
    },
    {
      'image': 'assets/images/equipment_1.jpg',
      'title': 'Die besten Helme für Fahrradtouren 2024',
    },
    {
      'image': 'assets/images/equipment_1.jpg',
      'title': 'Die besten Helme für Fahrradtouren 2024',
    },
  ],
  'E-Scooter': [
    {
      'image': 'assets/images/e_scooter_1.jpg',
      'title': 'E-Scooter Reichweite: Alle Modelle mit größter Reichweite im Test',
    },
    {
      'image': 'assets/images/e_scooter_2.jpg',
      'title': 'E-Scooter: Ein Beitrag zur Verkehrswende oder doch Großstad...',
    },
    {
      'image': 'assets/images/e_scooter_3.jpg',
      'title': 'Die besten E-Scooter mit Straßenzulassung 2023: Top-Modell...',
    },
    {
      'image': 'assets/images/e_scooter_2.jpg',
      'title': 'E-Scooter: Ein Beitrag zur Verkehrswende oder doch Großstad...',
    },
    {
      'image': 'assets/images/e_scooter_1.jpg',
      'title': 'E-Scooter Reichweite: Alle Modelle mit größter Reichweite im Test',
    },
  ],
  'Pflege & Wartung': [
    {
      'image': 'assets/images/maintenance_1.jpg',
      'title': 'Pflege-Tipps für ein langlebiges Fahrrad',
    },
    {
      'image': 'assets/images/maintenance_2.jpg',
      'title': 'Wartung: Wie Sie Ihren E-Scooter in Schuss halten',
    },
    {
      'image': 'assets/images/maintenance_1.jpg',
      'title': 'Pflege-Tipps für ein langlebiges Fahrrad',
    },
    {
      'image': 'assets/images/maintenance_1.jpg',
      'title': 'Pflege-Tipps für ein langlebiges Fahrrad',
    },
    {
      'image': 'assets/images/maintenance_2.jpg',
      'title': 'Wartung: Wie Sie Ihren E-Scooter in Schuss halten',
    },
  ],
  'Radrouten & Radtouren': [
    {
      'image': 'assets/images/routes_1.jpg',
      'title': 'Die schönsten Fahrradrouten in Deutschland',
    },
    {
      'image': 'assets/images/routes_2.jpg',
      'title': 'Radtouren entlang der Donau: Ein Abenteuer',
    },
    {
      'image': 'assets/images/routes_3.jpg',
      'title': 'Die Top 10 Radrouten Europas',
    },
    {
      'image': 'assets/images/routes_4.jpg',
      'title': 'Radfahren am Rhein: Sehenswürdigkeiten entdecken',
    },
    {
      'image': 'assets/images/routes_2.jpg',
      'title': 'Radtouren entlang der Donau: Ein Abenteuer',
    },
    {
      'image': 'assets/images/routes_1.jpg',
      'title': 'Die schönsten Fahrradrouten in Deutschland',
    },
    {
      'image': 'assets/images/routes_3.jpg',
      'title': 'Die Top 10 Radrouten Europas',
    },
  ],
  'Teile & Komponenten': [
    {
      'image': 'assets/images/parts_1.jpg',
      'title': 'Hochwertige Fahrradketten im Vergleich',
    },
    {
      'image': 'assets/images/parts_2.jpg',
      'title': 'Schaltungen: Worauf Sie beim Kauf achten sollten',
    },
    {
      'image': 'assets/images/parts_3.jpg',
      'title': 'Die besten Bremsbeläge für Fahrräder 2024',
    },
    {
      'image': 'assets/images/parts_1.jpg',
      'title': 'Hochwertige Fahrradketten im Vergleich',
    },
    {
      'image': 'assets/images/parts_4.jpg',
      'title': 'Fahrradreifen im Test: Welcher ist der Beste?',
    },
    {
      'image': 'assets/images/parts_2.jpg',
      'title': 'Schaltungen: Worauf Sie beim Kauf achten sollten',
    },
    {
      'image': 'assets/images/parts_3.jpg',
      'title': 'Die besten Bremsbeläge für Fahrräder 2024',
    },
  ],
};

Future<void> uploadCategoryArticlesToFirebase() async {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  for (var category in categoryArticles.entries) {
    final String categoryName = category.key;
    final List<Map<String, String>> articles = category.value;
    List<String> articleIDs = [];

    for (var article in articles) {
      final String imagePath = article['image']!;
      final String title = article['title']!;

      // Load image as ByteData from assets
      final ByteData imageData = await rootBundle.load(imagePath);

      // Convert ByteData to List<int>
      final Uint8List imageBytes = imageData.buffer.asUint8List();

      // Get the file name
      final String fileName = basename(imagePath);

      // Create a reference in Firebase Storage
      final Reference ref = storage.ref().child('images/$fileName');

      // Upload the image to Firebase Storage
      final UploadTask uploadTask = ref.putData(imageBytes);

      // Wait for the upload to complete and get the download URL
      final TaskSnapshot taskSnapshot = await uploadTask;
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // Store the article information directly under the category document
      final DocumentReference docRef = firestore.collection('categories').doc(categoryName);

      final articleRef = await docRef.collection(categoryName).add({
        'image': downloadUrl,
        'title': title,
      });

      // Save article ID for reference
      articleIDs.add(articleRef.id);
    }

    // Update the category document with the list of article IDs
    await firestore.collection('categories').doc(categoryName).set({
      'articles': articleIDs,
    });
  }

  print('All articles and images uploaded successfully!');
}
