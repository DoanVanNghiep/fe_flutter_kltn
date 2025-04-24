import 'package:flutter/material.dart';
import 'package:vnua_service/entry_point.dart';
import 'package:vnua_service/route/route_constants.dart';

import 'screen_export.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case onbordingScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const OnBordingScreen(),
      );
    case logInScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
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
    default:
      return MaterialPageRoute(
        builder: (context) => const OnBordingScreen(),
      );
  }
}
