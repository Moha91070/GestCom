import 'package:authentification/models/commandes.dart';
import 'package:authentification/pageAuth/chargement.dart';
import 'package:authentification/pageCrud/DetailsCommande.dart';
import 'package:authentification/pageCrud/accueil_admin.dart';
import 'package:authentification/pageCrud/ajoutClient.dart';
import 'package:authentification/pageCrud/detailClient.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:authentification/services/search_bar.dart';

import 'listeClient.dart';

SearchBar searchBar;
GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class ListeCommande extends StatefulWidget {
  final Function changer;
  ListeCommande({this.changer});
  @override
  _ListeCommandeState createState() => _ListeCommandeState();
}

AppBar _buildAppBar(BuildContext context) {
  return new AppBar(
    title: new Text("liste des Commandes"),
    actions: <Widget>[
      searchBar.getSearchAction(context),
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
      IconButton(
        icon: Icon(Icons.add),
        color: Colors.white,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ListeClient()));
        },
      ),
    ],
    centerTitle: true,
    backgroundColor: Colors.blue[900],
  );
}

class _ListeCommandeState extends State<ListeCommande> {
  final Commande article = Commande();
  String _queryText = '';
  final Color primaryColor = Colors.grey.shade200;
  final Color secondaryColor = Colors.white;
  final Color logoGreen = Color(0xff25bcbb);

  final TextEditingController idController = TextEditingController();

  _ListeCommandeState() {
    searchBar = new SearchBar(
      onChanged: onSubmitted,
      page: 3,
      inBar: true,
      buildDefaultAppBar: _buildAppBar,
      setState: setState,
    );
  }

  void onSubmitted(String value) {
    setState(() {
      _queryText = value;
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text('Résultat de votre recherche'),
        backgroundColor: Colors.red,
      ));
    });
  }

  _buildTextField(TextEditingController controller, String labelText) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: secondaryColor, border: Border.all(color: Colors.transparent)),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.white),

            // prefix: Icon(icon),
            border: InputBorder.none),
      ),
    );
  }

  CollectionReference ref = FirebaseFirestore.instance.collection('commandes');
  CollectionReference cli = FirebaseFirestore.instance.collection('clients');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: searchBar.build(context),
      backgroundColor: Colors.white,
      body: _fireSearch(_queryText),
    );
  }
}

Widget _fireSearch(String searchKey) {
  return new StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection('commandes')
        .where('nomClient', isGreaterThanOrEqualTo: searchKey)
        .where('nomClient', isLessThan: searchKey + 'z')
        .snapshots(),
    builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
      // j'ai besoin d'explication sur le _
      if (snapshot.hasData) {
        return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data.docs[index].data();
              return Card(
                child: ListTile(
                  minVerticalPadding: 16.0,
                  leading: IconButton(
                      icon: Icon(Icons.read_more),
                      color: Colors.grey,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsCommande(),
                              settings:
                                  RouteSettings(arguments: doc["idcommande"]),
                            ));
                      }),
                  title: Text(
                    "ref: ${doc["idcommande"]}",
                    style: TextStyle(color: Colors.black),
                  ),
                  subtitle: Column(
                    children: <Widget>[
                      Text(
                        "client: ${doc["nomClient"]}",
                        style: TextStyle(color: Colors.blue),
                      ),
                      Text(
                        " Total commande: ${doc['Total'].toString()} \$",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  /* trailing: Image.network(doc['ImageUrl'],
                        height: 100, fit: BoxFit.cover, width: 100), */
                ),
              );
            });
      } else {
        return Text('Un problème est survenu');
      }
    },
  );
}
