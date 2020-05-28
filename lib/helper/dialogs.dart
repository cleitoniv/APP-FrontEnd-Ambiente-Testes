import 'package:flutter/material.dart';

class Dialogs {
  static success(
    BuildContext context, {
    String title = 'Tudo certo!',
    String subtitle = 'Devolução solicitada com sucesso!',
    Function onTap,
    String buttonText = 'Confirmar Solicitação',
  }) {
    showDialog(
      context: context,
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircleAvatar(
              radius: 45,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
              child: Icon(
                Icons.check,
                color: Theme.of(context).primaryColor,
                size: 50,
              ),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 10),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 30),
            RaisedButton(
              onPressed: onTap,
              child: Text(
                buttonText,
                style: Theme.of(context).textTheme.button,
              ),
            )
          ],
        ),
      ),
    );
  }
}
