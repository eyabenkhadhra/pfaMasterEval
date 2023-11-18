import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfa_2023_iit/models/level.model.dart';
import 'package:pfa_2023_iit/pages/group/group.page.dart';
import 'package:pfa_2023_iit/pages/level/add_level.dart';
import 'package:pfa_2023_iit/pages/level/edit.level.dart';
import 'package:pfa_2023_iit/utils/dimensions/dimensions.dart';
import 'package:pfa_2023_iit/utils/global.colors.dart';

class AllLevels extends StatefulWidget {
  final String specId;
  const AllLevels({Key? key, required this.specId}) : super(key: key);

  @override
  State<AllLevels> createState() => _AllLevelsState();
}

class _AllLevelsState extends State<AllLevels> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globalcolors.mainColor,
        title: Text("Gestion de niveaux"),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('speciality')
                .doc(widget.specId)
                .collection("levels")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong! ${snapshot.error}');
              } else if (!snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                List<Level> specialitiesList = [];

                if (snapshot.hasData) {
                  var data = snapshot.data;

                  if (data is QuerySnapshot) {
                    for (var doc in data.docs) {
                      final dataMap = doc.data() as Map<String, dynamic>?;
                      if (dataMap != null) {
                        final speciality = Level.fromJson(dataMap);
                        specialitiesList.add(speciality);
                      }
                    }
                  }
                }
                specialitiesList = specialitiesList.reversed.toList();
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
                              'Liste des niveau',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w800),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AddLevel(
                                      specId: widget.specId,
                                      number: specialitiesList.length,
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
                                        "Nom de Niveau",
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
                              specialitiesList.isEmpty
                                  ? Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 100),
                                      child:
                                          Text("Pas de niveau pour le moment"),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: specialitiesList.length,
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
                                                    Get.to(Groups(
                                                      idSpec: widget.specId,
                                                      idLevel: specialitiesList[
                                                              index]
                                                          .id,
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
                                                            "${specialitiesList[index].name}",
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
                                                                    return EditLevel(
                                                                        level: snapshot
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
                                                                  "levels":
                                                                      specialitiesList
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
