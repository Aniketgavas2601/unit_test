import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:unit_testing/constants/routes.dart';
import 'package:unit_testing/services/auth/auth_service.dart';
import 'package:unit_testing/view/login_view.dart';
import 'package:unit_testing/view/notes_view.dart';
import 'package:unit_testing/view/register_view.dart';
import 'package:unit_testing/view/verify_email_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        loginRoute: (context) => LoginView(),
        registerRoute: (context) => RegisterView(),
        notesRoute: (context) => NotesView(),
        verifyEmailRoute: (context) => VerifyEmailView()
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if(user.isEmailVerified){
                return NotesView();
              }else{
                return VerifyEmailView();
              }
              return Text('Inside If');
            } else {
              return LoginView();
            }
          default:
            return CircularProgressIndicator();
        }
      },
    );
  }
}

