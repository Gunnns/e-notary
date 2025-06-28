import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/registration_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/registration_success_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/documents/upload_document_screen.dart' as upload;
import '../screens/documents/document_list_screen.dart' as list;
import '../screens/documents/document_detail_screen.dart';
import '../screens/documents/document_editor_screen.dart';
import '../screens/documents/upload_success_screen.dart';
import '../models/document.dart';

class AppRouter {
  // Auth Routes
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String registrationSuccess = '/registration-success';

  // Home Route
  static const String home = '/home';

  // Document Routes
  static const String uploadDocument = '/upload-document';
  static const String documentList = '/document-list';
  static const String documentDetail = '/document-detail';
  static const String documentEditor = '/document-editor';
  static const String uploadSuccess = '/upload-success';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Helper function to create page routes with consistent transition
    MaterialPageRoute buildRoute(Widget widget, [RouteSettings? settings]) {
      return MaterialPageRoute(
        builder: (_) => widget,
        settings: settings,
      );
    }

    switch (settings.name) {
      // Authentication Routes
      case login:
        return buildRoute(const LoginScreen());
      case register:
        return buildRoute(const RegistrationScreen());
      case forgotPassword:
        return buildRoute(const ForgotPasswordScreen());
      case registrationSuccess:
        return buildRoute(const RegistrationSuccessScreen());

      // Main Home Route
      case home:
        return buildRoute(const HomeScreen());

      // Document Management Routes
      case uploadDocument:
        // Pastikan UploadDocumentScreen adalah class, bukan StatefulWidget dengan nama berbeda
        return buildRoute(const upload.UploadDocumentScreen());
      case documentList:
        return buildRoute(
          const list.DocumentListScreen(),
          RouteSettings(arguments: settings.arguments),
        );
      case documentDetail:
        final document = settings.arguments as Document;
        return buildRoute(DocumentDetailScreen(document: document));
      case documentEditor:
        return buildRoute(
          const DocumentEditorScreen(),
          RouteSettings(arguments: settings.arguments),
        );
      case uploadSuccess:
        return buildRoute(
          const UploadSuccessScreen(),
          RouteSettings(arguments: settings.arguments),
        );

      // Default route (fallback to login)
      default:
        return buildRoute(const LoginScreen());
    }
  }

  // Navigation helper methods
  static Future<T?> push<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    bool fullscreenDialog = false,
  }) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute(
        builder: (context) => _getScreenFromRoute(routeName, arguments),
        settings: RouteSettings(name: routeName, arguments: arguments),
        fullscreenDialog: fullscreenDialog,
      ),
    );
  }

  static Future<T?> replace<T extends Object?, TO extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushReplacement<T, TO>(
      context,
      MaterialPageRoute(
        builder: (context) => _getScreenFromRoute(routeName, arguments),
        settings: RouteSettings(name: routeName, arguments: arguments),
      ),
    );
  }

  static void popToFirst(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.pop(context, result);
  }

  // Helper method to get screen widget from route name
  static Widget _getScreenFromRoute(String routeName, Object? arguments) {
    switch (routeName) {
      case login:
        return const LoginScreen();
      case register:
        return const RegistrationScreen();
      case forgotPassword:
        return const ForgotPasswordScreen();
      case registrationSuccess:
        return const RegistrationSuccessScreen();
      case home:
        return const HomeScreen();
      case uploadDocument:
        return const upload.UploadDocumentScreen();
      case documentList:
        return const list.DocumentListScreen();
      case documentDetail:
        return DocumentDetailScreen(document: arguments as Document);
      case documentEditor:
        return const DocumentEditorScreen();
      case uploadSuccess:
        return const UploadSuccessScreen();
      default:
        return const LoginScreen();
    }
  }
}