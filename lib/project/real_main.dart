import 'package:controle_financeiro/firebase_options.dart';
import 'package:controle_financeiro/project/auth_pages/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'database_management/shared_preferences_services.dart';
import 'localization/app_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home.dart';

void realMain() async {
  print('=== INICIANDO REAL_MAIN ===');
  WidgetsFlutterBinding.ensureInitialized();
  print('=== WIDGETS BINDING OK ===');

  // Teste 1: Comente o Firebase e veja se passa
  try {
    print('=== INICIANDO FIREBASE ===');
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).timeout(const Duration(seconds: 10)).catchError((e) {
      print('=== FIREBASE TIMEOUT - PULANDO ===');
      // Repassa a exceção para cair no catch do try externo.
      throw e;
    });
    print('=== FIREBASE OK ===');
  } catch (e) {
    print('=== FIREBASE ERRO: $e ===');
  }

  // Teste 2: Comente SharedPrefs e veja se passa
  try {
    print('=== INICIANDO SHAREDPREFS ===');
    await sharedPrefs.sharePrefsInit().timeout(
      Duration(seconds: 5),
      onTimeout: () {
        print('=== SHAREDPREFS TIMEOUT - PULANDO ===');
        return;
      },
    );
    print('=== SHAREDPREFS OK ===');
  } catch (e) {
    print('=== SHAREDPREFS ERRO: $e ===');
  }

  print('=== INICIANDO APP ===');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Locale> _localeFuture;

  @override
  void initState() {
    super.initState();
    print('=== MyApp initState ===');
    _localeFuture = _getAppLocale();
  }

  Future<Locale> _getAppLocale() async {
    try {
      Locale? locale = sharedPrefs.getLocale();
      if (locale != null) {
        return locale;
      }
    } catch (e) {
      print('Error getting locale: $e');
    }
    return const Locale("en", "US");
  }

  @override
  Widget build(BuildContext context) {
    print('=== MyApp build() ===');
    return FutureBuilder<Locale>(
      future: _localeFuture,
      builder: (context, snapshot) {
        print('=== FutureBuilder state: ${snapshot.connectionState} ===');
        Locale locale = snapshot.data ?? const Locale("en", "US");

        return ScreenUtilInit(
          designSize: const Size(428.0, 926.0),
          builder: (_, child) => MaterialApp(
            title: 'MMAS',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              textTheme: TextTheme(
                displayMedium: const TextStyle(fontFamily: 'OpenSans', fontSize: 45.0, color: Colors.deepOrangeAccent),
                labelLarge: const TextStyle(fontFamily: 'OpenSans'),
                titleLarge: const TextStyle(fontFamily: 'NotoSans'),
                bodyMedium: const TextStyle(fontFamily: 'NotoSans'),
              ),
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo).copyWith(secondary: Colors.orange),
              textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.amberAccent),
            ),
            builder: (context, widget) => MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1), child: widget!),
            home: SignIn(),
            locale: locale,
            localizationsDelegates: [AppLocalization.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale!.languageCode && supportedLocale.countryCode == locale.countryCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            supportedLocales: const [Locale("en", "US"), Locale("de", "DE"), Locale("es", "ES"), Locale("fr", "FR"), Locale("hi", "IN"), Locale("ja", "JP"), Locale("ko", "KR"), Locale("pt", "PT"), Locale("ru", "RU"), Locale("tr", "TR"), Locale("vi", "VN"), Locale("zh", "CN"), Locale("ne", "NP")],
          ),
        );
      },
    );
  }
}
