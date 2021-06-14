import 'package:flutter/material.dart';
import 'package:authentification/pageCrud/listeClient.dart';
import 'package:authentification/models/client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:authentification/constant/chargement.dart';
import 'package:authentification/pageCrud/commande.dart';

import 'accueil_admin.dart';

class DetailClient extends StatefulWidget {
  @override
  _DetailClientState createState() => _DetailClientState();
}

class _DetailClientState extends State<DetailClient> {
  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context).settings.arguments;
    Map clients = {"id": '', "nom": ''};
    final Client client = Client();
    CollectionReference users =
        FirebaseFirestore.instance.collection('clients');

    return Scaffold(
      appBar: AppBar(
        title: Text("Détail client"),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            color: Colors.white,
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Accueil(),
                  ),
                  (route) => false);
            },
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
          future: users.doc(id).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Un problème est survenu");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data = snapshot.data.data();
              return Container(
                padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
                child: Form(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Image.asset('image/logo.png', height: 150.0, width: 110.0),
                    SizedBox(height: 30.0),
                    Container(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                          Text(
                            "NOM : " + data['nom'],
                            style: TextStyle(
                                color: Color(0xFF000000), fontSize: 20.0),
                          ),
                          Text(
                            "PRENOM : " + data['prenom'],
                            style: TextStyle(fontSize: 20.0),
                          ),
                          Text("MAIL : " + data['mail'],
                              style: TextStyle(fontSize: 20.0)),
                          Text(
                            "TELEPHONE : " + data['télèphone'],
                            style: TextStyle(fontSize: 20.0),
                          ),
                          Text(
                            "ADRESSE : " + data['adresse']['rue'],
                            style: TextStyle(fontSize: 20.0),
                          ),
                          Text(
                            "CODE POSTAL : " + data['adresse']['code postal'],
                            style: TextStyle(fontSize: 20.0),
                          ),
                          Text("VILLE : " + data['adresse']['ville'],
                              style: TextStyle(fontSize: 20.0)),
                        ])),
                    TextButton(
                      // push de l' id
                      onPressed: () {
                        clients['id'] = data['id'];
                        clients['nom'] = data['nom'];
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Commande(),
                              settings: RouteSettings(
                                arguments: clients,
                              ),
                            ),
                            (route) => false);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        side: BorderSide(width: 1.0, color: Colors.black),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                      child: Text("Créer une commande",
                          style:
                              TextStyle(color: Colors.black, fontSize: 15.0)),
                    ),
                    TextButton(
                      onPressed: () {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text(
                                'Etes vous sur de vouloir supprimer Article ' +
                                    data['nom'] +
                                    "" +
                                    data['prenom'] +
                                    ' ?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Annuler'),
                                child: const Text('Annuler'),
                              ),
                              TextButton(
                                onPressed: () {
                                  client.delete(id);
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ListeClient(),
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
              );
            }
            return Text("chargement");
          }),
    );
  }
}
