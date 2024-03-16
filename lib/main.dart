import 'package:flutter/material.dart';
import 'package:miaged/View/LoginView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Classe singleton GLOBAL pour stocker des données globales
// A vrai dire, c'est pas la meilleure façon de faire, mais c'est pour tester
// J'avais déjà le model User donc c'est vraiment pas util
class GLOBAL {
  String _userName = '';

  String getUserName() => _userName;
  void setUserName(String userName) => _userName = userName;
}

void main() async {
  // Initialisation de Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

// ignore: must_be_immutable
class MainApp extends StatelessWidget {
  const MainApp({super.key}); // Instance de la classe GLOBAL

  @override
  Widget build(BuildContext context) {
    print("MainApp started! Welcome :)");

    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginView(
        onLogin: (GLOBAL global) {},
      ),
    );
  }
}
