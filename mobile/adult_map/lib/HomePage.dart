import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'MainPages/MapPage.dart';
import 'MainPages/StartPage.dart';
import 'MainPages/ProfilePage.dart';

class HomePage extends StatefulWidget {
  final FlutterSecureStorage storage;
  const HomePage({Key? key, required this.storage}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState(this.storage);
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static FlutterSecureStorage? storage;
  List<Widget> _widgetOptions = [];

  _HomePageState(FlutterSecureStorage temp_storage) {
    storage = temp_storage;
    _widgetOptions = <Widget>[
      StartPage(),
      MapPage(storage: storage!),
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: SafeArea(
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
        child: Container(
          height: 85,
          decoration: BoxDecoration(
            color: Color(0xFF0E0801),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 5),
            child: GNav(
              activeColor: Color(0xFF0E0801),
              iconSize: 32,
              haptic: true,
              tabBorderRadius: 20,
              padding: EdgeInsets.all(20),
              tabBackgroundColor: Color(0xFFEFA9AE),
              color: Color(0xFFEFA9AE),
              tabs: const [
                GButton(
                  icon: Icons.home,
                ),
                GButton(
                  icon: Icons.map,
                ),
                GButton(
                  icon: Icons.person,
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
