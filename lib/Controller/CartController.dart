import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miaged/main.dart';

class CartController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  GLOBAL global = GLOBAL();

  CartController(this.global);

  Future<void> addToBag(GLOBAL global, String activityId) async {
    try {
      // Récupérer le document du panier de l'utilisateur
      DocumentReference userDocRef =
          _firestore.collection('Panier').doc(global.getUserName());
      DocumentSnapshot userDoc = await userDocRef.get();

      // Vérifier si le document existe déjà
      if (userDoc.exists) {
        // Si le document existe, mettre à jour la liste des activités dans le panier
        await userDocRef.update({
          'activites': FieldValue.arrayUnion([activityId]),
        });
      } else {
        // Si le document n'existe pas, créer un nouveau document pour l'utilisateur
        await userDocRef.set({
          'activites': [activityId],
        });
      }

      print('Activité ajoutée au panier avec succès !');
    } catch (e) {
      print('Erreur lors de l\'ajout de l\'activité au panier: $e');
      throw e;
    }
  }
}
