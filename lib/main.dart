import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'ui_prototype.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details); // prints the error nicely
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('UNHANDLED: $error');
    debugPrintStack(stackTrace: stack);
    return true; // mark as handled so it doesn't crash the VM
  };

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const UiPrototypeApp());
}
