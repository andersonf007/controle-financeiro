import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
import 'package:url_launcher/url_launcher.dart';

class RateAppManager {
  static const String _lastRateRequestKey = 'last_rate_request';
  static const String _launchCountKey = 'launch_count';
  static const String _ratedKey = 'app_rated';

  final int minDays;
  final int minLaunches;
  final int remindDays;
  final int remindLaunches;
  final String googlePlayIdentifier;
  final String appStoreIdentifier;

  RateAppManager({
    this.minDays = 0,
    this.minLaunches = 1,
    this.remindDays = 4,
    this.remindLaunches = 15,
    required this.googlePlayIdentifier,
    required this.appStoreIdentifier,
  });

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    int launchCount = prefs.getInt(_launchCountKey) ?? 0;
    launchCount++;
    await prefs.setInt(_launchCountKey, launchCount);
  }

  Future<bool> shouldShowDialog() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Se o usuário já avaliou, não mostra mais
    bool hasRated = prefs.getBool(_ratedKey) ?? false;
    if (hasRated) return false;

    int launchCount = prefs.getInt(_launchCountKey) ?? 0;
    
    // Verifica minLaunches
    if (launchCount < minLaunches) return false;

    // Verifica minDays
    int? lastRequestTime = prefs.getInt(_lastRateRequestKey);
    if (lastRequestTime != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final daysSinceLastRequest = (now - lastRequestTime) ~/ (24 * 60 * 60 * 1000);
      
      // Se foi perguntado recentemente, espera remindDays
      if (daysSinceLastRequest < remindDays) return false;
      
      // Se foi perguntado muitas vezes e passou remindLaunches, para de pedir
      if (launchCount >= remindLaunches) return false;
    }

    return true;
  }

  Future<void> markRated() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_ratedKey, true);
  }

  Future<void> markRemindLater() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt(_lastRateRequestKey, now);
  }

  Future<void> openAppStore() async {
    final String url = Platform.isIOS
        ? 'https://apps.apple.com/app/id$appStoreIdentifier'
        : 'https://play.google.com/store/apps/details?id=$googlePlayIdentifier';

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
        await markRated();
      }
    } catch (e) {
      print('Error opening app store: $e');
    }
  }

  Future<void> showRateDialog(BuildContext context, {Function(RateDialogButton)? listener}) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rate this app'),
          content: Text(
            'If you like this app, please take a little bit of your time to review it!\nYour support means the world to us ^^',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                markRemindLater();
                listener?.call(RateDialogButton.later);
              },
              child: Text('MAYBE LATER'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                listener?.call(RateDialogButton.no);
              },
              child: Text('NO THANKS'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppStore();
                listener?.call(RateDialogButton.rate);
              },
              child: Text('RATE'),
            ),
          ],
        );
      },
    );
  }
}

enum RateDialogButton { rate, later, no }
