import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/signin_screen.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) async {
      await dotenv.load(fileName: 'assets/.env');
      runApp(const RoblesAdvMobProg());
    },
  );
}

class RoblesAdvMobProg extends StatelessWidget {
  const RoblesAdvMobProg({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: ScreenUtilInit(
        designSize: const Size(412, 715),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          final themeModel = context.watch<ThemeProvider>();
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'E-Commerce App',
            // Dynamically switch light/dark theme using ThemeProvider
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeModel.isDark ? ThemeMode.dark : ThemeMode.light,
            initialRoute: '/splash',
            routes: {
              // enhancement 1: splash checks persistent auth before landing
              // on /home or /signin
              '/splash': (context) => const SplashScreen(),
              // enhancement 2: sign-in screen backed by UserService
              '/signin': (context) => const SignInScreen(),
              '/home': (context) => const HomeScreen(),
              // Route for Settings Screen
              '/settings': (context) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}