import 'package:flutter/material.dart';
import 'package:vnua_service/route/route_constants.dart';
import 'package:vnua_service/screens/language/select_language_screen.dart';

import 'screen_export.dart';

Route<dynamic> generateRoute(
  RouteSettings settings, {
  void Function(Locale)? onLocaleChange,
}) {
  switch (settings.name) {
    case selectLanguageScreenRoute:
      return MaterialPageRoute(
        builder: (context) => SelectLanguageScreen(
          onLocaleChange: onLocaleChange!,
        ),
      );
    case splashScreen:
      return MaterialPageRoute(
        builder: (context) => const SplashScreen(),
      );
    case onbordingScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const OnBordingScreen(),
      );
    case logInScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case LayoutScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const LayoutScreen(),
      );
    case signUpScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      );
    case passwordRecoveryScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const PasswordRecoveryScreen(),
      );
    case homeScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      );
    case profileScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      );
    case userInfoScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const UserInfoScreen(),
      );
    case motelSearchRoute:
      return MaterialPageRoute(
        builder: (context) => const MotelSearchScreen(),
      );
    case notificationOptionsScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const NotificationScreen(),
      );
    case createPostRoute:
      return MaterialPageRoute(
        builder: (context) => const CreatePostScreen(),
      );
    case managePostRoute:
      return MaterialPageRoute(
        builder: (context) => const ManagePostsScreen(),
      );
    case notificationsScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const NotificationScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const SplashScreen(),
      );
  }
}
