import 'package:authentification/models/commandes.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:authentification/pageCrud/listeCommande.dart';

class DetailsCommande extends StatefulWidget {
  @override
  _DetailsCommandeState createState() => _DetailsCommandeState();
}

class _DetailsCommandeState extends State<DetailsCommande> {
  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context).settings.arguments;
    final Commande commande = Commande();

    CollectionReference com =
        FirebaseFirestore.instance.collection('commandes');

    return Scaffold(
      appBar: AppBar(
        title: Text("Détails commande"),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: FutureBuilder<DocumentSnapshot>(
          future: com.doc(id).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Un problème est survenu");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data = snapshot.data.data();
              return Container(
                child: SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
                  child: Form(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      /*  Image.asset('image/logo.png', height: 150.0, width: 110.0), 
                     SizedBox(height: 30.0), */
                      Container(
                        child: Text(
                          "Ref Client :  " + data['idClient'],
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 20.0, color: Colors.blue[900]),
                        ),
                        height: 30.0,
                        width: 100.0,
                      ),
                      Container(
                          child: Text("Nom:     " + data['nomClient'],
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.blue[900]))),
                      Container(
                          child: Text(
                              "Total commande: " +
                                  data['Total'].toString() +
                                  "\$",
                              style: TextStyle(fontSize: 20.0))),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                          child: Column(
                              children: data['Articles'].map<Widget>((article) {
                        return Column(
                          children: [
                            Text("Désignation: " + article['désignation'] + ""),
                            Text("Quantité: " +
                                article['nbArticle'].toString() +
                                ""),
                            Text("Prix Unitaire: " +
                                article['prix HT'].toString() +
                                ""),
                            SizedBox(
                              height: 20.0,
                            ),
                          ],
                        );
                      }).toList())),
                      TextButton(
                        onPressed: () {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title:
                                  Text('Etes vous sur de vouloir supprimer ?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Annuler'),
                                  child: const Text('Annuler'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await commande.delete(id);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ListeCommande(),
                                        ),
                                        (route) => false);
                                  },
                                  child: const Text('Confirmez'),
                                )
                              ],
                            ),
                          );
                        },
                        child: Text(
                          "Supprimer",
                          style: TextStyle(color: Colors.black, fontSize: 15.0),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(
                            width: 1.0,
                            color: Colors.black,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                      ),
                    ],
                  )),
                ),
              );
            }
            return Text("Un problème est survenue veuillez patientez ...");
          }),
    );
  }
}
