import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:linexo_demo/pages/mehr/videos_screen.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../providers/auth_service.dart';
import '../auth/auth_screen.dart';
import '../home_page.dart';
import '../sharedUI/ratgeber_screen.dart';
import '../widgets/my_card.dart';
import '../../helpers/app_localizations.dart';

class MehrScreen extends StatelessWidget {
  const MehrScreen({super.key});

  void _shareApp(BuildContext context) {
    Share.share(AppLocalizations.of(context).translate('share_app_message'));
  }

  void _showFeedbackBottomSheet(BuildContext context) {
    final feedbackController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).translate('feedback_title'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextField(
                  controller: feedbackController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).translate('feedback_hint'),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final authService = Provider.of<AuthService>(context, listen: false);
                    final user = await authService.user.first;

                    if (user != null) {
                      await FirebaseFirestore.instance.collection('feedback').add({
                        'userId': user.uid,
                        'userEmail': user.email,
                        'feedback': feedbackController.text,
                        'timestamp': FieldValue.serverTimestamp(),
                      });

                      Navigator.pop(context);
                    } else {
                      Fluttertoast.showToast(
                        msg: AppLocalizations.of(context).translate('error_user_not_logged_in'),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );

                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const AuthScreen()),
                      );
                    }
                  },
                  child: Text(AppLocalizations.of(context).translate('submit_button')),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPopUp(BuildContext context, String title, String desc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: Theme.of(context).textTheme.titleLarge),
          content: Text(desc, style: Theme.of(context).textTheme.bodyMedium),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context).translate('ok_button')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.translate('mehr_screen_title')),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: MyCard(
                    icon: Icons.directions_car_outlined,
                    text: localization.translate('advice_card'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RatgeberScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: MyCard(
                    icon: Icons.play_circle_outline_outlined,
                    text: localization.translate('videos_card'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  VideoScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Flexible(
                  child: MyCard(
                    icon: Icons.health_and_safety_outlined,
                    text: localization.translate('insurance_card'),
                    onTap: () {
                      //TODO Action or navigation
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Flexible(
                  child: MyCard(
                    icon: Icons.notifications_none,
                    text: localization.translate('notification_settings_card'),
                    onTap: () {
                      //TODO Action or navigation
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 32, thickness: 1),
            const SizedBox(height: 14),
            Row(
              children: [
                Flexible(
                  child: MyCard(
                    icon: Icons.feedback_outlined,
                    text: localization.translate('feedback_card'),
                    onTap: () {
                      _showFeedbackBottomSheet(context);
                    },
                  ),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: MyCard(
                    icon: Icons.thumb_up_alt_outlined,
                    text: localization.translate('recommend_app_card'),
                    onTap: () {
                      _shareApp(context);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Flexible(
                  child: MyCard(
                    icon: Icons.chat,
                    text: localization.translate('contact_app_team_card'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const HomePage(initialTab: 1),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Flexible(
                  child: MyCard(
                    icon: Icons.info_outline,
                    text: localization.translate('about_app_card'),
                    onTap: () {
                      _showPopUp(
                        context,
                        localization.translate('about_app_title'),
                        localization.translate('about_app_description'),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: MyCard(
                    icon: Icons.policy_outlined,
                    text: localization.translate('legal_card'),
                    onTap: () {
                      _showPopUp(
                        context,
                        localization.translate('legal_title'),
                        localization.translate('legal_description'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
