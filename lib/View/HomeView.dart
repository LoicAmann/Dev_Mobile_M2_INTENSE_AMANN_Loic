// ignore_for_file: must_be_immutable, file_names, prefer_final_fields, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:miaged/Controller/HomeController.dart';
import 'package:miaged/View/ActivityView.dart';
import 'package:miaged/Model/ActivityModel.dart';
import 'package:miaged/View/CartView.dart';
import 'package:miaged/main.dart';
import 'package:miaged/View/ProfileView.dart';

class HomeView extends StatelessWidget {
  int _selectedIndex = 0;
  GLOBAL global;

  HomeView({required this.global});

  @override
  Widget build(BuildContext context) {
    print("HomeView started! Welcome :)");
    return Scaffold(
      appBar: AppBar(
        title: Text('Activités'),
      ),
      body: FutureBuilder<List<ActivityModel>>(
        future: HomeController(context).getActivities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Afficher un indicateur de chargement pendant le chargement des données
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Afficher un message d'erreur s'il y a une erreur lors du chargement des données
            return Center(child: Text('Erreur de chargement des activités'));
          } else {
            // Afficher la liste des activités une fois qu'elles ont été chargées avec succès
            List<ActivityModel> activities = snapshot.data ?? [];
            return ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                ActivityModel activity = activities[index];
                return ListTile(
                  leading: Image.network(activity.image),
                  title: Text(activity.titre),
                  subtitle: Text('${activity.lieu}, ${activity.prix}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActivityView(
                            activity: activity, global: global),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
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
                MaterialPageRoute(builder: (context) => HomeView(global: global)),
              );
              break;
            case 1:
              // Naviguer vers la page du panier
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartView(global: global)),
              );
              break;
            case 2:
              // Naviguer vers la page du profil
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileView(global: global)),
              );
              break;
          }
        },
      ),
    );
  }
}
