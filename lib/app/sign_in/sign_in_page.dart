import 'package:firebaseappcourse/app/sign_in/ign_in_with_email.dart';
import 'package:firebaseappcourse/app/sign_in/platform_exception_alert_dialog.dart';
import 'package:firebaseappcourse/app/sign_in/sign_in_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebaseappcourse/reused_widgets/sign_in_buttons.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../FirebasePage.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.manager, @required this.isLoading})
      : super(key: key);
  final SignInManager manager;
  final bool isLoading;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (context, manager, _) => SignInPage(
              manager: manager,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  void _signInWithEmail(BuildContext context) async {
//    bloc.setIsLoading(true);
    await Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (context) => SignInWithEmail(),
    ));
//    bloc.setIsLoading(false);
    //TODO: Show emil sign in page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Time Tracker'),
        ),
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.grey[100],
        child: Center(
          child: Column(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(height: 150),
              SizedBox(
                height: 50.0,
                child: buildHeader(),
              ),
              SizedBox(height: 50),
              SignInButton(
                buttonColor: Colors.white,
                imageAssetPosition: 'Images/google-logo.png',
                buttonText: 'Sign in with Google',
                textColor: Colors.black87,
                specificPadding: 10.0,
                whenPressed: isLoading
                    ? null
                    : () {
                        _signInWithGoogle(context);
                      },
              ),
              SignInButton(
                buttonColor: Color(0xFF4066B1),
                imageAssetPosition: 'Images/facebook-logo.png',
                buttonText: 'Fuck Facebook',
                textColor: Colors.white,
                specificPadding: 10.0,
              ),
              SignInButton(
                  buttonColor: Color(0xFF21836B),
                  buttonText: 'Sign in with email',
                  textColor: Colors.white,
                  specificPadding: 15.0,
                  whenPressed: isLoading
                      ? null
                      : () {
                          _signInWithEmail(context);
                        }),
              Text(
                'OR',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              SignInButton(
                  buttonColor: Color(0xFFDDEC7C),
                  buttonText: 'Go anonymous',
                  textColor: Colors.black87,
                  specificPadding: 15.0,
                  whenPressed: isLoading
                      ? null
                      : () {
                          _signInAnonymously(context);
                        }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      'Sign in',
      style: TextStyle(
        fontSize: 40.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
