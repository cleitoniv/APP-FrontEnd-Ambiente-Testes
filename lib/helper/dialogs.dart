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

  static pacienteInfo(
    BuildContext context, {
    String title = 'Controle de paciente',
    String subtitle =
        '''Quando voce insere o nome e o CPF(opcional) do seu paciente, nos permite te auxiliar no controle da data de reavaliação!''',
    Function onTap,
    String buttonText = 'Entendi',
  }) {
    showDialog(
      context: context,
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircleAvatar(
              radius: 45,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
              child: Icon(
                Icons.assignment,
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
              textAlign: TextAlign.justify,
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

  static error(
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
              backgroundColor: Colors.red.withOpacity(0.2),
              child: Icon(
                Icons.error,
                color: Colors.red,
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
              textAlign: TextAlign.justify,
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

  static confirm(
    BuildContext context, {
    Function onConfirm,
    Function onCancel,
    String confirmText = 'Confirmar Resgate',
    String cancelText = 'Cancelar Resgate',
    String title = 'Deseja confirmarresgate de pontos?',
    String subtitle =
        'Ao confirmar iremos converter seus Pontos em Crédito Financeiro, tem certeza que deseja resgatar?',
  }) {
    List<Map> _renderButtonData(BuildContext context) {
      return [
        {
          'title': confirmText,
          'onTap': onConfirm,
          'color': Theme.of(context).accentColor,
          'textColor': Colors.white,
        },
        {
          'title': cancelText,
          'onTap': onCancel,
          'color': Color(0xffF1F1F1),
          'textColor': Theme.of(context).accentColor,
        },
      ];
    }

    showDialog(
      context: context,
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: Column(
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _renderButtonData(context).map(
            (e) {
              return Container(
                margin: const EdgeInsets.only(
                  top: 10,
                ),
                child: RaisedButton(
                  onPressed: e['onTap'],
                  elevation: 0,
                  color: e['color'],
                  child: Text(
                    e['title'],
                    style: Theme.of(context).textTheme.button.copyWith(
                          color: e['textColor'],
                        ),
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  static confirmAsync(
    BuildContext context, {
    Future<Function> onConfirm,
    Function onCancel,
    String confirmText = 'Confirmar Resgate',
    String cancelText = 'Cancelar Resgate',
    String title = 'Deseja confirmarresgate de pontos?',
    String subtitle =
        'Ao confirmar iremos converter seus Pontos em Crédito Financeiro, tem certeza que deseja resgatar?',
  }) {
    List<Map> _renderButtonData(BuildContext context) {
      return [
        {
          'title': confirmText,
          'onTap': onConfirm,
          'color': Theme.of(context).accentColor,
          'textColor': Colors.white,
        },
        {
          'title': cancelText,
          'onTap': onCancel,
          'color': Color(0xffF1F1F1),
          'textColor': Theme.of(context).accentColor,
        },
      ];
    }

    showDialog(
      context: context,
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: Column(
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _renderButtonData(context).map(
            (e) {
              return Container(
                margin: const EdgeInsets.only(
                  top: 10,
                ),
                child: RaisedButton(
                  onPressed: e['onTap'],
                  elevation: 0,
                  color: e['color'],
                  child: Text(
                    e['title'],
                    style: Theme.of(context).textTheme.button.copyWith(
                          color: e['textColor'],
                        ),
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
