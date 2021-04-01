import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'tools/constants.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Color(0xFF7B51D3),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: PageView.builder(
          itemCount: 3,
          itemBuilder: (_, i) {
            return Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/store.png',
                    height: 200,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Bem vindos \nao \n#Click Biuda',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Encontre os produtos das melhores lojas de sexshop em um só lugar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal,
                      onPrimary: Colors.white,
                      shadowColor: Colors.red,
                      elevation: 10,
                    ),
                    onPressed: () => Navigator.pushNamed(context, "/home"),
                    child: Text(
                      'Conhecer os produtos',
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
