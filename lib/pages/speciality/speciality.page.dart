import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfa_2023_iit/models/speciality.model.dart';
import 'package:pfa_2023_iit/pages/level/all_levels.dart';
import 'package:pfa_2023_iit/pages/speciality/add.dart';
import 'package:pfa_2023_iit/utils/dimensions/dimensions.dart';
import '../../utils/global.colors.dart';
import 'edit.dart';

class Specialities extends StatefulWidget {
  static const String id = "spec-screen";

  @override
  _SpecialitiesState createState() => _SpecialitiesState();
}

class _SpecialitiesState extends State<Specialities> {
  final CollectionReference specialitiesCollectionReference =
      FirebaseFirestore.instance.collection('speciality');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(10),
        child: StreamBuilder<QuerySnapshot>(
          stream: specialitiesCollectionReference.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong! ${snapshot.error}');
            } else if (!snapshot.hasData &&
                snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              List<Speciality> specialitiesList = [];

              if (snapshot.hasData) {
                var data = snapshot.data;

                if (data is QuerySnapshot) {
                  for (var doc in data.docs) {
                    final dataMap = doc.data() as Map<String, dynamic>?;
                    if (dataMap != null) {
                      final speciality = Speciality.fromJson(dataMap);
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
                            'Liste des Specialités',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w800),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AddSpeciality(
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
                                  Text(
                                    "Specialité",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "Description",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "Action",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: specialitiesList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Material(
                                        borderRadius: BorderRadius.circular(20),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          splashColor: Colors.grey,
                                          onTap: () {
                                            Get.to(AllLevels(
                                                specId: specialitiesList[index]
                                                    .id));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: globalcolors.mainColor
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            height:
                                                Constants.screenHeight * 0.04,
                                            width: double.infinity,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "${specialitiesList[index].name}",
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                ),
                                                Text(
                                                  "${specialitiesList[index].description}",
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                ),
                                                Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return EditSpeciality(
                                                                speciality:
                                                                    specialitiesList[
                                                                        index]);
                                                          },
                                                        );
                                                      },
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        var levels =
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "speciality")
                                                                .doc(specialitiesList[
                                                                        index]
                                                                    .id)
                                                                .collection(
                                                                    "levels")
                                                                .get();
                                                        for (var level in levels
                                                            .docs
                                                            .toList()) {
                                                          level.reference
                                                              .delete();
                                                        }
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "settings")
                                                            .doc('first')
                                                            .update({
                                                          "spec":
                                                              specialitiesList
                                                                      .length -
                                                                  1
                                                        });
                                                        await snapshot
                                                            .data!.docs.reversed
                                                            .toList()[index]
                                                            .reference
                                                            .delete();
                                                      },
                                                      child: Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
    );
  }
}
