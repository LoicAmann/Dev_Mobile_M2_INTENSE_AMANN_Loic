// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:miaged/Model/ActivityModel.dart';
import 'package:miaged/View/CartView.dart';
import 'package:miaged/View/HomeView.dart';
import 'package:miaged/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityView extends StatelessWidget {
  final ActivityModel activity;
  GLOBAL global;
  int _selectedIndex = 0; //bottom bar index

  ActivityView({required this.activity, required this.global});

  @override
  Widget build(BuildContext context) {
    print("ActivityView started! Welcome :)");
    print("Activity: ${activity.titre}" + " Activity ID: ${activity.id}");
    return Scaffold(
      appBar: AppBar(
        title: Text(activity.titre),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(activity.image),
          Text('Catégorie: ${activity.categorie}'),
          Text('Lieu: ${activity.lieu}'),
          Text('Nombre minimum de personnes: ${activity.nombreDePersonne}'),
          Text('Prix: ${activity.prix}'),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  addActivityToCart(global, activity.id);
                  Future.delayed(Duration(seconds: 1)).then((_) { //delay pour laisser la bdd se mettre à jour
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CartView(global: global)),
                    );
                  });
                },
                child: Text('Ajouter au panier'),
              ),
            ],
          ),
        ],
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
            // case 2:
            //   // Naviguer vers la page du profil
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => ProfileView(userName: global.getUserName())),
            //   );
            //   break;
          }
        },
      ),
    );
  }

  void addActivityToCart(GLOBAL global, int activityId) async {
    try {
      // Récupérer une référence au document du panier de l'utilisateur
      DocumentReference cartRef = FirebaseFirestore.instance
          .collection('Panier')
          .doc(global.getUserName());

      print(
          "Ajout de l'activité $activityId au panier de l'utilisateur ${global.getUserName()}");
      print("Référence du panier: $cartRef");

      // Vérifier si le panier de l'utilisateur existe déjà
      DocumentSnapshot cartSnapshot = await cartRef.get();

      if (cartSnapshot.exists) {
        // Mettre à jour le panier de l'utilisateur en ajoutant l'activité
        print("Mise à jour du panier de l'utilisateur ${global.getUserName()}");
        cartRef.update({
          'Activities': FieldValue.arrayUnion([activityId]),
        });
      } else {
        // Si le panier n'existe pas, créer un nouveau panier pour l'utilisateur
        print(
            "Création d'un nouveau panier pour l'utilisateur ${global.getUserName()}");
        createCartForUser(global.getUserName(), [activityId]);
      }
    } catch (e) {
      // Gérer les erreurs éventuelles ici
      print('Error: $e');
    }
  }

  void createCartForUser(String userName, List<int> activityIds) async {
    try {
      // Créer un nouveau document pour le panier de l'utilisateur avec les activités
      await FirebaseFirestore.instance.collection('Panier').doc(userName).set({
        'UserName': userName,
        'Activities': activityIds,
      });
    } catch (e) {
      // Gérer les erreurs éventuelles ici
      print('Error: $e');
    }
  }
}
