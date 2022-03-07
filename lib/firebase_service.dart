// ignore_for_file: avoid_print, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class FirebaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  CollectionReference food = FirebaseFirestore.instance.collection('makanan');

  void updateFood(String id, String nama, int harga, int promo, int rating,
      String daerah, String img, BuildContext context) async {
    int count = 0;
    food
        .doc(id)
        .update({
          'nama': nama,
          'harga': harga,
          'promo': promo,
          'rating': rating,
          'daerah': daerah,
          'img': img,
        })
        .then((value) => print("Food Updated"))
        .catchError((error) => print("Failed to update Food: $error"));
    Navigator.popUntil(context, (route) => count++ == 1);
  }

  void deleteFood(String id) async {
    await food
        .doc(id)
        .delete()
        .then((value) => print("Berhasil delete"))
        .catchError((error) => print("gagal delete"));
  }

  void addFood(String nama, int harga, int promo, int rating, String daerah,
      String img, BuildContext context) async {
    int count = 0;
    try {
      await food.add({
        "nama": nama,
        "harga": harga,
        "promo": promo,
        "rating": rating,
        "img": img,
        "daerah": daerah
      });
      Navigator.popUntil(context, (route) => count++ == 1);
      print("berhasil add");
    } catch (e) {
      print("gagal add");
      print(e);
    }
  }
}
