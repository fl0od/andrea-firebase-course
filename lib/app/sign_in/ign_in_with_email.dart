import 'package:firebaseappcourse/app/sign_in/email_sign_in_form_bloc_based.dart';
import 'package:firebaseappcourse/app/sign_in/email_sign_in_form_change_notifier.dart';
import 'package:firebaseappcourse/app/sign_in/email_sign_in_form_stateful.dart';
import 'package:flutter/material.dart';

class SignInWithEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Sign in'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(top: 25.0, right: 16.0, bottom: 0.0, left: 16.0),
          child: Card(
            child: EmailSignInFormChangeNotifier.create(context),
          ),
        ),
      ),
    );
  }
}
