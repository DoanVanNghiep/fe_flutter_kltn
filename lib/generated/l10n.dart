// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hello World`
  String get title {
    return Intl.message('Hello World', name: 'title', desc: '', args: []);
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Manage posts`
  String get generated_manage_posts {
    return Intl.message(
      'Manage posts',
      name: 'generated_manage_posts',
      desc: '',
      args: [],
    );
  }

  /// `Top up`
  String get generated_top_up {
    return Intl.message('Top up', name: 'generated_top_up', desc: '', args: []);
  }

  /// `Favorites`
  String get generated_favorites {
    return Intl.message(
      'Favorites',
      name: 'generated_favorites',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get generated_address {
    return Intl.message(
      'Address',
      name: 'generated_address',
      desc: '',
      args: [],
    );
  }

  /// `Payment`
  String get generated_payment {
    return Intl.message(
      'Payment',
      name: 'generated_payment',
      desc: '',
      args: [],
    );
  }

  /// `Wallet`
  String get generated_wallet {
    return Intl.message('Wallet', name: 'generated_wallet', desc: '', args: []);
  }

  /// `Notifications`
  String get generated_notifications {
    return Intl.message(
      'Notifications',
      name: 'generated_notifications',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get generated_settings {
    return Intl.message(
      'Settings',
      name: 'generated_settings',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get generated_location {
    return Intl.message(
      'Location',
      name: 'generated_location',
      desc: '',
      args: [],
    );
  }

  /// `FAQ`
  String get generated_faq {
    return Intl.message('FAQ', name: 'generated_faq', desc: '', args: []);
  }

  /// `Log out`
  String get generated_log_out {
    return Intl.message(
      'Log out',
      name: 'generated_log_out',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get generated_home {
    return Intl.message('Home', name: 'generated_home', desc: '', args: []);
  }

  /// `Account`
  String get generated_account {
    return Intl.message(
      'Account',
      name: 'generated_account',
      desc: '',
      args: [],
    );
  }

  /// `Search rental rooms`
  String get generated_search_rental_rooms {
    return Intl.message(
      'Search rental rooms',
      name: 'generated_search_rental_rooms',
      desc: '',
      args: [],
    );
  }

  /// `Rental room`
  String get generated_rental_room {
    return Intl.message(
      'Rental room',
      name: 'generated_rental_room',
      desc: '',
      args: [],
    );
  }

  /// `Store`
  String get generated_store {
    return Intl.message('Store', name: 'generated_store', desc: '', args: []);
  }

  /// `Delivery`
  String get generated_delivery {
    return Intl.message(
      'Delivery',
      name: 'generated_delivery',
      desc: '',
      args: [],
    );
  }

  /// `Post categories`
  String get generated_post_categories {
    return Intl.message(
      'Post categories',
      name: 'generated_post_categories',
      desc: '',
      args: [],
    );
  }

  /// `Manage listings`
  String get generated_manage_listings {
    return Intl.message(
      'Manage listings',
      name: 'generated_manage_listings',
      desc: '',
      args: [],
    );
  }

  /// `Create post`
  String get generated_create_post {
    return Intl.message(
      'Create post',
      name: 'generated_create_post',
      desc: '',
      args: [],
    );
  }

  /// `Login successful!`
  String get generated_login_successful {
    return Intl.message(
      'Login successful!',
      name: 'generated_login_successful',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email address`
  String get generated_enter_email_address {
    return Intl.message(
      'Please enter your email address',
      name: 'generated_enter_email_address',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get generated_enter_password {
    return Intl.message(
      'Please enter your password',
      name: 'generated_enter_password',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get generated_password {
    return Intl.message(
      'Password',
      name: 'generated_password',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password?`
  String get generated_forgot_password {
    return Intl.message(
      'Forgot password?',
      name: 'generated_forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get generated_login {
    return Intl.message('Login', name: 'generated_login', desc: '', args: []);
  }

  /// `Please enter your email`
  String get generated_please_enter_your_email {
    return Intl.message(
      'Please enter your email',
      name: 'generated_please_enter_your_email',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid email`
  String get generated_enter_valid_email {
    return Intl.message(
      'Enter a valid email',
      name: 'generated_enter_valid_email',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get generated_continue {
    return Intl.message(
      'Continue',
      name: 'generated_continue',
      desc: '',
      args: [],
    );
  }

  /// `Name cannot be empty`
  String get generated_name_cannot_be_empty {
    return Intl.message(
      'Name cannot be empty',
      name: 'generated_name_cannot_be_empty',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get generated_username {
    return Intl.message(
      'Username',
      name: 'generated_username',
      desc: '',
      args: [],
    );
  }

  /// `Email cannot be empty`
  String get generated_email_cannot_be_empty {
    return Intl.message(
      'Email cannot be empty',
      name: 'generated_email_cannot_be_empty',
      desc: '',
      args: [],
    );
  }

  /// `Email address`
  String get generated_email_address {
    return Intl.message(
      'Email address',
      name: 'generated_email_address',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get generated_password_min_length {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'generated_password_min_length',
      desc: '',
      args: [],
    );
  }

  /// `Code`
  String get generated_code {
    return Intl.message('Code', name: 'generated_code', desc: '', args: []);
  }

  /// `Registration error`
  String get generated_registration_error {
    return Intl.message(
      'Registration error',
      name: 'generated_registration_error',
      desc: '',
      args: [],
    );
  }

  /// `Verification successful`
  String get generated_verification_success {
    return Intl.message(
      'Verification successful',
      name: 'generated_verification_success',
      desc: '',
      args: [],
    );
  }

  /// `Verification failed!`
  String get generated_verification_failed {
    return Intl.message(
      'Verification failed!',
      name: 'generated_verification_failed',
      desc: '',
      args: [],
    );
  }

  /// `Wrong OTP, please try again.`
  String get generated_wrong_otp {
    return Intl.message(
      'Wrong OTP, please try again.',
      name: 'generated_wrong_otp',
      desc: '',
      args: [],
    );
  }

  /// `OTP has been resent!`
  String get generated_otp_resent {
    return Intl.message(
      'OTP has been resent!',
      name: 'generated_otp_resent',
      desc: '',
      args: [],
    );
  }

  /// `Failed to resend OTP:`
  String get generated_resend_otp_error {
    return Intl.message(
      'Failed to resend OTP:',
      name: 'generated_resend_otp_error',
      desc: '',
      args: [],
    );
  }

  /// `Login failed!`
  String get generated_login_failed {
    return Intl.message(
      'Login failed!',
      name: 'generated_login_failed',
      desc: '',
      args: [],
    );
  }

  /// `OTP sent successfully!`
  String get generated_otp_sent_success {
    return Intl.message(
      'OTP sent successfully!',
      name: 'generated_otp_sent_success',
      desc: '',
      args: [],
    );
  }

  /// `Please enter all 6 digits of the OTP.`
  String get generated_enter_6_digits {
    return Intl.message(
      'Please enter all 6 digits of the OTP.',
      name: 'generated_enter_6_digits',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get generated_success {
    return Intl.message(
      'Success',
      name: 'generated_success',
      desc: '',
      args: [],
    );
  }

  /// `Invalid or expired OTP. Please try again.`
  String get generated_invalid_or_expired_otp {
    return Intl.message(
      'Invalid or expired OTP. Please try again.',
      name: 'generated_invalid_or_expired_otp',
      desc: '',
      args: [],
    );
  }

  /// `OTP verification error:`
  String get generated_otp_verification_error {
    return Intl.message(
      'OTP verification error:',
      name: 'generated_otp_verification_error',
      desc: '',
      args: [],
    );
  }

  /// `Let's get started!`
  String get generated_lets_start {
    return Intl.message(
      'Let\'s get started!',
      name: 'generated_lets_start',
      desc: '',
      args: [],
    );
  }

  /// `OTP has been sent to your email:`
  String get generated_otp_sent_to_email {
    return Intl.message(
      'OTP has been sent to your email:',
      name: 'generated_otp_sent_to_email',
      desc: '',
      args: [],
    );
  }

  /// `Code expires in:`
  String get generated_otp_expires_in {
    return Intl.message(
      'Code expires in:',
      name: 'generated_otp_expires_in',
      desc: '',
      args: [],
    );
  }

  /// `OTP has expired. Please resend.`
  String get generated_otp_expired {
    return Intl.message(
      'OTP has expired. Please resend.',
      name: 'generated_otp_expired',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get generated_resend {
    return Intl.message('Resend', name: 'generated_resend', desc: '', args: []);
  }

  /// `Confirm`
  String get generated_confirm {
    return Intl.message(
      'Confirm',
      name: 'generated_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get generated_no_account {
    return Intl.message(
      'Don\'t have an account?',
      name: 'generated_no_account',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your correct email address`
  String get generated_enter_valid_email_address {
    return Intl.message(
      'Please enter your correct email address',
      name: 'generated_enter_valid_email_address',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password.`
  String get generated_enter_password_required {
    return Intl.message(
      'Please enter your password.',
      name: 'generated_enter_password_required',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match.`
  String get generated_passwords_do_not_match {
    return Intl.message(
      'Passwords do not match.',
      name: 'generated_passwords_do_not_match',
      desc: '',
      args: [],
    );
  }

  /// `Set new password`
  String get generated_set_new_password {
    return Intl.message(
      'Set new password',
      name: 'generated_set_new_password',
      desc: '',
      args: [],
    );
  }

  /// `Your new password must be different from previously used passwords.`
  String get generated_new_password_note {
    return Intl.message(
      'Your new password must be different from previously used passwords.',
      name: 'generated_new_password_note',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get generated_new_password {
    return Intl.message(
      'New password',
      name: 'generated_new_password',
      desc: '',
      args: [],
    );
  }

  /// `New password again`
  String get generated_new_password_again {
    return Intl.message(
      'New password again',
      name: 'generated_new_password_again',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get generated_change_password {
    return Intl.message(
      'Change Password',
      name: 'generated_change_password',
      desc: '',
      args: [],
    );
  }

  /// `Not updated`
  String get generated_not_updated {
    return Intl.message(
      'Not updated',
      name: 'generated_not_updated',
      desc: '',
      args: [],
    );
  }

  /// `Registration successful! Please check your email to enter the OTP.`
  String get generated_registration_success_check_email {
    return Intl.message(
      'Registration successful! Please check your email to enter the OTP.',
      name: 'generated_registration_success_check_email',
      desc: '',
      args: [],
    );
  }

  /// `Registration failed`
  String get generated_registration_failed {
    return Intl.message(
      'Registration failed',
      name: 'generated_registration_failed',
      desc: '',
      args: [],
    );
  }

  /// `I agree with`
  String get generated_agree_with {
    return Intl.message(
      'I agree with',
      name: 'generated_agree_with',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Service`
  String get generated_terms_of_service {
    return Intl.message(
      'Terms of Service',
      name: 'generated_terms_of_service',
      desc: '',
      args: [],
    );
  }

  /// `& Privacy Policy.`
  String get generated_and_privacy_policy {
    return Intl.message(
      '& Privacy Policy.',
      name: 'generated_and_privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get generated_have_an_account {
    return Intl.message(
      'Already have an account?',
      name: 'generated_have_an_account',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
