import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miaged/View/LoginView.dart';
import 'package:miaged/main.dart';
import 'package:miaged/View/HomeView.dart';
import 'package:miaged/View/CartView.dart';

class ProfileView extends StatefulWidget {
  final GLOBAL global;

  ProfileView({required this.global});

  @override
  _ProfilePageState createState() => _ProfilePageState(global: global);
}

class _ProfilePageState extends State<ProfileView> {
  final GLOBAL global;
  int _selectedIndex = 2;

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _birthdayController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  TextEditingController _cityController = TextEditingController();

  _ProfilePageState({required this.global});

  @override
  void initState() {
    super.initState();
    // Récupérer les informations du profil depuis la base de données
    getProfileInfo();
  }

  Future<void> getProfileInfo() async {
    try {
      DocumentSnapshot profileSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.global.getUserName())
          .get();

      if (profileSnapshot.exists) {
        // Récupérer les données du profil et les afficher dans les champs correspondants
        Map<String, dynamic> data =
            profileSnapshot.data() as Map<String, dynamic>;
        _passwordController.text = data['password'];
        _birthdayController.text = data['birthday'];
        _addressController.text = data['address'];
        _postalCodeController.text = data['postal_code'];
        _cityController.text = data['city'];
      }
    } catch (e) {
      print('Erreur lors de la récupération des informations du profil: $e');
    }
  }

  Future<void> updateProfileInfo() async {
    // Vérifier que les champs sont valides avant de les enregistrer
    if (!validateFields()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez remplir tous les champs correctement.'),
        ),
      );
      return;
    }

    // Vérifier le format de l'anniversaire (JJ/MM/AAAA)
    if (!isValidBirthdayFormat()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Veuillez entrer une date de naissance valide (JJ/MM/AAAA).'),
        ),
      );
      return;
    }

    // Vérifier le format du code postal (5 chiffres uniquement)
    if (!isValidPostalCodeFormat()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez entrer un code postal valide (5 chiffres).'),
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.global.getUserName())
          .set({
        'password': _passwordController.text,
        'birthday': _birthdayController.text,
        'address': _addressController.text,
        'postal_code': _postalCodeController.text,
        'city': _cityController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profil mis à jour'),
        ),
      );
    } catch (e) {
      print('Erreur lors de la mise à jour du profil: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la mise à jour du profil'),
        ),
      );
    }
  }

  bool validateFields() {
    return _passwordController.text.isNotEmpty &&
        _birthdayController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _postalCodeController.text.isNotEmpty &&
        _cityController.text.isNotEmpty;
  }

  bool isValidBirthdayFormat() {
    final RegExp regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    return regex.hasMatch(_birthdayController.text);
  }

  bool isValidPostalCodeFormat() {
    final RegExp regex = RegExp(r'^\d{5}$');
    return regex.hasMatch(_postalCodeController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profil')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(labelText: 'Login'),
              initialValue: widget.global.getUserName(),
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Mot de passe'),
            ),
            TextFormField(
              controller: _birthdayController,
              decoration: InputDecoration(labelText: 'Anniversaire'),
              keyboardType: TextInputType.datetime,
            ),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Adresse'),
            ),
            TextFormField(
              controller: _postalCodeController,
              decoration: InputDecoration(labelText: 'Code postal'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'Ville'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => updateProfileInfo(),
              child: Text('Valider'),
            ),
            ElevatedButton(
              onPressed: () {
                // Se déconnecter en revenant à la page de connexion
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginView(onLogin: (global) {})),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text('Se déconnecter'),
            ),
          ],
        ),
      ),

      //BOTTOM NAVIGATION BAR//
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sports),
            label: 'Activités',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Panier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          switch (index) {
            case 0:
              // Naviguer vers la page des activités
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeView(global: global)),
              );
              break;
            case 1:
              // Naviguer vers la page du panier
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CartView(global: global)),
              );
              break;
            case 2:
              // Naviguer vers la page du profil
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileView(global: global)),
              );
              break;
          }
        },
      ),
    );
  }
}
