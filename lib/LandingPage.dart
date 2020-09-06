import 'file:///C:/Users/guin%20wilson/AndroidStudioProjects/firebase_app_course/lib/jobs/JobsPage.dart';
import 'package:firebaseappcourse/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'FirebasePage.dart';
import 'app/sign_in/sign_in_page.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user == null) {
              return SignInPage.create(context);
            }
            return Provider<Database>(
                create: (_) => FirestoreDatabase(uid: user.uid),
                child: JobsPage());
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
