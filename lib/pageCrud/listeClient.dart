import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:authentification/models/article.dart';
import 'package:authentification/models/client.dart';
import 'package:authentification/pageCrud/accueil_admin.dart';
import 'package:authentification/constant/chargement.dart';
import 'package:authentification/pageCrud/ajoutClient.dart';
import 'package:authentification/pageCrud/detailArticle.dart';
import 'package:authentification/pageCrud/detailClient.dart';
import 'package:authentification/pageCrud/formulaireArticle.dart';
import 'package:authentification/services/search_bar.dart';

SearchBar searchBar;
GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class ListeClient extends StatefulWidget {
  @override
  _ListeClientState createState() => _ListeClientState();
}

AppBar _buildAppBar(BuildContext context) {
  return new AppBar(
    actions: <Widget>[
      searchBar.getSearchAction(context),
      IconButton(
        icon: Icon(Icons.add),
        color: Colors.white,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => FormulaireClient()));
        },
      ),
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
    title: new Text("liste des clients"),
    centerTitle: true,
    backgroundColor: Colors.blue[900],
  );
}

class _ListeClientState extends State<ListeClient> {
  final Client article = Client();
  String _queryText = '';
  _ListeClientState() {
    searchBar = new SearchBar(
      onChanged: onSubmitted,
      page: 2,
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

  CollectionReference collection =
      FirebaseFirestore.instance.collection('clients');

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
        .collection('clients')
        .where('nom', isGreaterThanOrEqualTo: searchKey)
        .where('nom', isLessThan: searchKey + 'z')
        .snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Text('Un problème est survenu');
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Chargement();
      }
      return new ListView(
        // padding: const EdgeInsets.all(30), permet de modifir la largeur
        children: snapshot.data.docs.map((DocumentSnapshot document) {
          return (Column(children: <Widget>[
            Card(
              child: ListTile(
                minVerticalPadding: 16.0,
                leading: IconButton(
                    icon: Icon(Icons.read_more),
                    color: Colors.grey,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailClient(),
                            settings: RouteSettings(
                                arguments: document.data()['id'].toString()),
                          ));
                    }),
                title: Text(
                  "ref : " + document.data()['id'].toString(),
                  style: TextStyle(color: Colors.black),
                ),
                subtitle: Column(
                  children: <Widget>[
                    Text(
                      "Nom : " + document.data()['nom'],
                      style: TextStyle(color: Colors.blue),
                    ),
                    Text(
                      "Prénom : " + document.data()['prenom'],
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                /* trailing: Image.network(doc['ImageUrl'],
                        height: 100, fit: BoxFit.cover, width: 100), */
              ),
            ),
          ]));
        }).toList(),
      );
    },
  );
}
