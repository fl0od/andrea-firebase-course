import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  SignInButton({
    this.buttonColor,
    this.imageAssetPosition,
    this.buttonText,
    this.textColor = Colors.black,
    this.specificPadding,
    this.whenPressed,
    this.textSize = 15.0,
  });
  final Color buttonColor;
  final String imageAssetPosition;
  final String buttonText;
  final Color textColor;
  final double specificPadding;
  final Function whenPressed;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0, bottom: 10.0, left: 20.0),
      child: RaisedButton(
        color: buttonColor,
        disabledColor: buttonColor,
        padding: EdgeInsets.only(
            top: specificPadding,
            bottom: specificPadding,
            left: specificPadding,
            right: specificPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset('$imageAssetPosition'),
            Text(
              '$buttonText',
              style: TextStyle(
                fontSize: textSize,
                color: textColor,
              ),
            ),
            Opacity(
              opacity: 0.0,
              child: Image.asset('$imageAssetPosition'),
            ),
          ],
        ),
        onPressed: whenPressed,
      ),
    );
  }
}
