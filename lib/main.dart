import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vnua_service/route/route_constants.dart';
import 'package:vnua_service/route/router.dart' as router;
import 'package:vnua_service/theme/app_theme.dart';
import 'generated/l10n.dart'; // generated từ flutter gen-l10n

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Locale _locale = const Locale('vi'); // Ngôn ngữ mặc định

  void setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VNUA SERVICE',
      theme: AppTheme.lightTheme(context),
      themeMode: ThemeMode.light,
      locale: _locale,
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      onGenerateRoute: (settings) {
        return router.generateRoute(
          settings,
          onLocaleChange: setLocale,
        );
      },
      initialRoute: splashScreen,
    );
  }
}
