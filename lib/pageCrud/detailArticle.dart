import 'package:flutter/material.dart';
import 'package:authentification/models/article.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:authentification/constant/chargement.dart';
import 'package:authentification/pageCrud/listeArticles.dart';

import 'accueil_admin.dart';

class DetailArticle extends StatefulWidget {
  @override
  _DetailArticleState createState() => _DetailArticleState();
}

class _DetailArticleState extends State<DetailArticle> {
  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context).settings.arguments;
    final Article article = Article();
    CollectionReference bdd = FirebaseFirestore.instance.collection('articles');

    return Scaffold(
      appBar: AppBar(
          title: Text("Détail Article"),
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
          ]),
      body: FutureBuilder<DocumentSnapshot>(
          future: bdd.doc(id).get(),
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
                    // image

                    SizedBox(height: 30.0),
                    Container(
                      child: Text(
                        "Désignation :    " + data['désignation'],
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: Color(0xFF000000), fontSize: 20.0),
                      ),
                      height: 50.0,
                      width: 100.0,
                      decoration: const BoxDecoration(
                          border: Border(
                        top: BorderSide(width: 1.0, color: Colors.black),
                        left: BorderSide(width: 1.0, color: Colors.black),
                        right: BorderSide(width: 1.0, color: Colors.black),
                        bottom: BorderSide(width: 1.0, color: Colors.black),
                      )),
                    ),
                    Container(
                        child: Text("Prix :     " + data['prix HT'].toString(),
                            style: TextStyle(
                                fontSize: 20.0,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 2
                                  ..color = Colors.blue[700]))),
                    Container(
                        child: Text("Stock :      " + data['stock'].toString(),
                            style: TextStyle(fontSize: 20.0))),
                    Container(
                        child: Text(
                      "Fournisseur : " + data['Fournisseur'],
                      style: TextStyle(fontSize: 20.0),
                    )),
/*                     Container(
                        child: Text(
                      "ADRESSE : " + data['adresse']['rue'],
                      style: TextStyle(fontSize: 20.0),
                    )),
 */ /*                     Container(
                        child: Text(
                      "CODE POSTAL : " + data['adresse']['code postal'],
                      style: TextStyle(fontSize: 20.0),
                    )),
                    Container(
                      child: Text("VILLE : " + data['adresse']['ville'],
                          style: TextStyle(fontSize: 20.0)),
                    ),
 */

                    TextButton(
                      onPressed: () async {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text(
                                'Etes vous sur de vouloir supprimer Article ' +
                                    data['désignation'] +
                                    ' ?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Annuler'),
                                child: const Text('Annuler'),
                              ),
                              TextButton(
                                onPressed: () {
                                  article.delete(id);
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ListeArticle(),
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
                        backgroundColor: Colors.blue,
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
            return Chargement();
          }),
    );
  }
}
