import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miaged/Model/ActivityModel.dart';

class HomeController {
  final BuildContext context;

  HomeController(this.context);

  Future<List<ActivityModel>> getActivities() async {
    List<ActivityModel> activities = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Activities').get();

      querySnapshot.docs.forEach((activity) {
        activities.add(ActivityModel(
          id: activity['Id'],
          image: activity['Image'],
          titre: activity['Titre'],
          categorie: activity['Catégorie'],
          lieu: activity['Lieu'],
          nombreDePersonne: activity['Nombre de personne'],
          prix: activity['Prix'],
        ));
        print(activity['Titre'] + " added to the list !");
      });
      print("Activities fetched successfully !");
    } catch (e) {
      print('Error fetching activities: $e');
    }

    return activities;
  }
}
