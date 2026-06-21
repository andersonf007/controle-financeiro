import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:controle_financeiro/project/classes/category_item.dart';
import 'package:controle_financeiro/project/classes/constants.dart';
import 'package:controle_financeiro/project/localization/methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';
// ignore: import_of_legacy_library_into_null_safe
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefs = SharedPrefs();
// constants/strings.dart
// const String appCurrency = 'app_currency';
late String currency;
var incomeItems = sharedPrefs.getItems('income items');

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

  sharePrefsInit() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }

    String get selectedDate => _sharedPrefs!.getString('selectedDate')!;


  set selectedDate(String value) {
    _sharedPrefs!.setString('selectedDate', value);
  }

  String get appCurrency => _sharedPrefs!.getString('appCurrency') ?? Platform.localeName;

  set appCurrency(String appCurrency) => _sharedPrefs!.setString('appCurrency', appCurrency);

  String get dateFormat => _sharedPrefs!.getString('dateFormat') ?? 'dd/MM/yyyy';

  set dateFormat(String dateFormat) => _sharedPrefs!.setString('dateFormat', dateFormat);

  bool get isPasscodeOn => _sharedPrefs!.getBool('isPasscodeOn') ?? false;

  set isPasscodeOn(bool value) => _sharedPrefs!.setBool('isPasscodeOn', value);

  String get passcodeScreenLock => _sharedPrefs!.getString('passcodeScreenLock')!;

  set passcodeScreenLock(String value) => _sharedPrefs!.setString('passcodeScreenLock', value);

  List<String> get parentExpenseItemNames => _sharedPrefs!.getStringList('parent expense item names')!;

  // not yet use this set method
  set parentExpenseItemNames(List<String> parentExpenseItemNames) => _sharedPrefs!.setStringList('parent expense item names', parentExpenseItemNames);

  Locale setLocale(String languageCode) {
    _sharedPrefs!.setString('languageCode', languageCode);
    return locale(languageCode);
  }

  Locale getLocale() {
    String languageCode = _sharedPrefs!.getString('languageCode') ?? "en";
    return locale(languageCode);
  }

  void getCurrency() {
    if (_sharedPrefs!.containsKey('appCurrency')) {
      var format = NumberFormat.simpleCurrency(locale: sharedPrefs.appCurrency);
      currency = format.currencySymbol;
    } else {
      var format = NumberFormat.simpleCurrency(locale: Platform.localeName);
      currency = format.currencySymbol;
    }
  }

  //jsonEncode turns a Map<String, dynamic> into a json string,
  //jsonDecode turns a json string into a Map<String, dynamic>
  List<CategoryItem> getItems(String parentItemName) {
    List<String> itemsEncoded = _sharedPrefs!.getStringList(parentItemName)!;
    List<CategoryItem> items = itemsEncoded.map((item) => CategoryItem.fromJson(jsonDecode(item))).toList();
    return items;
  }

  void saveItems(String parentItemName, List<CategoryItem> items) {
    List<String> itemsEncoded = items.map((item) => jsonEncode(item.toJson())).toList();

    _sharedPrefs!.setStringList(parentItemName, itemsEncoded);
  }

  List<List<CategoryItem>> getAllExpenseItemsLists() {
    List<List<CategoryItem>> expenseItemsLists = [];
    for (int i = 0; i < this.parentExpenseItemNames.length; i++) {
      var parentExpenseItem = sharedPrefs.getItems(this.parentExpenseItemNames[i]);
      expenseItemsLists.add(parentExpenseItem);
    }
    return expenseItemsLists;
  }

  void removeItem(String itemName) {
    _sharedPrefs!.remove(itemName);
  }

  void setItems({required bool setCategoriesToDefault}) {
    if (!_sharedPrefs!.containsKey('parent expense item names') || setCategoriesToDefault) {
      _sharedPrefs!.setStringList('parent expense item names', ['Food & Beverages', 'Transport', 'Personal Development', 'Shopping', 'Entertainment', 'Home', 'Utility Bills', 'Health', 'Gifts & Donations', 'Kids', 'OtherExpense']);

      saveItems('income items', [
        categoryItem(Icons.account_balance_wallet, 'Salary'), // MdiIcons.accountCash
        categoryItem(Icons.business_center_rounded, 'InvestmentIncome'),
        categoryItem(Icons.account_balance_wallet, 'Bonus'),
        categoryItem(Icons.manage_search, 'Side job'),
        categoryItem(Icons.card_giftcard, 'GiftsIncome'),
        categoryItem(Icons.add_card, 'OtherIncome'), // MdiIcons.cashPlus
      ]);

      saveItems('Food & Beverages', [
        categoryItem(Icons.restaurant, 'Food & Beverages'), // MdiIcons.food
        categoryItem(Icons.lunch_dining, 'Food'), // MdiIcons.foodDrumstick
        categoryItem(Icons.local_bar, 'Beverages'),
        categoryItem(Icons.add_shopping_cart, 'Daily Necessities'),
      ]);

      saveItems('Transport', [categoryItem(Icons.directions_car, 'Transport'), categoryItem(Icons.local_gas_station, 'Fuel'), categoryItem(Icons.local_parking, 'Parking'), categoryItem(Icons.build, 'Services & Maintenance'), categoryItem(Icons.local_taxi_outlined, 'Taxi')]);

      saveItems('Personal Development', [categoryItem(Icons.person, 'Personal Development'), categoryItem(Icons.business, 'Business'), categoryItem(Icons.school, 'Education'), categoryItem(Icons.savings, 'InvestmentExpense')]);

      saveItems('Shopping', [
        categoryItem(Icons.shopping_cart, 'Shopping'),
        categoryItem(Icons.checkroom, 'Clothes'), // Boxicons.bxs_t_shirt
        categoryItem(Icons.watch, 'Accessories'), // Boxicons.bxs_binoculars
        categoryItem(Icons.devices, 'Electronic Devices'), // Boxicons.bxs_devices
      ]);

      saveItems('Entertainment', [categoryItem(Icons.celebration, 'Entertainment'), categoryItem(Icons.movie_filter, 'Movies'), categoryItem(Icons.sports_esports, 'Games'), categoryItem(Icons.library_music, 'Music'), categoryItem(Icons.airplanemode_active, 'Travel')]);

      saveItems('Home', [
        categoryItem(Icons.home, 'Home'), // MdiIcons.homeHeart
        categoryItem(Icons.pets, 'Pets'), // MdiIcons.dogService
        categoryItem(Icons.chair, 'Furnishings'), // MdiIcons.tableChair
        categoryItem(Icons.home_repair_service, 'Home Services'), // MdiIcons.autoFix
        categoryItem(Icons.request_quote, 'Mortgage & Rent'), // MdiIcons.currencyUsd
      ]);

      saveItems('Utility Bills', [
        categoryItem(Icons.receipt_long, 'Utility Bills'), // FontAwesomeIcons.fileInvoiceDollar
        categoryItem(Icons.lightbulb, 'Electricity'),
        categoryItem(Icons.language, 'Internet'),
        categoryItem(Icons.smartphone, 'Mobile Phone'),
        categoryItem(Icons.water_drop, 'Water'),
      ]);

      saveItems('Health', [
        categoryItem(Icons.medical_services, 'Health'), // FontAwesomeIcons.handHoldingMedical
        categoryItem(Icons.sports_soccer, 'Sports'), // MdiIcons.soccer
        categoryItem(Icons.health_and_safety, 'Health Insurance'), // MdiIcons.fileDocumentMultipleOutline
        categoryItem(Icons.local_hospital, 'Doctor'), // MdiIcons.doctor
        categoryItem(Icons.medication, 'Medicine'), // MdiIcons.medicalBag
      ]);

      saveItems('Gifts & Donations', [
        categoryItem(Icons.volunteer_activism, 'Gifts & Donations'), // Boxicons.bxs_donate_heart
        categoryItem(Icons.card_giftcard, 'GiftsExpense'),
        categoryItem(Icons.favorite, 'Wedding'),
        categoryItem(Icons.sentiment_dissatisfied, 'Funeral'),
        categoryItem(Icons.group, 'Charity'),
      ]);

      saveItems('Kids', [
        categoryItem(Icons.child_care, 'Kids'),
        categoryItem(Icons.savings, 'Pocket Money'), // MdiIcons.cashCheck
        categoryItem(Icons.baby_changing_station, 'Baby Products'), // MdiIcons.babyBottle
        categoryItem(Icons.baby_changing_station, 'Babysitter & Daycare'), // MdiIcons.humanBabyChangingTable
        categoryItem(Icons.menu_book, 'Tuition'), // MdiIcons.bookCheck
      ]);

      saveItems('OtherExpense', [
        categoryItem(Icons.add_card, 'OtherExpense'), // MdiIcons.cashPlus
      ]);

      if (!setCategoriesToDefault) {
        _sharedPrefs!.setString('selectedDate', 'Today');
        _sharedPrefs!.setBool('isPasscodeOn', false);
        _sharedPrefs!.setString('passcodeScreenLock', '');
        _sharedPrefs!.setString('dateFormat', 'dd/MM/yyyy');
      }
    }

    if (_sharedPrefs!.containsKey('parent expense item names') == false) {
      print('didnt save successfully');
    }
  }
}
