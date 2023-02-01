import 'package:flutter/material.dart';
import 'package:messageme_app/screens/chat_screen.dart';
import 'package:messageme_app/screens/registration_screen.dart';
import 'package:messageme_app/screens/signin_screen.dart';
import 'package:messageme_app/screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MessageMe app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // initialRoute: _auth.currentUser!= null ? ChatScreen.screenRoute:WelcomeScreen.screenRoute,
      initialRoute: SplashScreen.screenRoute,
      routes: {
        WelcomeScreen.screenRoute: (context)=>WelcomeScreen(),
        SignInScreen.screenRoute: (context)=>SignInScreen(),
        RegistrationScreen.screenRoute: (context)=>RegistrationScreen(),
        ChatScreen.screenRoute: (context)=>ChatScreen(),
        SplashScreen.screenRoute: (context)=>SplashScreen(),
      },
    );
  }
}