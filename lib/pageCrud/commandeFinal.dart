import 'package:authentification/pageCrud/listeCommande.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class CommandeFinal extends StatefulWidget {
  final List<dynamic> allItems;

  CommandeFinal({Key key, @required this.allItems}) : super(key: key);

  @override
  _CommandeState createState() => _CommandeState();
}

class _CommandeState extends State<CommandeFinal> {
  Map<String, dynamic> commandeAjouter;
  CollectionReference ref = FirebaseFirestore.instance.collection('articles');
  CollectionReference com = FirebaseFirestore.instance.collection('commandes');
  CollectionReference collectionReference = FirebaseFirestore.instance
      .collection("commandes")
      .doc()
      .collection("articles");

  removeFromCart(item) {
    setState(() {
      widget.allItems.remove(item);
    });
  }

  int nb = 1;
  addNb(i) {
    setState(() {
      var qte = widget.allItems[i]['stock'];
      if (widget.allItems[i]['nbArticle'] < qte) {
        widget.allItems[i]['nbArticle']++;
        widget.allItems[i]['total'] =
            widget.allItems[i]['nbArticle'] * widget.allItems[i]['prix HT'];

        /*  print(widget.allItems[i]['TotalAllItems']); */
      }
    });
  }

  supNb(i) {
    /* var total = 0; */
    setState(() {
      if (widget.allItems[i]['nbArticle'] > 0) {
        widget.allItems[i]['nbArticle']--;
        widget.allItems[i]['total'] =
            widget.allItems[i]['nbArticle'] * widget.allItems[i]['prix HT'];
        /* total += widget.allItems[i]['total'];
        widget.allItems[i]['TotalAllItems'] = total; */
      }
    });
  }

  mAjQ() {
    setState(() {
      widget.allItems.forEach((i) {
        int qte = i['stock'];
        int nb = i['nbArticle'];
        var stock = qte - nb;

        ref.doc(i['id']).update({"stock": stock}).then(
            (value) => print("stock mis à jour"));

        print(i['stock']);
      });
    });
  }

  addTotal() {
    int total = 0;
    widget.allItems.forEach((i) {
      total += i['total'];
    });
    return total;
  }

  ajouterCommande() {
    widget.allItems.forEach((item) => {
          collectionReference
              .add(item)
              .whenComplete(() => print('Commande bien ajoutez'))
              .catchError(
                  (error, stackTrace) => print("error: ${error.toString()}"))
        });

    print(widget.allItems);
  }

  addCommande() {
    var total = addTotal();
    com.add({
      "idClient": widget.allItems[0]["id customer"],
      "nomClient": widget.allItems[0]["nom customer"],
      "idcommande": "",
      "Articles": widget.allItems,
      'Total': total,
    }).then((value) {
      com.doc(value.id).update({"idcommande": value.id});
    });
  }

  void snack(total) {
    SnackBar snackBar = SnackBar(
      content: Text("TOTAL COMMANDE : " + total.toString() + " €"),
      backgroundColor: Colors.blue,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Votre commande',
            style: TextStyle(color: Colors.white),
          ),
          titleSpacing: 0,
          elevation: 0,
          backgroundColor: Colors.blue[900],
        ),
        body:
            /* StreamBuilder(
        initialData: allItems,
        stream: bloc.getStream,
        builder: (context, snapshot) {
          print("info:  $allItems"); */
            widget.allItems.length > 0
                ? Column(
                    children: <Widget>[
                      /// The [commandeListBuilder] has to be fixed
                      /// in an expanded widget to ensure it
                      /// doesn't occupy the whole screen and leaves
                      /// room for the the RaisedButton
                      Expanded(child: commandeListBuilder(widget.allItems)),
                      BottomAppBar(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Total Commande :" +
                              addTotal().toString() +
                              " €"),
                          TextButton(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Ajoutez la commande',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.blue[900]),
                            onPressed: () async {
                              await addCommande();
                              await mAjQ();
                              widget.allItems.clear();
                              print(widget.allItems);

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ListeCommande(),
                                  ),
                                  (route) => false);
                            },
                          ),
                        ],
                      )),

                      SizedBox(height: 40)
                    ],
                  )
                : Center(child: Text("PANIER VIDE")));
  }

  Widget commandeListBuilder(snapshot) {
    return ListView.builder(
      itemCount: snapshot.length,
      itemBuilder: (BuildContext context, i) {
        final cartList = snapshot;

        return Card(
            child: ListTile(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  removeFromCart(cartList[i]);
                },
              ),
              SizedBox(
                width: 100.0,
              ),
              Column(
                children: [
                  Text(
                    cartList[i]['désignation'],
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(
                    "${cartList[i]['prix HT']} euros",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    "${cartList[i]['stock']} en stock",
                    style: TextStyle(color: Colors.blue),
                  ),
                  Row(
                    children: [
                      IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            addNb(i);
                          }),
                      Text("${cartList[i]['nbArticle']} article(s)"),
                      IconButton(
                        icon: Icon(Icons.minimize),
                        onPressed: () {
                          supNb(i);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'total',
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                  ),
                  Row(
                    children: [
                      Icon(Icons.euro, color: Colors.black, size: 18.0),
                      Text(
                        '${cartList[i]['total']}',
                        style: TextStyle(color: Colors.grey, fontSize: 20.0),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ));
      },
    );
  }
}
