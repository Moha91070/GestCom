import 'package:flutter/material.dart';
import 'package:authentification/pageAuth/accueil.dart';
import 'package:authentification/pageAuth/chargement.dart';
import 'package:authentification/pageAuth/verif.dart';
import 'package:authentification/pageCrud/accueil_admin.dart';

class LoginScreen extends StatefulWidget {
  final Function(int) onChangedStep;
  final Function changer;
  const LoginScreen({
    Key key,
    this.changer,
    this.onChangedStep,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Verif _auth = Verif();
  final _formKey = GlobalKey<FormState>();
  bool chargement = false;
  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(context) {
    return chargement
        ? Chargement()
        : Scaffold(
            body: SingleChildScrollView(
                child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 60.0),
                    Text(
                      "connexion".toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30.0,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Image.asset('image/867.jpg', height: 200.0, width: 200.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Entrez votre e-mail:',
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val.isEmpty ? "Entrer un e-mail valide" : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Entrez votre mot de passe',
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
                    TextButton(
                        style: TextButton.styleFrom(primary: Colors.blueGrey),
                        child: Text(
                          'Se connecter',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => chargement = true);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Accueil()),
                                (route) => false);

                            dynamic result = await _auth
                                .signInWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() {
                                error = "Vous n'êtes pas connecter";
                                chargement = false;
                              });
                              if (result = false) {
                                setState(() {
                                  error =
                                      "Mauvais identifiant ou mot de passe ";
                                  chargement = false;
                                });
                              }
                            }
                          }
                        }),
                    SizedBox(height: 12.0),
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
