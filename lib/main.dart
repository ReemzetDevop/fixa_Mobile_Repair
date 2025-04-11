import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fixa/Mobile/Screen/MHomePage.dart';
import 'package:fixa/Services/LoginWithGoogle.dart';
import 'package:fixa/Tester/TesterLogin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("8c236bbd-2af1-46cb-81b5-2cff2159e38f");
  OneSignal.Notifications.requestPermission(true);
  final bool isLoggedIn = checkIfUserIsLoggedIn();

  // Run the app
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

bool checkIfUserIsLoggedIn() {
  final user = FirebaseAuth.instance.currentUser;
  return user != null;
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 810),
      child: MaterialApp(
          title: 'Fixa Service',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          // Choose home screen based on login status
          home: isLoggedIn?Mhomepage(): SignInScreen()
    ));
  }
}
