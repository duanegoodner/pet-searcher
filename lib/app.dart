import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:pet_matcher/screens/user_home_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/login_screen.dart';
import 'screens/account_setup_screen.dart';
import 'screens/test_screen.dart';

class PetMatcherApp extends StatelessWidget {
  static final routes = {
    LandingScreen.routeName: (context) => LandingScreen(),
    LoginScreen.routeName: (context) => LoginScreen(),
    AccountSetupScreen.routeName: (context) => AccountSetupScreen(),
    UserHomeScreen.routeName: (context) => UserHomeScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => fb_auth.FirebaseAuth.instance,
      child: MaterialApp(
        title: 'Pet Matcher',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StartupScreenSelector(),
        routes: routes,
        // initialRoute: LandingScreen.routeName,
      ),
    );
  }
}

class StartupScreenSelector extends StatelessWidget {
  const StartupScreenSelector({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of<fb_auth.FirebaseAuth>(context).authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null) {
            return LandingScreen();
          }
          return TestScreen();
        } else {
          return Scaffold(
            backgroundColor: Colors.blue[300],
            body: Center(
              child: Column(
                children: [
                  Text(
                    'Wating for Firebase Connection',
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                    ),
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
