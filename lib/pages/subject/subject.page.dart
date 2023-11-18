import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pfa_2023_iit/models/subject.model.dart';
import 'package:pfa_2023_iit/pages/subject/add.subject.dart';
import 'package:pfa_2023_iit/pages/subject/edit.subject.dart';
import 'package:pfa_2023_iit/utils/dimensions/dimensions.dart';
import '../../utils/global.colors.dart';

class Subjects extends StatefulWidget {
  final String idSpec;
  final String idlevel;
  final String idGrp;
  Subjects({required this.idSpec, required this.idGrp, required this.idlevel});
  @override
  _SubjectsState createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globalcolors.mainColor,
        title: Text("Gestion de matiéres"),
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
                .doc(widget.idlevel)
                .collection("groups")
                .doc(widget.idGrp)
                .collection("subjects")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong! ${snapshot.error}');
              } else if (!snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                List<Subject> subjectsList = [];

                if (snapshot.hasData) {
                  var data = snapshot.data;

                  if (data is QuerySnapshot) {
                    for (var doc in data.docs) {
                      final dataMap = doc.data() as Map<String, dynamic>?;
                      if (dataMap != null) {
                        final subject = Subject.fromJson(dataMap);
                        subjectsList.add(subject);
                      }
                    }
                  }
                }
                subjectsList = subjectsList.reversed.toList();
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
                              'Liste des matieres',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AddSubject(
                                      idLevel: widget.idlevel,
                                      idSpec: widget.idSpec,
                                      idGrp: widget.idGrp,
                                      number: subjectsList.length,
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
                                        "Nom de matiere",
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
                              subjectsList.isEmpty
                                  ? Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 100),
                                      child:
                                          Text("Pas de matiere pour le moment"),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: subjectsList.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Material(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.blue
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
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
                                                          "${subjectsList[index].name}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue),
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
                                                                  return EditSubject(
                                                                      subject: snapshot
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
                                                              snapshot.data!
                                                                  .docs.reversed
                                                                  .toList()[
                                                                      index]
                                                                  .reference
                                                                  .delete();
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "settings")
                                                                  .doc('first')
                                                                  .update({
                                                                "subs": subjectsList
                                                                        .length -
                                                                    1
                                                              });
                                                            },
                                                            child: Icon(
                                                              Icons.delete,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
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
