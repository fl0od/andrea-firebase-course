import 'package:firebaseappcourse/FirebasePage.dart';
import 'package:firebaseappcourse/app/sign_in/email_sign_in_form_stateful.dart';
import 'package:firebaseappcourse/app/sign_in/validators.dart';
import 'package:flutter/cupertino.dart';

import 'email_sign_in_model.dart';

class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  EmailSignInChangeModel({
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
    @required this.auth,
  });

  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;
  final AuthBase auth;

  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
  }

  void updateEmail(String email) {
    updateWith(email: email);
  }

  void updatePassword(String password) {
    updateWith(password: password);
  }

  void toggleFormType() {
    updateWith(
      email: '',
      password: '',
      formType: this.formType == EmailSignInFormType.register
          ? EmailSignInFormType.signIn
          : EmailSignInFormType.register,
      submitted: false,
      isLoading: false,
    );
  }

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        await auth.createUserWithEmailAndPassword(
            email: email, password: password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String get primaryButtonText {
    return formType == EmailSignInFormType.register
        ? 'Create account'
        : 'Sign In';
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.register
        ? 'Already have an account? Sign In'
        : 'Need an account? Register';
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  String get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? emailErrorMessage : null;
  }

  String get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? passwordErrorMessage : null;
  }
}
