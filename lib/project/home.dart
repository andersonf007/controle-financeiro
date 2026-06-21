import 'package:controle_financeiro/project/classes/constants.dart';
import 'package:controle_financeiro/project/database_management/sqflite_services.dart';
import 'package:controle_financeiro/project/rate_app_manager.dart';  // ← ADICIONE ISSO
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io' show Platform;
import 'app_pages/analysis.dart';
import 'app_pages/input.dart';
import 'localization/methods.dart';
import 'app_pages/calendar.dart';
import 'app_pages/others.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  List<Widget> myBody = [AddInput(), Analysis(), Calendar(), Other()];
  
  BottomNavigationBarItem bottomNavigationBarItem(IconData iconData, String label) => BottomNavigationBarItem(
    icon: Padding(
      padding: EdgeInsets.only(bottom: 0.h),
      child: Icon(iconData),
    ),
    label: getTranslated(context, label),
  );

  @override
  void initState() {
    super.initState();
    DB.init();
    
    var rateAppManager = RateAppManager(  // ← MUDE AQUI
      minDays: 0,
      minLaunches: 1,
      remindDays: 4,
      remindLaunches: 15,
      googlePlayIdentifier: 'com.unifortesistemas.controlefinanceiro',
      appStoreIdentifier: '1582638369',
    );

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await rateAppManager.init();  // ← MUDE AQUI
      
      if (mounted && await rateAppManager.shouldShowDialog()) {  // ← MUDE AQUI
        rateAppManager.showRateDialog(  // ← MUDE AQUI
          context,
          listener: (button) {  // ← MUDE AQUI
            switch (button) {
              case RateDialogButton.rate:
                print('Clicked on "Rate".');
                break;
              case RateDialogButton.later:
                print('Clicked on "Later".');
                break;
              case RateDialogButton.no:
                print('Clicked on "No".');
                break;
            }
            return true;
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> bottomItems = <BottomNavigationBarItem>[
      bottomNavigationBarItem(Icons.add, 'Input'),
      bottomNavigationBarItem(Icons.analytics_outlined, 'Analysis'),
      bottomNavigationBarItem(Icons.calendar_today, 'Calendar'),
      bottomNavigationBarItem(Icons.account_circle, 'Other')
    ];

    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [BoxShadow(color: grey)]),
        child: BottomNavigationBar(
          iconSize: 27.sp,
          selectedFontSize: 16.sp,
          unselectedFontSize: 14.sp,
          backgroundColor: white,
          selectedItemColor: const Color.fromARGB(255, 255, 136, 0),
          unselectedItemColor: Colors.black87,
          type: BottomNavigationBarType.fixed,
          items: bottomItems,
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
      body: myBody[_selectedIndex],
    );
  }
}