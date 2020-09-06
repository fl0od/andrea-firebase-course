import 'dart:async';

import 'package:firebaseappcourse/FirebasePage.dart';
import 'package:firebaseappcourse/app/sign_in/email_sign_in_model.dart';
import 'package:flutter/foundation.dart';

class EmailSignInBloc {
  EmailSignInBloc({@required this.auth});
  final AuthBase auth;

  StreamController<EmailSignInModel> _modelController =
      StreamController<EmailSignInModel>();

  Stream<EmailSignInModel> get modelStream => _modelController.stream;

  EmailSignInModel _model = EmailSignInModel();

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(
            email: _model.email, password: _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(
            email: _model.email, password: _model.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
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
      formType: _model.formType == EmailSignInFormType.register
          ? EmailSignInFormType.signIn
          : EmailSignInFormType.register,
      submitted: false,
      isLoading: false,
    );
  }

  void dispose() {
    _modelController.close();
  }

  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    _model = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    );
    _modelController.add(_model);
  }
}
