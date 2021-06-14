/// The [dart:async] is neccessary for using streams
import 'dart:async';
import 'package:flutter/material.dart';

class CartItemsBloc {
  /// The [cartStreamController] is an object of the StreamController class
  /// .broadcast enables the stream to be read in multiple screens of our app
  final cartStreamController = StreamController.broadcast();

  /// The [allItems] Map would hold all the data this bloc provides
  Stream get getStream => cartStreamController.stream;

  /// The [allItems] Map would hold all the data this bloc provides
  final Map allItems = {'cart items': []};

  void addToCart(item, uid, client, nom) {
    item["id"] = uid;
    item["id customer"] = client;
    item["nom customer"] = nom;
    item['nbArticle'] = 1;
    item['total'] = item['nbArticle'] * item['prix HT'];

    allItems['cart items'].add(item);
    cartStreamController.sink.add(allItems);
  }

  /*  void addIdItem(item) {
    allItems['cart items'].add(item);
    cartStreamController.sink.add(allItems);} */

  /// [removeFromCart] removes items from the cart, back to the shop
  void removeFromCart(item) {
    allItems['cart items'].remove(item);

    cartStreamController.sink.add(allItems);
  }

  /// The [dispose] method is used
  /// to automatically close the stream when the widget is removed from the widget tree
  void dispose() {
    cartStreamController.close(); // close our StreamController
  }

  /* final bloc = CartItemsBloc(); */
}
