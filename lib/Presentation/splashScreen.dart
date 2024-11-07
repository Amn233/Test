import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:untitled/Bloc/AuthenticationEvent.dart';
import 'package:untitled/CustomWidget/customText.dart';
import 'authenticationScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();


    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BlocProvider(
        create: (_) => AuthenticationEvent(),
        child: AuthenticationScreen())),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.2),


            TweenAnimationBuilder(
              duration: const Duration(seconds: 1),
              tween: Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0)),
              builder: (context, Offset value, child) {
                return Transform.translate(
                  offset: value * screenWidth * 0.5,
                  child: child,
                );
              },

              child:  CustomText(
                text: 'Welcome To',
                fontFamily: "Plus",
                fontSize: screenWidth * 0.08,
                fontWeight: FontWeight.bold,
                color: Color(0xFFDE7A72),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),
            TweenAnimationBuilder(
              duration: Duration(seconds: 1),
              tween: Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0)),
              builder: (context, Offset value, child) {
                return Transform.translate(
                  offset: value * screenWidth * 0.5,
                  child: child,
                );
              },
              child: Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.1),
                child:
                CustomText(
                  text:  'Biometric Authentication App',
                  fontFamily: "Plus",
                  fontSize: screenWidth * 0.05,

                  color: Color(0xFFDE7A72),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.05),


            TweenAnimationBuilder(
              duration: Duration(seconds: 1),
              tween: Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0)),
              builder: (context, Offset value, child) {
                return Transform.translate(
                  offset: value * screenHeight * 0.2,
                  child: child,
                );
              },
              child: Center(
                child: Lottie.asset(
                  'assets/lock.json',
                  width: screenWidth * 0.7,
                  height: screenHeight * 0.3,
                  repeat: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
