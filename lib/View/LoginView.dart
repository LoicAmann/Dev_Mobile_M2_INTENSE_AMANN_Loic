import 'package:flutter/material.dart';
import 'package:miaged/Model/UserModel.dart';
import 'package:miaged/View/HomeView.dart';
import 'package:miaged/View/SignUpView.dart';
import 'package:miaged/main.dart';
import 'package:miaged/Controller/LoginController.dart';

// ignore: must_be_immutable
class LoginView extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Function(GLOBAL) onLogin;
  GLOBAL global = GLOBAL();

  LoginView({required this.onLogin});

  @override
  Widget build(BuildContext context) {
    print("You are in the logging page.");

    void navigateToHome() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeView(global: global),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Login'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                this.global.setUserName(usernameController.text);
                print("User registred for checking : " +
                    this.global.getUserName());
                String password = passwordController.text;
                UserModel user = UserModel(
                    username: this.global.getUserName(), password: password);
                print("We are checking your information...");
                LoginController(context, navigateToHome, global)
                    .loginUser(user, global);
                onLogin(global);
              },
              child: Text('Se connecter'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpView()),
                );
              },
              child: Text('S\'inscrire'),
            ),
          ],
        ),
      ),
    );
  }
}
