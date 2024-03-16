import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miaged/main.dart';
import 'package:miaged/Model/ActivityModel.dart';
import 'package:miaged/View/HomeView.dart';
import 'package:miaged/View/ProfileView.dart';

class CartView extends StatefulWidget {
  final GLOBAL global;

  CartView({required this.global});

  @override
  _CartViewState createState() => _CartViewState(global: global);
}

class _CartViewState extends State<CartView> {
  GLOBAL global = GLOBAL();
  int _selectedIndex = 1;

  _CartViewState({required this.global});

  @override
  Widget build(BuildContext context) {
    print("CartView started! Welcome :)");
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Panier'),
      ),
      body: FutureBuilder(
          future: getCartActivities(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : snapshot.hasError
                    ? Center(child: Text('Une erreur s\'est produite.'))
                    : buildCartList(snapshot.data ?? []);
          }),

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

  Future<List<ActivityModel>> getCartActivities() async {
    List<ActivityModel> cartActivities = [];

    try {
      DocumentSnapshot cartSnapshot = await FirebaseFirestore.instance
          .collection('Panier')
          .doc(global.getUserName())
          .get();
      print(cartSnapshot.data());

      if (cartSnapshot.exists) {
        List<int> activityIds = List<int>.from(cartSnapshot['Activities']);

        //On récupère les activités de la collection 'Activities'
        QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance.collection('Activities').get();

        //On fait une correspondance entre les activités de la collection 'Activities' et les activités du panier pour les afficher
        querySnapshot.docs.forEach((activity) {
          if (activityIds.contains(activity['Id'])) {
            cartActivities.add(ActivityModel(
              id: activity['Id'],
              image: activity['Image'],
              titre: activity['Titre'],
              categorie: activity['Catégorie'],
              lieu: activity['Lieu'],
              nombreDePersonne: activity['Nombre de personne'],
              prix: activity['Prix'],
            ));
            print(activity['Titre'] + " added to the list !");
          }
        });
      }
    } catch (e) {
      print('Error fetching cart activities: $e');
    }

    return cartActivities;
  }

  Widget buildCartList(List<ActivityModel> cartActivities) {
    int total = cartActivities.fold(0, (sum, activity) => sum + activity.prix);

    return cartActivities.isEmpty
        ? Center(child: Text('Votre panier est vide.'))
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartActivities.length,
                  itemBuilder: (context, index) {
                    ActivityModel activity = cartActivities[index];
                    return ListTile(
                      leading: Image.network(activity.image),
                      title: Text(activity.titre),
                      subtitle: Text('${activity.lieu}, ${activity.prix}€'),
                      trailing: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => removeFromCart(activity),
                      ),
                    );
                  },
                ),
              ),
              Divider(),
              ListTile(
                title: Text('Total'),
                trailing: Text('$total€'),
              ),
            ],
          );
  }

  Future<void> removeFromCart(ActivityModel activity) async {
    try {
      await FirebaseFirestore.instance
          .collection('Panier')
          .doc(global.getUserName())
          .update({
        'Activities': FieldValue.arrayRemove([activity.id]),
      });
      print("Activity removed from the cart !");

      // Appel de la méthode pour mettre à jour la liste des activités dans le panier
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CartView(global: global)),
      );
    } catch (e) {
      print('Error: $e');
    }
  }
}
