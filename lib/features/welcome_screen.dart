// import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:education_app/features/login_screen.dart';
import 'package:flutter/material.dart';
// import 'package:page_transition/page_transition.dart';

class WelcomeScreen extends StatelessWidget {
 static String id='welcome_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff0F172A),
              Color(0xff1E293B),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                /// Logo
                const CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage(
                    "assets/images/img.png",
                  ),
                ),

                const SizedBox(height: 40),

                const Text(
                  "EduAf",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                /// Start Button
                Padding(padding: EdgeInsets.symmetric( vertical: 20, horizontal: 10),
                child: Material(
                  elevation: 5,
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                  child: MaterialButton(onPressed: () { Navigator.pushNamed(context, LoginScreen.id);},
                  minWidth: 200,
                  height: 42,
                  child: Text("Let\'s Build Our Future", style: TextStyle(fontWeight: FontWeight.bold,),),
                ),
                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}