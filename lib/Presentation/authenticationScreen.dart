import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/Bloc/AuthenticationEvent.dart';
import 'package:untitled/CustomWidget/customText.dart';
import 'package:untitled/Presentation/complaintListScreen.dart';
import '../Bloc/ComplaintListBloc.dart';

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
          decoration: BoxDecoration(
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
                  MaterialPageRoute(builder: (context) => ComplaintListScreen()),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
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
              return Center(child: CircularProgressIndicator(color: Color(0xFFDE7A72),));
            default:
              return _buildErrorState(size, context, state);
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
          Icon(
            Icons.fingerprint,
            size: size.width * 0.25,
            color: AuthenticationScreen.primaryColor,
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

  Widget _buildErrorState(Size size, BuildContext context, String state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_open,
            size: size.width * 0.25,
            color: AuthenticationScreen.primaryColor,
          ),
          SizedBox(height: size.height * 0.03),
          CustomText(
            text: state,
            fontSize: size.width * 0.05,
            color: Colors.grey[700],
            textAlign: TextAlign.center,
          ),
          SizedBox(height: size.height * 0.04),
          _buildAuthButton(context, size, "Try Again"),
        ],
      ),
    );
  }

  Widget _buildAuthButton(BuildContext context, Size size, String text) {
    return ElevatedButton(
      onPressed: () {
        context.read<AuthenticationEvent>().authenticateUser();
      },
      child: CustomText(
        text: text,
        color: Colors.white,
      ),
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
    );
  }

  void _showSnackbar(BuildContext context, String message, Color color) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}