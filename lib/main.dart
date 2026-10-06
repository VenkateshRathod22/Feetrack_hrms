import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:vlr/firebase/get_fcm_token.dart';
import 'package:vlr/firebase_options.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/theme.dart';
import 'package:toastification/toastification.dart';
import 'package:vlr/views/screens/splash_screen/splash_screen.dart';
import 'services/init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Init().initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FCMService.initialize();
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> snackBarKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    log('Current state = $state');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    // log("Height : ${MediaQuery.of(context).size.height}");
    // log("weight : ${MediaQuery.of(context).size.width}");

    return ToastificationWrapper(
      child: ScreenUtilInit(
        designSize: Size(432.0, 960.0),
        minTextAdapt: true,
        // splitScreenMode: true,
        builder: (_, child) {
          return GetMaterialApp(
            title: AppConstants.appName,
            navigatorKey: navigatorKey,
            themeMode: ThemeMode.light,
            theme: CustomTheme.light,
            debugShowCheckedModeBanner: false,
            home: child,
          );
        },
        child: const SplashScreen(),
        // child: const AttendancePunchOutScreen(),q
        // child: const ApplyLeave(),
        // child: const LeadCreateScreen(),
        // child: const AccountScreen(),
        // child: const HomeScreen(),
      ),
    );
  }
}


// | Property              | Use         |
// | --------------------- | ----------- |
// | Width                 | `100.                                              w`     |
// | Height                | `50.h`      |
// | Font Size             | `14.sp`     |
// | Border Radius         | `12.r`      |
// | Icon Size             | `24.sp`     |
// | Border Width          | `1` (fixed) |
// | Divider Thickness     | `1` (fixed) |
// | Horizontal Padding    | `16.w`      |
// | Vertical Padding      | `12.h`      |
// | Margin Left/Right     | `16.w`      |
// | Margin Top/Bottom     | `12.h`      |
// | Square Padding/Margin | `12.w`      |

