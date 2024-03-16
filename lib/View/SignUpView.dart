import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miaged/View/LoginView.dart';
import 'package:miaged/main.dart';

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  Future<bool> validateFields(BuildContext context) async {
    String username = usernameController.text;
    String password = passwordController.text;
    String birthday = birthdayController.text;
    String address = addressController.text;
    String postalCode = postalCodeController.text;
    String city = cityController.text;

    // Vérifier que les champs ne sont pas vides
    if (username.isEmpty ||
        password.isEmpty ||
        birthday.isEmpty ||
        address.isEmpty ||
        postalCode.isEmpty ||
        city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tous les champs sont requis.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    // Valider le format de la date de naissance (JJ/MM/AAAA)
    final RegExp birthdayRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!birthdayRegex.hasMatch(birthday)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Format de la date de naissance incorrect.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    // Valider le format du code postal (int de 5 chiffres)
    final RegExp postalCodeRegex = RegExp(r'^\d{5}$');
    if (!postalCodeRegex.hasMatch(postalCode)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Format du code postal incorrect.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Nom d\'utilisateur déjà pris.'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } catch (e) {
      print('Erreur lors de la vérification du nom d\'utilisateur : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Erreur lors de la vérification du nom d\'utilisateur.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    // Tous les champs sont valides
    print("Tous les champs sont valides. On peut enregistrer le user.");
    return true;
  }

  Future<void> saveUser() async {
    try {
      // Obtenez une référence au document avec le nom d'utilisateur comme identifiant
      final userDocRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(usernameController.text);

      // Enregistrez les données de l'utilisateur dans ce document
      await userDocRef.set({
        'username': usernameController.text,
        'password': passwordController.text,
        'birthday': birthdayController.text,
        'address': addressController.text,
        'postalCode': postalCodeController.text,
        'city': cityController.text,
      });

      print('Utilisateur enregistré avec succès dans la base de données.');
    } catch (e) {
      print('Erreur lors de l\'enregistrement de l\'utilisateur : $e');
      // Gérez les erreurs éventuelles ici
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: birthdayController,
              decoration: InputDecoration(labelText: 'Birthday (JJ/MM/AAAA)'),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: postalCodeController,
              decoration: InputDecoration(labelText: 'Postal Code'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: cityController,
              decoration: InputDecoration(labelText: 'City'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (await validateFields(context)) {
                  saveUser();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginView(
                        onLogin: (GLOBAL global) {},
                      ),
                    ),
                  );
                }
              },
              child: Text('S\'inscrire'),
            ),
          ],
        ),
      ),
    );
  }
}
