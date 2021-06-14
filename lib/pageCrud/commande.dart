import 'package:authentification/pageCrud/listeClient.dart';
import 'package:authentification/pageCrud/commandeFinal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:authentification/pageCrud/cart_items_bloc.dart';

class Commande extends StatelessWidget {
  Commande({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map clients = ModalRoute.of(context).settings.arguments;
    void snack() {
      SnackBar snackBar = SnackBar(
        content: Text('Produit ajouté'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    CartItemsBloc ref1 = CartItemsBloc();
    CollectionReference ref = FirebaseFirestore.instance.collection('articles');
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ListeClient()));

/*                 Navigator.pushReplacement(
                    context,
                    PageTransition(
                        child: ListeClient(),
                        type: PageTransitionType.rightToLeftWithFade));
 */
              }),
          /*  Padding(
            padding: const EdgeInsets.only(left: 300.0),
          ) */
        ],
        centerTitle: true,
        title: Text(
          "Choisissez vos articles",
          style: TextStyle(color: Colors.white),
        ),
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.blue[900],
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: ref.snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                SizedBox(
                  height: 380,
                  child: ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        var doc = snapshot.data.docs[index].data();
                        var uid = snapshot.data.docs[index].id;

                        return ListTile(
                          minVerticalPadding: 16.0,
                          leading: IconButton(
                              icon: Icon(Icons.add),
                              color: Colors.grey,
                              onPressed: () {
                                ref1.addToCart(
                                    doc, uid, clients['id'], clients['nom']);
                                print(clients['id']);
                                print(ref1.allItems['cart items']);
                                snack();
                              }),
                          title: Text(
                            doc["désignation"],
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Column(
                            children: <Widget>[
                              Text(
                                doc["prix HT"].toString() + " euros",
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                doc["stock"].toString() + " en stock",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                          /* trailing: Image.network(doc['ImageUrl'],
                            height: 100, fit: BoxFit.cover, width: 100), */
                        );
                      }),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CommandeFinal(
                                allItems: ref1.allItems['cart items'])));
                  },
                  child: Container(
                    width: 250.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: Colors.blue[900],
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: Center(
                      child: Text(
                        'Voir votre panier',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                )
              ],
            );
          } else {
            return Text('Erreur de chargement');
          }
        },
      ),
    );
  }
}
