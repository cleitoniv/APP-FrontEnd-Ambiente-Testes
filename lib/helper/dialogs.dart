import 'package:flutter/material.dart';

class Dialogs {
  static success(BuildContext context,
      {String title = 'Tudo certo!',
      String subtitle = 'Devolução solicitada com sucesso!',
      Function onTap,
      String buttonText = 'Confirmar Solicitação',
      bool barrierDismissible = false}) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
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
            ElevatedButton(
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

  static successWithWillPopScope(BuildContext context,
      {String title = 'Tudo certo!',
      String subtitle = 'Devolução solicitada com sucesso!',
      Function onTap,
      String buttonText = 'Confirmar Solicitação',
      bool barrierDismissible = false}) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
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
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.2),
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
              ElevatedButton(
                onPressed: onTap,
                child: Text(
                  buttonText,
                  style: Theme.of(context).textTheme.button,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  static pacienteInfo(
    BuildContext context, {
    String title = 'Identificação do paciente',
    String subtitle =
        '''Quando você  preenche a identificação do paciente, você receberá o seu pedido com esta referência''',
    Function onTap,
    String buttonText = 'Entendi',
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
              FittedBox(child: Text(
                title,
                style: Theme.of(context).textTheme.headline5,
              ),
            ), 
            SizedBox(height: 10),
            Text(
              subtitle,
              textAlign: TextAlign.justify,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 30),
            ElevatedButton(
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

  static creditsInfo(
    BuildContext context, {
    String financeiroInfo = '',
    String produtoInfo = '',
    Function onTap,
    String buttonText = 'Entendi',
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      radius: 12,
                      child: Icon(
                        Icons.attach_money,
                        color: Colors.white,
                        )
                      ),
                      SizedBox(width: 5,),
                    Text('Crédito Financeiro:', style: TextStyle(color: Colors.cyan),),
                  ],
                ),
                Text(
                  financeiroInfo,
                  // textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: 30),
            Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                              backgroundColor: Color(0xffEFC75E),
                              radius: 12,
                              child: Image.asset(
                              'assets/icons/open_box.png',
                              width: 15,
                              height: 15,
                              color: Colors.white,
                            ),
                    ),
                    SizedBox(width: 5,),
                    Text('Crédito de Produto:', style: TextStyle(color: Colors.cyan),),
                  ],
                ),
                Text(
                  produtoInfo,
                  // textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton(
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

  static patientControlInfo(
    BuildContext context, {
    String message = '',
    Function onTap,
    String buttonText = 'OK',
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Column(
              children: [
                Text(
                  message,
                  // textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            ElevatedButton(
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

  static errorWithWillPopScope(
    BuildContext context, {
    String title = 'Tudo certo!',
    bool barrierDismissible = false,
    String subtitle = 'Devolução solicitada com sucesso!',
    Function onTap,
    String buttonText = 'Confirmar Solicitação',
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
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
              ElevatedButton(
                onPressed: onTap,
                child: Text(
                  buttonText,
                  style: Theme.of(context).textTheme.button,
                ),
              )
            ],
          ),
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
      barrierDismissible: false,
      builder: (context) => AlertDialog(
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
            ElevatedButton(
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

  static onlyConfirmbutton(
    BuildContext context, {
    Function onConfirm,
    Widget info,
    String confirmText = 'Texto de confirmação',
    String title = 'Titulo do botão',
    String subtitle = 'sub-titulo do botão',
    bool barrierDismissible = false,
  }) {
    List<Map> _renderButtonData(BuildContext context) {
      return [
        {
          'title': confirmText,
          'onTap': onConfirm,
          'color': Theme.of(context).accentColor,
          'textColor': Colors.white,
        }
      ];
    }

    showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: Column(
          children: <Widget>[
            FittedBox(
              fit: BoxFit.contain,
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [info] + _renderButtonData(context).map(
            (e) {
              return Container(
                margin: const EdgeInsets.only(
                  top: 1,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 35),
                      elevation: 0, primary: e['color']
                  ),
                  onPressed: e['onTap'],
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      e['title'],
                      style: Theme.of(context).textTheme.button.copyWith(
                            color: e['textColor'],
                          ),
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

  static confirmWithInfo(
    BuildContext context, {
    Function onConfirm,
    Function onCancel,
    Widget info,
    String confirmText = 'Confirmar Resgate',
    String cancelText = 'Cancelar Resgate',
    String title = 'Deseja confirmarresgate de pontos?',
    String subtitle =
        'Ao confirmar iremos converter seus Pontos em Crédito Financeiro, tem certeza que deseja resgatar?',
    bool barrierDismissible = false,
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
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: Column(
          children: <Widget>[
            FittedBox(
              fit: BoxFit.contain,
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [info] + _renderButtonData(context).map(
            (e) {
              return Container(
                margin: const EdgeInsets.only(
                  top: 1,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 35),
                      elevation: 0, primary: e['color']
                  ),
                  onPressed: e['onTap'],
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      e['title'],
                      style: Theme.of(context).textTheme.button.copyWith(
                            color: e['textColor'],
                          ),
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

  static confirm(
    BuildContext context, {
    Function onConfirm,
    Function onCancel,
    String confirmText = 'Confirmar Resgate',
    String cancelText = 'Cancelar Resgate',
    String title = 'Deseja confirmarresgate de pontos?',
    String subtitle =
        'Ao confirmar iremos converter seus Pontos em Crédito Financeiro, tem certeza que deseja resgatar?',
    bool barrierDismissible = false,
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
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: Column(
          children: <Widget>[
            FittedBox(
              fit: BoxFit.contain,
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
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
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0, primary: e['color']),
                  onPressed: e['onTap'],
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      e['title'],
                      style: Theme.of(context).textTheme.button.copyWith(
                            color: e['textColor'],
                          ),
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
      builder: (context) => AlertDialog(
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
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0, primary: e['color']),
                  onPressed: e['onTap'],
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
