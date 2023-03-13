import 'package:flutter/material.dart';
import 'package:unit_testing/constants/routes.dart';
import 'package:unit_testing/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('verify email'),
      ),
      body: Column(
        children: [
          const Text("we've sent you an email verification. please open it to your account."),
          const Text('If you have not recived a verification email yet, press the button below'),
          TextButton(onPressed: () async {
            //final user = FirebaseAuth.instance.currentUser;
            //await user?.sendEmailVerification();
            AuthService.firebase().sendEmailVerification();
          }, child: const Text('send email verification')),
          TextButton(onPressed: () async {
            //await FirebaseAuth.instance.signOut();
            await AuthService.firebase().logOut();
            if(mounted){
              Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
            }
          }, child: const Text('Restart'))
        ],
      ),
    );
  }
}