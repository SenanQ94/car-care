import 'package:flutter/material.dart';
import 'package:linexo_demo/pages/mehr/mehr_screen.dart';
import 'package:linexo_demo/pages/profile/profile_screen.dart';
import 'package:linexo_demo/pages/support/support_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import 'aufzeichen/aufzeichen_screen.dart';
import 'home/main_screen.dart';

class HomePage extends StatefulWidget {
  final int initialTab;

  const HomePage({super.key, this.initialTab = 0});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _currentTab;

  final List<Widget> _pages = [
    const MainScreen(),
    const SupportScreen(),
    const ProfileScreen(),
    const MehrScreen(),
  ];

  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final inactiveColor = theme.colorScheme.onBackground.withOpacity(0.7);
    final activeColor = theme.colorScheme.primary;

    return Scaffold(
      extendBody: true,
      body: PageStorage(
        bucket: _bucket,
        child: _pages[_currentTab],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AufzeichnenScreen(),
            ),
          );
        },
        backgroundColor: theme.colorScheme.background,
        shape: const CircleBorder(),
        child: Icon(Icons.speed_sharp, color: activeColor),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        surfaceTintColor: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        elevation: 12,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        color: theme.colorScheme.background,
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    shape: const CircleBorder(),
                    minWidth: 20,
                    onPressed: () {
                      setState(() {
                        _currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.home_outlined,
                          color: _currentTab == 0 ? activeColor : inactiveColor,
                        ),
                        Text(
                          'Home',
                          style: TextStyle(
                            color: _currentTab == 0 ? activeColor : inactiveColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    shape: const CircleBorder(),
                    minWidth: 20,
                    onPressed: () {
                      setState(() {
                        _currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.support_agent_outlined,
                          color: _currentTab == 1 ? activeColor : inactiveColor,
                        ),
                        Text(
                          'Support',
                          style: TextStyle(
                            color: _currentTab == 1 ? activeColor : inactiveColor,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  MaterialButton(
                    shape: const CircleBorder(),
                    minWidth: 20,
                    onPressed: () {
                      setState(() {
                        _currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.person_3_outlined,
                          color: _currentTab == 2 ? activeColor : inactiveColor,
                        ),
                        Text(
                          'Profile',
                          style: TextStyle(
                            color: _currentTab == 2 ? activeColor : inactiveColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    shape: const CircleBorder(),
                    minWidth: 20,
                    onPressed: () {
                      setState(() {
                        _currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.more_horiz_outlined,
                          color: _currentTab == 3 ? activeColor : inactiveColor,
                        ),
                        Text(
                          'More',
                          style: TextStyle(
                            color: _currentTab == 3 ? activeColor : inactiveColor,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
