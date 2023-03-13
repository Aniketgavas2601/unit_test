import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:unit_testing/constants/routes.dart';
import 'package:unit_testing/services/auth/auth_exceptions.dart';
import 'package:unit_testing/services/auth/auth_service.dart';
import 'package:unit_testing/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Enter Your Email here'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'Enter Your Password here'),
          ),
          TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try{
                  await AuthService.firebase().login(email: email, password: password);
                  //await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                  //final user = FirebaseAuth.instance.currentUser;
                  final user = AuthService.firebase().currentUser;
                  if(user?.isEmailVerified ?? false){
                    //user email is verified
                    if(mounted){
                      Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false);
                    }
                  }else {
                    // user email is not verified
                    if(mounted){
                      Navigator.of(context).pushNamedAndRemoveUntil(verifyEmailRoute, (route) => false);
                    }
                  }
                  //log(userCredential.toString());
                  log("not waiting");
                } on UserNotFoundAuthException {
                  log('user not found');
                  await showErrorDialog(context, 'user not found');
                } on WrongPasswordAuthException {
                  log('Wrong password');
                  await showErrorDialog(context, 'Wrong password');
                } on GenericAuthException {
                  await showErrorDialog(context, 'Authentication Error');
                }
              },
              child: const Text('Login')),
          TextButton(onPressed: (){
            Navigator.of(context).pushNamedAndRemoveUntil('/register/', (route) => false);
          }, child: const Text('Not Register yet? Register here!'))
        ],
      ),
    );
  }
}