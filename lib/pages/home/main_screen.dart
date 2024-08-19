import 'package:flutter/material.dart';
import 'package:linexo_demo/pages/sharedUI/guest_ui.dart';
import 'package:linexo_demo/pages/sharedUI/user_ui.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_service.dart';
import 'add_bike_card.dart';
import 'contents_view.dart';
import 'info_card.dart';
import 'service_card.dart';
import '../../helpers/app_localizations.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  void _navigateBasedOnRole(BuildContext context, String userRole) {
    if (userRole == 'user') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserUIPage()),
      );
    } else if (userRole == 'guest') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GuestUIPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return FutureBuilder<String?>(
      future: authService.fetchUserRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text('Error fetching user role')),
          );
        }

        final userRole = snapshot.data;
        final localization = AppLocalizations.of(context);

        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 100.0,
                  pinned: true,
                  floating: false,
                  snap: false,
                  automaticallyImplyLeading: false,
                  surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  flexibleSpace: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return FlexibleSpaceBar(
                        centerTitle: true,
                        titlePadding: const EdgeInsets.only(bottom: 4.0),
                        expandedTitleScale: 2,
                        title: Image.asset(
                          'assets/images/logo.png',
                          height: 30,
                        ),
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        AddBikeCard(
                          onPressed: () => _navigateBasedOnRole(context, userRole!),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ServiceCard(
                                title: localization.translate('service_card_1_title'),
                                subtitle: localization.translate('service_card_1_subtitle'),
                                icon: Icons.pedal_bike,
                                onTap: () => _navigateBasedOnRole(context, userRole!),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ServiceCard(
                                title: localization.translate('service_card_2_title'),
                                subtitle: localization.translate('service_card_2_subtitle'),
                                icon: Icons.local_shipping,
                                onTap: () => _navigateBasedOnRole(context, userRole!),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const ContentView(),
                        const SizedBox(height: 8),
                        InfoCard(
                          title: localization.translate('info_card_1_title'),
                          description: localization.translate('info_card_1_description'),
                          icon: Icons.assignment_turned_in_outlined,
                          onTap: () => _navigateBasedOnRole(context, userRole!),
                        ),
                        InfoCard(
                          title: localization.translate('info_card_2_title'),
                          description: localization.translate('info_card_2_description'),
                          icon: Icons.build_circle_outlined,
                          onTap: () => _navigateBasedOnRole(context, userRole!),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
