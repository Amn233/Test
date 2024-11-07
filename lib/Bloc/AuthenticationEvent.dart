import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// The AuthenticationEvent class extends Cubit to manage authentication states
class AuthenticationEvent extends Cubit<String> {
  // Instance of LocalAuthentication to handle biometric authentication
  final LocalAuthentication auth = LocalAuthentication();

  // Initial state of the AuthenticationEvent
  AuthenticationEvent() : super("Initial");

  // Method to authenticate the user using biometric authentication
  Future<void> authenticateUser() async {
    try {
      emit("Authenticating..."); // Emit a loading state

      // Check if the device supports biometric authentication
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      bool isDeviceSupported = await auth.isDeviceSupported();

      // If biometrics are not supported, emit an error message
      if (!canCheckBiometrics || !isDeviceSupported) {
        emit("Biometric authentication not supported.");
        return;
      }

      // Perform biometric authentication
      bool authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to unlock',
        options: const AuthenticationOptions(
          useErrorDialogs: true, // Show error dialogs if authentication fails
          stickyAuth: true,      // Keep the authentication session alive
        ),
      );

      // Emit success or failure message based on authentication result
      if (authenticated) {
        emit("Authentication successful!");
        validatePassword();  // Trigger password validation after successful authentication
      } else {
        emit("Authentication failed.");
      }
    } catch (e) {
      emit("Error: $e"); // Emit an error message if an exception occurs
    }
  }

  // Method to validate the password using a dummy API
  Future<void> validatePassword() async {
    // API URL for password validation
    final apiUrl = "http://brownonions-002-site1.ftempurl.com/api/ChefRegister/ValidateChefPassword?APIKey=mobileapi19042024&CurrentPassword=123&ChefId=34";

    // Query parameters for the API request
    final queryParameters = {
      "ChefId": "3",
      "CurrentPassword": "123",
      "APIKey": "mobileapi19042024",
    };

    // Create a URI with the query parameters
    final uri = Uri.parse(apiUrl).replace(queryParameters: queryParameters);

    // Headers for the API request
    final headers = {
      'Authorization': 'Bearer mobileapi19042024',
      'Content-Type': 'application/json',
    };

    try {
      // Make a GET request to the API with a timeout of 30 seconds
      final response = await http.get(uri, headers: headers).timeout(Duration(seconds: 30));

      // Check the response status code
      if (response.statusCode == 200) {
        // Decode the JSON response
        final responseBody = jsonDecode(response.body);

        // Check if the response contains the 'notify' key and emit success or failure
        if (responseBody.containsKey('notify') && responseBody['notify'] != null) {
          emit("Password validation successful!");
        } else {
          emit("Password validation failed.");
        }
      } else {
        emit("Server error."); // Emit an error message for server errors
      }
    } catch (e) {
      emit("Error validating password: $e"); // Emit an error message if an exception occurs
    }
  }
}