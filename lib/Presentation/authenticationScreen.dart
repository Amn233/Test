import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:untitled/Bloc/AuthenticationEvent.dart';
import 'package:untitled/CustomWidget/customText.dart';
import 'package:untitled/Presentation/complaintListScreen.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  static const Color primaryColor = Color(0xFFDE7A72);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Use const for size

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CustomText(
          text: "Biometric Authentication",
          fontFamily: "Plus",
          fontSize: size.width * 0.05,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primaryColor, primaryColor],
              stops: [0.01, 1],
            ),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            iconColor: Colors.white,
            color: Colors.white,
            onSelected: (value) {
              if (value == 'Screen1') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ComplaintListScreen()),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'Screen1',
                child: Text('Go to Complaint list Screen'),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<AuthenticationEvent, String>(
        listener: (context, state) {
          if (state.contains("Error") || state.contains("failed") || state.contains("successful")) {
            _showSnackbar(context, state, primaryColor);
          }
        },
        builder: (context, state) {
          switch (state) {
            case "Initial":
              return _buildInitialState(size, context);
            case "Authenticating":
              return const Center(child: CircularProgressIndicator(color: Color(0xFFDE7A72),));
            default:
              return _buildAuthenticationState(size, context, state);
          }
        },
      ),
    );
  }

  Widget _buildInitialState(Size size, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/fingerprint.json', // Lottie animation for fingerprint authentication
            width: size.width * 0.3,
          ),
          SizedBox(height: size.height * 0.03),
          Center(
            child: CustomText(
              text: 'Please authenticate to unlock the screen.',
              fontFamily: "Plus",
              fontSize: size.width * 0.04,
              textAlign: TextAlign.center,
              color: Colors.grey[700],
              maxLines: 2,
            ),
          ),
          SizedBox(height: size.height * 0.04),
          _buildAuthButton(context, size, "Authenticate with Biometrics"),
        ],
      ),
    );
  }

  Widget _buildAuthenticationState(Size size, BuildContext context, String state) {
    if (state.contains("successful")) {
      // If authentication is successful, show a success animation
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/fingerprint1.json', // Replace with your success animation
              width: size.width * 0.6,
            ),
            SizedBox(height: size.height * 0.00),
            CustomText(
              text: 'Authentication Successful!',
              fontSize: size.width * 0.05,
              color: Color(0xFFDE7A72),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else if (state.contains("Error") || state.contains("failed")) {
      // If authentication failed, show a failure (lock) animation
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/error1.json', // Replace with your failure animation
              width: size.width * 0.5,
            ),
            SizedBox(height: size.height * 0.02),
            CustomText(
              text: 'Authentication Failed!',
              fontSize: size.width * 0.05,
              color: Colors.red,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: size.height * 0.04),
            _buildAuthButton(context, size, "Try Again"),
          ],
        ),
      );
    }
    return Container(); // Default case when state doesn't match
  }

  Widget _buildAuthButton(BuildContext context, Size size, String text) {
    return ElevatedButton(
      onPressed: () {
        context.read<AuthenticationEvent>().authenticateUser();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AuthenticationScreen.primaryColor,
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.1,
          vertical: size.height * 0.02,
        ),
        textStyle: TextStyle(
          fontSize: size.width * 0.05,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 6,
      ),
      child: CustomText(
        text: text,
        color: Colors.white,
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message, Color color) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
