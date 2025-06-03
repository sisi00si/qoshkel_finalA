import 'package:QoshKel/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:QoshKel/features/authentication/screens/onboarding/onboarding.dart';
import 'package:QoshKel/utils/theme/theme.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:get_storage/get_storage.dart';
import 'package:QoshKel/app.dart';
import 'package:QoshKel/data/repositories/authentication/authentication_repository.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
//НУЖЕН ДАТА
// import 'data/repositories/authentication/authentication_repository.dart'
import 'package:QoshKel/data/repositories/authentication/authentication_repository.dart';
import 'package:QoshKel/utils/helpers/network_manager.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  Get.put(NetworkManager());

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((FirebaseApp value) => Get.put(AuthenticationRepository()));

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: QKAppTheme.lightTheme,
      darkTheme: QKAppTheme.darkTheme,
      home: const OnboardingScreen(),
    );
  }
}
