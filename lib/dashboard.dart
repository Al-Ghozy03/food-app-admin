// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, unused_import

import 'dart:developer';

import 'package:admin_aplikasi_food/firebase_service.dart';
import 'package:admin_aplikasi_food/update.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("List food",
                          style: TextStyle(
                              fontFamily: "popins semi",
                              fontSize: width / 12,
                              color: Color(0xff2941CA))),
                      SizedBox(height: height / 100),
                      Container(
                        height: width*1.5,
                        width: width,
                        child: ListView.builder(
                          itemCount: listData.length,
                          itemBuilder: (context, i) {
                            Map<String, dynamic> data = snapshot.data!.docs[i]
                                .data()! as Map<String, dynamic>;
                            Map value = {"id": listData[i].id, "data": data};
                            return _listData(
                                context, width, data, listData[i].id, value);
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff2941CA),
        onPressed: () {
          Navigator.pushNamed(context, "/post");
        },
        child: Icon(Icons.add),
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
