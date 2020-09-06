import 'package:firebaseappcourse/FirebasePage.dart';
import 'package:firebaseappcourse/app/sign_in/platform_alert_dialogue.dart';
import 'package:firebaseappcourse/app/sign_in/validators.dart';
import 'package:firebaseappcourse/reused_widgets/sign_in_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'platform_exception_alert_dialog.dart';
import 'email_sign_in_model.dart';

class EmailSignInFormStateful extends StatefulWidget
    with EmailAndPasswordValidators {
  @override
  _EmailSignInFormStatefulState createState() =>
      _EmailSignInFormStatefulState();
}

class _EmailSignInFormStatefulState extends State<EmailSignInFormStateful> {
  EmailSignInFormType _formType = EmailSignInFormType.register;

  final TextEditingController _emailSignIn = TextEditingController();
  final TextEditingController _passwordSignIn = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailSignIn.text;
  String get _password => _passwordSignIn.text;

  bool _submitted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailSignIn.dispose();
    _passwordSignIn.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(
            email: _email, password: _password);
      } else {
        await auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
      }
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign in Failed',
        exception: e,
      ).show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleFormType() {
    setState(() {
      _submitted = false;
      _formType = _formType == EmailSignInFormType.register
          ? _formType = EmailSignInFormType.signIn
          : _formType = EmailSignInFormType.register;
    });
    _emailSignIn.clear();
    _passwordSignIn.clear();
  }

  void _changeFocusNode() {
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buildChildren() {
    final String buttonText = _formType == EmailSignInFormType.register
        ? 'Create account'
        : 'Sign In';
    final String underneathText = _formType == EmailSignInFormType.register
        ? 'Already have an account? Sign In'
        : 'Need an account? Register';

    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;

    return [
      _buildEmailTextField(),
      SizedBox(height: 8.0),
      _buildPasswordTextField(),
      SizedBox(height: 30.0),
      SignInButton(
        buttonColor: Colors.indigo,
        buttonText: buttonText,
        textColor: Colors.white,
        specificPadding: 8.0,
        textSize: 18.0,
        whenPressed: submitEnabled ? _submit : null,
      ),
      FlatButton(
        child: Text(underneathText),
        onPressed: _isLoading
            ? null
            : () {
                _toggleFormType();
              },
      )
    ];
  }

  TextField _buildEmailTextField() {
//    bool emailValid = widget.emailValidator.isValid(_email);
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);

    return TextField(
      autocorrect: false,
      controller: _emailSignIn,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: showErrorText ? widget.emailErrorMessage : null,
        enabled: _isLoading == false,
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (email) => _updateState(),
      focusNode: _emailFocusNode,
      onEditingComplete: _changeFocusNode,
    );
  }

  TextField _buildPasswordTextField() {
    bool showErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);
//    bool passwordValid = widget.passwordValidator.isValid(_password);
    return TextField(
      controller: _passwordSignIn,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? widget.passwordErrorMessage : null,
        enabled: _isLoading == false,
      ),
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      onEditingComplete: _submit,
      onChanged: (password) => _updateState(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }

  void _updateState() {
    print('this is working. email $_email. password $_password');
    setState(() {});
  }
}
