// ignore_for_file: prefer_const_constructors, duplicate_ignore, unused_local_variable, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_print, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'dart:io';

import 'package:admin_aplikasi_food/firebase_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Update extends StatefulWidget {
  final Map data;
  Update({required this.data});
  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  TextEditingController name = TextEditingController();
  TextEditingController harga = TextEditingController();
  TextEditingController promo = TextEditingController();
  TextEditingController rating = TextEditingController();
  TextEditingController daerah = TextEditingController();
  FirebaseStorage storage = FirebaseStorage.instance;
  String url = "";

  void addPhoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      String nama = result.files.first.name;
      url = nama;
      try {
        await storage.ref("uploads/$nama").putFile(file);
        final data = await storage.ref("uploads/$nama").getDownloadURL();
        url = data;
      } on FirebaseException catch (e) {
        print("gagal");
        print(e);
      }
    } else {
      print("tidak memilih file");
    }
  }

  @override
  void initState() {
    name.text = widget.data["data"]["nama"];
    harga.text = widget.data["data"]["harga"].toString();
    promo.text = widget.data["data"]["promo"].toString();
    rating.text = widget.data["data"]["rating"].toString();
    daerah.text = widget.data["data"]["daerah"];
    url = widget.data["data"]["img"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Update food",
                  style: TextStyle(
                      fontFamily: "popins semi",
                      fontSize: width / 12,
                      color: Color(0xff2941CA))),
              SizedBox(
                height: height / 30,
              ),
              _field("Nama", height, name),
              _field("Harga", height, harga),
              _field("Promo", height, promo),
              _field("Rating", height, rating),
              _field("Daerah", height, daerah),
              Image.network(
                url,
                height: height / 5,
              ),
              SizedBox(
                height: height / 30,
              ),
              ElevatedButton(
                onPressed: () => addPhoto(),
                child: Text(
                  "Update photo",
                  style: TextStyle(fontSize: width / 30),
                ),
                style: ElevatedButton.styleFrom(
                    primary: Color(0xff2941CA), padding: EdgeInsets.all(10)),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xff2941CA), padding: EdgeInsets.all(10)),
                  onPressed: () => FirebaseService().updateFood(
                      widget.data["id"],
                      name.text,
                      int.parse(harga.text),
                      int.parse(promo.text),
                      int.parse(rating.text),
                      daerah.text,
                      url,
                      context),
                  child: Text(
                    "Update",
                    style: TextStyle(fontSize: width / 30),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

Widget _field(text, height, controller) {
  return Column(
    children: [
      TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          hintText: text,
        ),
      ),
      SizedBox(
        height: height / 50,
      )
    ],
  );
}
