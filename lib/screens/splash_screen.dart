import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:messageme_app/screens/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String screenRoute ='/splash_screen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 4),(){
      Navigator.pushReplacementNamed(context, WelcomeScreen.screenRoute);

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Chat Room ' , style: TextStyle(
                color: Colors.yellow[900], fontSize: 50
            ),),
            SizedBox(height: 50,),

            Image(image: AssetImage('images/logo.png'),width: 150,),
            SizedBox(height: 50,),
            SpinKitWave(
        color: Colors.orange,
        size: 50.0,
      ),
            SizedBox(height: 50,),

            Text('Text chat room ' , style: TextStyle(
                color: Colors.yellow[900], fontSize: 30
            ),),

          ],
        ),
      ),
    );
  }
}
