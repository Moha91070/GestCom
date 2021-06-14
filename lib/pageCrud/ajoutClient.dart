import 'package:flutter/material.dart';
import 'package:authentification/models/client.dart';
import 'package:authentification/pageCrud/listeClient.dart';
import 'package:authentification/services/authentification.dart';

class FormulaireClient extends StatefulWidget {

  @override
  _FormulaireClientState createState() => _FormulaireClientState();
}

class _FormulaireClientState extends State<FormulaireClient> {
  String nom = "";
  String prenom = "";
  String adresse = "";
  String codePostal = "";
  String ville = "";
  String telephone = "";
  String mail = "";
  final Client client = Client();
  final AuthService _auth = AuthService();

  final _formKey =
      GlobalKey<FormState>(); // important mettre la key plus bas dans le form
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Ajout Client'),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
          child: Form(
            key: _formKey, //important permet de traité le form
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .stretch, //permet au champs text d'avoir les mêms dimension
              children: <Widget>[
                TextFormField(
                  // syntaxe basic {lignes 33 à 38} à un input text
                  decoration: InputDecoration(
                      labelText: 'Nom', border: OutlineInputBorder()),
                  validator: (value) => value.isEmpty ? "Entrez un nom" : null,
                  onChanged: (value) => this.nom = value,
                ),
                SizedBox(
                    height: 10.0), // permet de mettre un espace entre le input
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Prénom', border: OutlineInputBorder()),
                  validator: (value) =>
                      value.isEmpty ? "Entrez un prénom" : null,
                  onChanged: (value) => prenom = value,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Adresse', border: OutlineInputBorder()),
                  validator: (value) =>
                      value.isEmpty ? "Entrez une adresse" : null,
                  onChanged: (value) => adresse = value,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Code postal', border: OutlineInputBorder()),
                  validator: (value) =>
                      value.isEmpty ? "Entrez le code postal" : null,
                  onChanged: (value) => codePostal = value,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Ville', border: OutlineInputBorder()),
                  validator: (value) =>
                      value.isEmpty ? "Entrez la ville" : null,
                  onChanged: (value) => ville = value,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Télèphone', border: OutlineInputBorder()),
                  validator: (value) => value.isEmpty
                      ? "Entrez un numéro de télèphone 10 chiffres"
                      : null,
                  onChanged: (value) => telephone = value,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Mail', border: OutlineInputBorder()),
                  validator: (value) =>
                      value.isEmpty ? "Entrez une adresse mail" : null,
                  onChanged: (value) => mail = value,
                ),
                SizedBox(height: 10.0),
                TextButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await client.addClient(nom, prenom, adresse, codePostal,
                            ville, telephone, mail);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListeClient(),
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
