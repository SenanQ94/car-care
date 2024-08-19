import 'package:flutter/material.dart';

final List<Map<String, String>> allgemeinQuestions = [
  {
    'question': 'Wann und wie kann ich meinen Komplettschutz kündigen?',
    'answer':
    'Die Laufzeit und Kündigungsfrist von deinem linexo Komplettschutz hängt individuell von deinem Vertrag ab. Diese Informationen entnimmst du daher bitte aus deinem Versicherungsschein. Darüber hinaus kannst du alle Informationen rund um deinen Vertrag in unserem Kundenportal einsehen.'
  },
  {
    'question': 'Warum werden meine Reparaturkosten nicht übernommen?',
    'answer':
    'Die Gründe hierfür können unterschiedlich sein. Bitte überprüfe die Bedingungen deines Vertrags.'
  },
  {
    'question': 'Wie kann ich meine persönlichen Daten ändern?',
    'answer':
    'Du kannst deine persönlichen Daten jederzeit über unser Kundenportal ändern. Logge dich einfach ein und gehe zu den Einstellungen.'
  },
  {
    'question': 'Was passiert, wenn ich mein Gerät verloren habe?',
    'answer':
    'Wenn du dein Gerät verloren hast, melde dies sofort unserem Support. Wir helfen dir, die nächsten Schritte einzuleiten.'
  },
  {
    'question': 'Wie erreiche ich den Kundensupport?',
    'answer':
    'Du kannst unseren Kundensupport über die Hotline, per E-Mail oder direkt über die App kontaktieren.'
  },
];

final List<Map<String, String>> appFunktionenQuestions = [
  {
    'question': 'Was beinhaltet der Pick-up-Service?',
    'answer':
    'Unser Pick-up-Service umfasst die Abholung, Reparatur und Rückgabe deines Geräts. Du kannst den Service bequem über unsere App buchen.'
  },
  {
    'question': 'Kann ich über die App einen Schaden oder Diebstahl melden?',
    'answer':
    'Ja, über die App kannst du Schäden oder Diebstahl schnell und einfach melden. Wähle einfach die entsprechende Option im Menü.'
  },
  {
    'question': 'Wie kann ich meine Versicherung in der App verwalten?',
    'answer':
    'In der App kannst du alle Details zu deiner Versicherung einsehen, deine Verträge verwalten und Schadensmeldungen vornehmen.'
  },
  {
    'question': 'Gibt es in der App eine Erinnerungsfunktion?',
    'answer':
    'Ja, die App bietet eine Erinnerungsfunktion für anstehende Zahlungen oder Vertragsverlängerungen.'
  },
  {
    'question': 'Kann ich mein Abo in der App kündigen?',
    'answer':
    'Ja, du kannst dein Abo direkt in der App unter den Abonnement-Einstellungen kündigen.'
  },
];

final List<Map<String, String>> schutzQuestions = [
  {
    'question': 'Was ist mein Vorteil beim Fahrradpass?',
    'answer':
    'Der Fahrradpass bietet dir einen umfassenden Schutz bei Diebstahl und Schäden. Alle wichtigen Informationen zu deinem Fahrrad sind darin gespeichert.'
  },
  {
    'question': 'Kann ich den Pick-up-Service auch ohne linexo Versicherung nutzen?',
    'answer':
    'Der Pick-up-Service ist exklusiv für linexo Versicherte verfügbar und bietet zusätzliche Sicherheit und Komfort.'
  },
  {
    'question': 'Welche Leistungen deckt der Komplettschutz ab?',
    'answer':
    'Der Komplettschutz deckt eine Vielzahl von Schäden ab, darunter Unfallschäden, Wasserschäden und Diebstahl.'
  },
  {
    'question': 'Wie melde ich einen Diebstahl?',
    'answer':
    'Einen Diebstahl kannst du über die App oder unsere Website melden. Stelle sicher, dass du alle notwendigen Informationen bereit hast.'
  },
  {
    'question': 'Gibt es eine Selbstbeteiligung bei der Schadensregulierung?',
    'answer':
    'Ja, abhängig von deinem Vertrag kann eine Selbstbeteiligung anfallen. Die genauen Konditionen findest du in deinen Vertragsunterlagen.'
  },
];

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final List<Map<String, dynamic>> categories = [
    {'title': 'Allgemein', 'questions': allgemeinQuestions},
    {'title': 'App-Funktionen', 'questions': appFunktionenQuestions},
    {'title': 'Schutz', 'questions': schutzQuestions},
  ];

  String searchQuery = '';

  List<Map<String, dynamic>> getFilteredCategories() {
    if (searchQuery.isEmpty) {
      return categories;
    }

    return categories.map((category) {
      final filteredQuestions = (category['questions'] as List<Map<String, String>>)
          .where((question) =>
          question['question']!.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();

      return {
        'title': category['title'],
        'questions': filteredQuestions,
      };
    }).where((category) => (category['questions'] as List<Map<String, String>>).isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCategories = getFilteredCategories();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Häufige Fragen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hilfe',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    onChanged: (query) {
                      setState(() {
                        searchQuery = query;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Wie können wir Ihnen helfen?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...filteredCategories.map((category) {
                    return CategoryWidget(
                      title: category['title'],
                      questions: category['questions'],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class CategoryWidget extends StatelessWidget {
  final String title;
  final List<Map<String, String>> questions;

  const CategoryWidget({super.key, required this.title, required this.questions});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      children: questions.map((question) {
        return QuestionWidget(question: question['question']!, answer: question['answer']!);
      }).toList(),
    );
  }
}

class QuestionWidget extends StatelessWidget {
  final String question;
  final String answer;

  const QuestionWidget({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(question),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    answer,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}