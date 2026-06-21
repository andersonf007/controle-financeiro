import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:controle_financeiro/project/localization/methods.dart';

/// Abre a página da app na App Store (iOS) ou Play Store (Android)
Future<void> openAppStore(BuildContext context) async {
  final String appStoreId = '1582638369'; // iOS
  final String playStoreId = 'com.unifortesistemas.controlefinanceiro'; // Android

  final String url = Platform.isIOS ? 'https://apps.apple.com/app/id$appStoreId' : 'https://play.google.com/store/apps/details?id=$playStoreId';

  try {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      print('Could not launch $url');
    }
  } catch (e) {
    print('Error opening app store: $e');
  }
}
