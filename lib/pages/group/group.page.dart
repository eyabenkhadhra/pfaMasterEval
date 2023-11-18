import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:pfa_2023_iit/models/group.model.dart';
import 'package:pfa_2023_iit/pages/group/add.group.dart';
import 'package:pfa_2023_iit/pages/group/edit.group.dart';
import 'package:pfa_2023_iit/pages/subject/subject.page.dart';
import 'package:pfa_2023_iit/utils/dimensions/dimensions.dart';
import 'package:pfa_2023_iit/utils/global.colors.dart';

class Groups extends StatefulWidget {
  @override
  _GroupsState createState() => _GroupsState();
  final String idLevel;
  final String idSpec;
  Groups({required this.idLevel, required this.idSpec});
}

class _GroupsState extends State<Groups> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globalcolors.mainColor,
        title: Text("Gestion de groupes"),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('speciality')
                .doc(widget.idSpec)
                .collection("levels")
                .doc(widget.idLevel)
                .collection("groups")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong! ${snapshot.error}');
              } else if (!snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                List<Group> groupsList = [];

                if (snapshot.hasData) {
                  var data = snapshot.data;

                  if (data is QuerySnapshot) {
                    for (var doc in data.docs) {
                      final dataMap = doc.data() as Map<String, dynamic>?;
                      if (dataMap != null) {
                        final grp = Group.fromJson(dataMap);
                        groupsList.add(grp);
                      }
                    }
                  }
                }
                groupsList = groupsList.reversed.toList();

                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Liste des groups',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w800),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AddGroup(
                                      idLevel: widget.idLevel,
                                      idSpec: widget.idSpec,
                                      number: groupsList.length,
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: globalcolors.mainColor,
                                fixedSize: const Size(250, 50),
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              child: Text('Ajouter'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: globalcolors.mainColor,
                                    borderRadius: BorderRadius.circular(20)),
                                height: Constants.screenHeight * 0.04,
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Nom de group",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Actions",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              groupsList.isEmpty
                                  ? Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 100),
                                      child:
                                          Text("Pas de groups pour le moment"),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: groupsList.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Material(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: InkWell(
                                                  onTap: () {
                                                    Get.to(Subjects(
                                                      idSpec: widget.idSpec,
                                                      idlevel: widget.idLevel,
                                                      idGrp:
                                                          groupsList[index].id,
                                                    ));
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.blue
                                                            .withOpacity(0.2),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    height:
                                                        Constants.screenHeight *
                                                            0.04,
                                                    width: double.infinity,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            "${groupsList[index].name}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue),
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return EditGroup(
                                                                        group: snapshot
                                                                            .data!
                                                                            .docs
                                                                            .reversed
                                                                            .toList()[index]);
                                                                  },
                                                                );
                                                              },
                                                              child: Icon(
                                                                Icons.edit,
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () async {
                                                                await snapshot
                                                                    .data!
                                                                    .docs
                                                                    .reversed
                                                                    .toList()[
                                                                        index]
                                                                    .reference
                                                                    .delete();
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "settings")
                                                                    .doc(
                                                                        'first')
                                                                    .update({
                                                                  "groups":
                                                                      groupsList
                                                                              .length -
                                                                          1
                                                                });
                                                              },
                                                              child: Icon(
                                                                Icons.delete,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    )
                            ],
                          )),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
