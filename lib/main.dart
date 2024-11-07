import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/Bloc/AuthenticationEvent.dart';
import 'Presentation/authenticationScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Biometric Auth Demo',
      theme: ThemeData(

      ),
      home: BlocProvider(
        create: (_) => AuthenticationEvent(),
        child: AuthenticationScreen(),
      ),

    );
  }
}
