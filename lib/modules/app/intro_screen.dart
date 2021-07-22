import 'package:central_oftalmica_app_cliente/blocs/intro_widget_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  IntroWidgetBloc _introBloc = Modular.get<IntroWidgetBloc>();
  PageController _pageController;

  List<Map> _slides = [
    {
      'id': 0,
      'image': 'assets/images/intro_0.png',
      'title': 'Mais tecnologia para a visão',
      'subtitle':
          'Nosso aplicativo simplifica o controle dos usuários e produtos para quem trabalha com lentes de contato',
    },
    {
      'id': 1,
      'image': 'assets/images/intro_1.png',
      'title': 'Crédito Financeiro, Crédito de Produto e Compra Avulsa',
      'subtitle':
          'Três maneiras de comprar, possibilitando você a gerenciar suas lentes de contato de forma mais dinâmica',
    },
    {
      'id': 2,
      'image': 'assets/images/intro_2.png',
      'title': 'Pedidos com controle por usuários',
      'subtitle':
          'Categorizando por usuário, você controla o lote das lentes e a data de reavaliação e reposição. Isto faz você acumular pontos para compras futuras',
    }
  ];

  _handleContinue() {
    Modular.to.popUntil((route) => route.isFirst);
    Modular.to.pushReplacementNamed('/auth/login');
    // Modular.to.navigate("/auth/login");
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            onPageChanged: (int index) {
              _introBloc.currentSlideIn.add(index);
            },
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage(
                      _slides[index]['image'],
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        _slides[index]['title'],
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        _slides[index]['subtitle'],
                        style: Theme.of(context).textTheme.subtitle2,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          StreamBuilder<int>(
              stream: _introBloc.currentSlideOut,
              builder: (context, snapshot) {
                print(snapshot.data);
                return Positioned(
                  bottom: 25,
                  right: 20,
                  child: snapshot.data == 2
                      ? GestureDetector(
                          onTap: _handleContinue,
                          child: Text(
                            'Continuar',
                            style:
                                Theme.of(context).textTheme.subtitle2.copyWith(
                                      fontWeight: FontWeight.w900,
                                    ),
                          ),
                        )
                      : Container(),
                );
              }),
          Positioned(
            bottom: 30,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _slides.map(
                (e) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 2,
                    ),
                    child: StreamBuilder<int>(
                        stream: _introBloc.currentSlideOut,
                        builder: (context, snapshot) {
                          return CircleAvatar(
                            radius: snapshot.data == e['id'] ? 5 : 4,
                            backgroundColor: snapshot.data == e['id']
                                ? Colors.white
                                : Colors.white54,
                          );
                        }),
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
