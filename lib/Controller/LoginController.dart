import 'package:flutter/material.dart';
import 'package:miaged/Model/UserModel.dart';
import 'package:miaged/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginController {
  final BuildContext context;
  final VoidCallback navigateToHome;
  GLOBAL global = GLOBAL();

  LoginController(
    this.context,
    this.navigateToHome,
    this.global,
  );

  Future<void> loginUser(UserModel myUser, GLOBAL global) async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    try {
      QuerySnapshot querySnapshot = await users.get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        // Vérifier si le nom du document correspond au nom d'utilisateur
        if (doc.id == global.getUserName() &&
            doc['password'] == myUser.password) {
          // Utilisateur trouvé, effectuer une action
          print('User found in Firestore');
          navigateToHome();
          return; // Sortir de la boucle après avoir trouvé l'utilisateur
        }
      }
      if (myUser.password == '' || global.getUserName() == '') {
        print('User or password is null');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Le login ou le mot de passe est vide.'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        print('User not found in Firestore');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Nom d\'utilisateur ou mot de passe incorrect.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error accessing Firestore: $e');
    }
  }
}
