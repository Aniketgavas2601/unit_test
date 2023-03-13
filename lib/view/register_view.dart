import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:unit_testing/constants/routes.dart';
import 'package:unit_testing/services/auth/auth_exceptions.dart';
import 'package:unit_testing/services/auth/auth_service.dart';
import 'package:unit_testing/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(title: const Text('Register'),),
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
                try {
                  await AuthService.firebase().createUser(
                      email: email, password: password);
                  // await FirebaseAuth.instance
                  //      .createUserWithEmailAndPassword(
                  //          email: email, password: password);

                  //final user = AuthService.firebase().currentUser;
                  //final user = FirebaseAuth.instance.currentUser;
                  //await user?.sendEmailVerification();
                  AuthService.firebase().sendEmailVerification();
                  if(mounted){
                    Navigator.of(context).pushNamed(verifyEmailRoute);
                  }
                } on WeakPasswordAuthException {
                  await showErrorDialog(context, 'weak password');
                } on EmailAlreadyInUseAuthException {
                  await showErrorDialog(context, 'email already in use');
                } on InvalidEmailAuthException{
                  await showErrorDialog(context, 'invalid email entered');
                } on GenericAuthException {
                  await showErrorDialog(context, 'Failed to register');
                }
                // } on FirebaseAuthException catch (e) {
                //   if (e.code == 'weak-password') {
                //     log('weak password');
                //     await showErrorDialog(context, 'weak password');
                //   } else if (e.code == 'email-already-in-use') {
                //     log('email already in use');
                //     await showErrorDialog(context, 'email already in use');
                //   } else if (e.code == 'invalid-email') {
                //     log('invalid email entered');
                //     await showErrorDialog(context, 'invalid email entered');
                //   } else {
                //     await showErrorDialog(context, 'Error: ${e.code}');
                //   }
                // } catch (e){
                //   await showErrorDialog(context, e.toString());
                // }
              },
              child: const Text('Register')),
          TextButton(onPressed: (){
            Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
          }, child: const Text('Already registered? login here!'))
        ],
      ),
    );
  }
}
