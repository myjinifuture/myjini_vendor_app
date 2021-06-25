import 'dart:io';

import 'package:cuberto_bottom_bar/cuberto_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart' as cnst;
import 'package:smartsocietyadvertisement/Pages/Home.dart';
import 'package:smartsocietyadvertisement/Pages/Menu.dart';
import 'package:smartsocietyadvertisement/Pages/Product.dart';
import 'package:smartsocietyadvertisement/Pages/Profile.dart';
import 'package:smartsocietyadvertisement/Pages/More.dart';


class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  List tabs = [Home(),/*Product(), More(),*/Profile(), Menu()];
  List<String> title = [
    "Home",
    // "Product",
    "Profile",
    "Menu",
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold (
      bottomNavigationBar: CubertoBottomBar(
        inactiveIconColor: cnst.appPrimaryMaterialColor,
        tabStyle: CubertoTabStyle.STYLE_FADED_BACKGROUND, // By default its CubertoTabStyle.STYLE_NORMAL
        selectedTab: _currentIndex, // By default its 0, Current page which is fetched when a tab is clickd, should be set here so as the change the tabs, and the same can be done if willing to programmatically change the tab.
        tabs: [
          TabData(
            iconData: Icons.home,
            title: "Home",
            tabColor: cnst.appPrimaryMaterialColor,
          ),
          // TabData(
          //   iconData: Icons.add_circle_outline,
          //   title: "Product",
          //   tabColor: cnst.appPrimaryMaterialColor,
          // ),
          TabData(
              iconData: Icons.person,
              title: "Profile",
              tabColor: cnst.appPrimaryMaterialColor),
          TabData(
              iconData: Icons.menu,
              title: "Menu",
              tabColor: cnst.appPrimaryMaterialColor),
        ],
        onTabChangedListener: (position, title, color) {
          setState(() {
            _currentIndex = position;
            title = title;
          });
        },
      ),
      body: tabs[_currentIndex],
    );
  }
}
