import 'dart:async';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:healthcare/utils/navigation/route_manager.dart' show AppRouter;

import '../firebase_options.dart';
import '../utils/dependency_locator.dart';
// import '../utils/mic/deeplink_handler.dart';
import '../utils/themes/app_theme.dart';
import 'environment_config.dart';


class AppLoader {
  void loadApp(String path) async {
    await dotEnv.load(fileName: path);
    WidgetsFlutterBinding.ensureInitialized();

    // // Catch Flutter framework errors
    // FlutterError.onError = (FlutterErrorDetails details) {
    //   FlutterError.presentError(details);
    //   AmplitudeService().track("App Crash", properties: {
    //     "error": details.exceptionAsString(),
    //     "stackTrace": details.stack?.toString(),
    //     "library": details.library,
    //     "context": details.context?.toString(),
    //   });
    // };

    // // Catch asynchronous Dart errors
    // PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    //   AmplitudeService().track("App Crash", properties: {
    //     "error": error.toString(),
    //     "stackTrace": stack.toString(),
    //     "type": "async_error",
    //   });
    //   return false;
    // };

    await _preInit();
    runApp(const MyApp());
  }
}

Future<void> _preInit() async {
  try {
    await GetStorage.init();
    // Set system UI overlay style to transparent
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      ),
    );
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    initDependencyLocator();

    await getIt.allReady();
    // ignore: empty_catches
  } catch (e) {}

  // Isolated from the block above: video calling needs Firebase, but a
  // Firebase failure (e.g. misconfiguration, or re-initializing on a hot
  // restart) must never block DI/login/appointments/notes from working.
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    }
    // ignore: empty_catches
  } catch (e) {}
}

// for remove scroll indicator
class NoThumbScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      scrollBehavior: NoThumbScrollBehavior().copyWith(
        scrollbars: false,
      ),
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness:
                isDark ? Brightness.light : Brightness.dark,
            statusBarBrightness:
                isDark ? Brightness.dark : Brightness.light,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarDividerColor: Colors.transparent,
            systemNavigationBarIconBrightness:
                isDark ? Brightness.light : Brightness.dark,
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.0),
            ),
            child: child!,
          ),
        );
      },
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerDelegate: AppRouter.router.routerDelegate,
      routeInformationParser: AppRouter.router.routeInformationParser,
      routeInformationProvider: AppRouter.router.routeInformationProvider,
    );
  }
}