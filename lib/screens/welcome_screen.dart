import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import '../Layouts/roundedButton.dart';

class WelcomeScreen extends StatefulWidget {
  static String id='welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();
    controller=AnimationController(
        duration: Duration(seconds: 2),
        vsync: this,
      );  
    animation=CurvedAnimation(parent: controller,curve: Curves.decelerate);
    
    controller.forward();
    controller.addListener(() {
      setState(() { });
    });

  }

  @override
  void dispose() {
    
    super.dispose();
    controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                    child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                ColorizeAnimatedTextKit(
                  text:["Flash Chat"],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.w900,
                  ),
                  colors: [
                    Colors.purple,
                    Colors.blue,
                    Colors.yellow,
                    Colors.red,
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(color: Colors.lightBlueAccent,textName: 'Login',onPressed: (){
              Navigator.pushNamed(context,LoginScreen.id);
            },),
            
             RoundedButton(color: Colors.blueAccent,textName: 'Register',onPressed: (){
              Navigator.pushNamed(context,RegistrationScreen.id);
            },),
          ],
        ),
      ),
    );
  }
}