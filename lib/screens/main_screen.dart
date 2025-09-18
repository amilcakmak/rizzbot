import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:rizzbot/providers/locale_provider.dart';
import 'package:rizzbot/providers/theme_provider.dart';
import 'package:rizzbot/screens/home_screen.dart';
import 'package:rizzbot/screens/profile_screen.dart';
import 'package:rizzbot/screens/chat_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainScreen extends StatefulWidget {
  static const String routeName = '/main-screen';
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        elevation: 4,
        centerTitle: true,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: SpeedDial(
        icon: Icons.settings,
        activeIcon: Icons.close,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        buttonSize: const Size(56.0, 56.0),
        childrenButtonSize: const Size(60.0, 60.0),
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        direction: SpeedDialDirection.down,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.language),
            label: AppLocalizations.of(context)!.languageChange,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            onTap: () {
              final provider = Provider.of<LocaleProvider>(context, listen: false);
              if (provider.locale.languageCode == 'tr') {
                provider.setLocale(const Locale('en'));
              } else {
                provider.setLocale(const Locale('tr'));
              }
            },
          ),
          SpeedDialChild(
            child: Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) {
                return Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.wb_sunny : Icons.nightlight_round);
              },
            ),
            label: AppLocalizations.of(context)!.themeChange,
            backgroundColor: Colors.amber,
            foregroundColor: Colors.white,
            onTap: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.navHome,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat_bubble),
            label: AppLocalizations.of(context)!.navChat,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: AppLocalizations.of(context)!.navProfile,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
    );
  }
}
