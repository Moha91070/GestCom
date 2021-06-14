import 'package:flutter/material.dart';
import 'package:authentification/models/article.dart';
import 'package:authentification/pageCrud/listeArticles.dart';

class FormulaireArticle extends StatefulWidget {
  @override
  _FormulaireArticleState createState() => _FormulaireArticleState();
}

class _FormulaireArticleState extends State<FormulaireArticle> {
  String desigantion = "";
  int prix;
  int stock;
  String fournisseur = "";
  final Article article = Article();

  final _formKey =
      GlobalKey<FormState>(); // important mettre la key plus bas dans le form
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Ajout article'),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
          child: Form(
            key: _formKey, //important permet de traité le form
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .stretch, //permet au champs text d'avoir les mêmes dimension
              children: <Widget>[
                SizedBox(
                    height: 10.0), // permet de mettre un espace entre le input
                TextFormField(
                  // syntaxe basic {lignes 33 à 38} à un input text
                  decoration: InputDecoration(
                      labelText: 'Désignation', border: OutlineInputBorder()),
                  validator: (value) =>
                      value.isEmpty ? "Entrez la désignation" : null,
                  onChanged: (value) => desigantion = value,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Prix HT', border: OutlineInputBorder()),
                  validator: (value) =>
                      value.isEmpty ? "Entrez le prix HT" : null,
                  onChanged: (value) => prix = int.tryParse(value),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Stock', border: OutlineInputBorder()),
                  validator: (value) =>
                      value.isEmpty ? "Entrez le stock" : null,
                  onChanged: (value) => stock = int.tryParse(value),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Fournisseur', border: OutlineInputBorder()),
                  validator: (value) =>
                      value.isEmpty ? "entrez le nom du fournisseur" : null,
                  onChanged: (value) => fournisseur = value,
                ),

                SizedBox(height: 10.0),
                TextButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await article.addArticle(
                            desigantion, prix, stock, fournisseur);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListeArticle(),
                            ),
                            (route) => false);
                      }
                    },
                    child:
                        Text("Valider", style: TextStyle(color: Colors.black)),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
