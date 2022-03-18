// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, sized_box_for_whitespace

import 'package:admin_aplikasi_food/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  final String data;
  Search({required this.data});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final Stream<QuerySnapshot> getData =
      FirebaseFirestore.instance.collection('makanan').snapshots();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: getData,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            var listData = snapshot.data!.docs;
            var view = listData
                .where((element) => element["nama"]
                    .toLowerCase()
                    .contains(widget.data.toLowerCase()))
                .toList();
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Search : ${widget.data} ",
                          style: TextStyle(
                              fontFamily: "popins semi",
                              fontSize: width / 12,
                              color: Color(0xff2941CA))),
                      SizedBox(height: height / 100),
                      view.isEmpty
                          ? Center(child: Text("kosong",style: TextStyle(fontSize: width/10,color: Colors.grey,fontWeight: FontWeight.w700)))
                          : Container(
                              height: width * 1.5,
                              width: width,
                              child: ListView.builder(
                                itemCount: view.length,
                                itemBuilder: (context, i) {
                                  Map<String, dynamic> data =
                                      view[i].data()! as Map<String, dynamic>;
                                  Map value = {
                                    "id": listData[i].id,
                                    "data": data
                                  };
                                  return _listData(context, width, data,
                                      listData[i].id, value);
                                },
                              ),
                            )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

Widget _listData(BuildContext context, width, data, id, value) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 20),
    child: InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          "/update",
          arguments: value,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: width / 6,
                width: width / 6,
                decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(data["img"]))),
              ),
              SizedBox(
                width: width / 47,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data["nama"],
                    style: TextStyle(
                        fontSize: width / 27, fontFamily: "popins semi"),
                  ),
                  Row(
                    children: [
                      Text("Rp ${data["harga"]}"),
                      SizedBox(
                        width: 20,
                      ),
                      Text(data["daerah"]),
                    ],
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          Text(data["rating"].toString()),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Promo ${data["promo"]}%")
                    ],
                  ),
                ],
              ),
            ],
          ),
          IconButton(
              onPressed: () {
                FirebaseService().deleteFood(id);
              },
              icon: Icon(Icons.delete))
        ],
      ),
    ),
  );
}
