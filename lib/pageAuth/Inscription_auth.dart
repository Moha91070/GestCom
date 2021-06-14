import 'package:flutter/material.dart';
import 'package:authentification/pageAuth/accueil.dart';
import 'package:authentification/pageAuth/verif.dart';

class InscriptionScreen extends StatefulWidget {
  final Function(int, String) onChangedStep;
  const InscriptionScreen({
    Key key,
    this.onChangedStep,
  }) : super(key: key);

  @override
  _InscriptionScreenState createState() => _InscriptionScreenState();
}

class _InscriptionScreenState extends State<InscriptionScreen> {
  final Verif _auth = Verif();
  final _formKey = GlobalKey<FormState>();
  bool chargement = false;
  String email = '';
  String password = '';
  String confPassword = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              Text(
                "Inscription".toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 30.0),
              ),
              SizedBox(height: 20.0),
              Image.asset('image/867.jpg', height: 200.0, width: 150.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Entrez un e-mail:',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val.isEmpty ? "Entrer un e-mail valide" : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 10.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Entrez un mot de passe',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val.length < 6 ? "Mot de passe trop court" : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Confirmer le mot de passe',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => confPassword = val,
                validator: (val) => confPassword != password
                    ? 'Confirmez le mot de passe'
                    : null,
                obscureText: true,
              ),
              SizedBox(height: 10.0),
              TextButton(
                  style: TextButton.styleFrom(primary: Colors.blueGrey),
                  child: Text(
                    "s'inscrire",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() => chargement = true);
                      dynamic result = await _auth.registerWithEmailAndPassword(
                          email, password);
                      if (result == null) {
                        setState(() {
                          error = "Vous n'êtes pas connecter";
                          chargement = false;
                        });
                      }
                    }
                  }),
              SizedBox(height: 12.0),
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
                child: Text("Page d'accueil"),
              ),
              Text(
                error,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14.0,
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
