import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'scope-models/main.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';

void main() => runApp(HotelApp());

class HotelApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HotelAppState();
  }
}

class _HotelAppState extends State<HotelApp> {
  MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.onAuthStateChanged.listen((FirebaseUser user) {
      if (user != null) {
        _model.authenticate(user);
        setState(() => _isAuthenticated = true);
      } else {
        setState(() => _isAuthenticated = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        title: 'HotelApp',
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.teal,
          accentColor: Colors.greenAccent,
          buttonColor: Colors.teal,
        ),
        initialRoute: '/',
        routes: {
          '/': (BuildContext context) =>
            _isAuthenticated ? HomeScreen() : LoginScreen(),
          '/register': (BuildContext context) => RegisterScreen(),
          '/home': (BuildContext context) =>
              _isAuthenticated ? HomeScreen() : LoginScreen(),
        },
        onGenerateRoute: (RouteSettings settings) {
          if (!_isAuthenticated) {
            return MaterialPageRoute(
              builder: (BuildContext context) => LoginScreen()
            );
          }
        }
      ),
    );
  }
}