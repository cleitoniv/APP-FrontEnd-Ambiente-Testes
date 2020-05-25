import 'package:central_oftalmica_app_cliente/blocs/intro_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  IntroBloc _introBloc = Modular.get<IntroBloc>();
  PageController _pageController;

  List<Map> _slides = [
    {
      'id': 0,
      'image': 'assets/images/intro_0.png',
      'title': 'A melhor tecnologia para sua visão',
      'subtitle':
          'Nosso aplicativo tem como objetivo facilitar a compra e gestão dos nossos produtos para profissionais que trabalham com lentes de contato.',
    },
    {
      'id': 1,
      'image': 'assets/images/intro_1.png',
      'title': 'Crédito Financeiro, Crédito de Produto e Compra Avulsa',
      'subtitle':
          'Três formas de compra, possibilitando você a gerenciar suas lentes da melhor forma.',
    },
    {
      'id': 2,
      'image': 'assets/images/intro_2.png',
      'title': 'Pedidos categorizados por pacientes',
      'subtitle':
          'Categorizando por paciente, você controla o lote das lentes e a data de reavaliação ou reposição. Isto faz você acumular pontos para comprar mais produtos.',
    }
  ];

  _handleContinue() {
    Modular.to.popUntil((route) => route.isFirst);
    Modular.to.pushReplacementNamed('/auth/login');
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
      body: StreamBuilder<int>(
          stream: _introBloc.currentSlideOut,
          builder: (context, snapshot) {
            return Stack(
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
                snapshot.data == 2
                    ? Positioned(
                        bottom: 25,
                        right: 20,
                        child: GestureDetector(
                          onTap: _handleContinue,
                          child: Text(
                            'Continuar',
                            style:
                                Theme.of(context).textTheme.subtitle2.copyWith(
                                      fontWeight: FontWeight.w900,
                                    ),
                          ),
                        ),
                      )
                    : Container(),
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
                          child: CircleAvatar(
                            radius: snapshot.data == e['id'] ? 5 : 4,
                            backgroundColor: snapshot.data == e['id']
                                ? Colors.white
                                : Colors.white54,
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
