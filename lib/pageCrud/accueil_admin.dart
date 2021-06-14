import 'package:flutter/material.dart';
import 'package:authentification/pageAuth/accueil.dart';
import 'package:authentification/pageCrud/listeArticles.dart';
import 'package:authentification/pageCrud/listeClient.dart';
import 'package:authentification/pageCrud/listeCommande.dart';
import 'package:authentification/services/authentification.dart';

class Accueil extends StatefulWidget {
  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Accueil"),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.asset('image/867.jpg', height: 100.0, width: 100.0),
                  SizedBox(height: 10.0),
                  Center(
                    child: Text("Bienvenue sur authentification",
                        style: TextStyle(
                            fontSize: 40,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 4
                              ..color = Colors.blue[700])),
                  ),
                  SizedBox(height: 50.0),
                  TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListeClient(),
                            ),
                            (route) => false);
                      },
                      child: Text("LISTE CLIENTS"),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue[200],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                      )),
                  SizedBox(height: 10.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListeCommande(),
                          ),
                          (route) => false);
                    },
                    child: Text("LISTE COMMANDES"),
                    style: TextButton.styleFrom(
                      side: BorderSide(width: 1.0, color: Colors.black),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListeArticle(),
                          ),
                          (route) => false);
                    },
                    child: Text("LISTE ARTICLES"),
                    style: TextButton.styleFrom(
                      side: BorderSide(width: 1.0, color: Colors.black),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  SizedBox(height: 10.0),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.blueGrey)),
                    onPressed: () async {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AccScreen(),
                          ),
                          (route) => false);
                    },
                    child: Text("Deconnexion"),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
