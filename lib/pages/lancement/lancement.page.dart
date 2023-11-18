/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class Lancement extends StatefulWidget {
  @override
  State<Lancement> createState() => _LancementState();
}

class _LancementState extends State<Lancement> {
  String selectedSpeciality = "0";
  String? selectedLevel;
  String? selectedSubject;
  String? selectedGroup;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Generate QR Code ",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Dropdown button"),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //specialities

                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('specialities')
                          .snapshots(),
                      builder: (context, snapshot) {
                        List<DropdownMenuItem<String>> specialityItems = [];
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        } else {
                          final specialities =
                              snapshot.data?.docs.reversed.toList();
                          specialityItems.add(
                            DropdownMenuItem(
                              value: "0",
                              child: Text('select speciality'),
                            ),
                          );
                          for (var speciality in specialities!) {
                            specialityItems.add(
                              DropdownMenuItem(
                                value: speciality.id,
                                child: Text(
                                  speciality['name'],
                                ),
                              ),
                            );
                          }
                        }
                        return DropdownButton<String>(
                          items: specialityItems,
                          value: selectedSpeciality,
                          onChanged: (String? specialityValue) {
                            setState(() {
                              selectedSpeciality = specialityValue.toString();
                              selectedLevel = null;
                              selectedSubject = null;
                              selectedGroup = null;
                            });
                            print(specialityValue);
                          },
                          isExpanded: false,
                        );
                      }),
//////////////

                  SizedBox(height: 16),

                  //levels
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('specialities')
                        .doc(selectedSpeciality)
                        .collection('niveaux')
                        .snapshots(),
                    builder: (context, snapshot) {
                      List<DropdownMenuItem<String>> levelItems = [];

                      if (!snapshot.hasData || selectedSpeciality == null) {
                        return Container();
                      }

                      levelItems.add(DropdownMenuItem(
                        value: null,
                        child: Text('Select a level'),
                      ));
                      snapshot.data?.docs.forEach((doc) {
                        levelItems.add(DropdownMenuItem(
                          value: doc.id,
                          child: Text(doc['name']),
                        ));
                      });

                      return DropdownButton<String>(
                        items: levelItems,
                        value: selectedLevel,
                        isExpanded: false,
                        hint: Text('Select a level'),
                        onChanged: (levelValue) {
                          setState(() {
                            selectedLevel = levelValue!;
                            selectedSubject = null;
                            selectedGroup = null;
                          });
                          print(levelValue);
                        },
                      );
                    },
                  ),
///////////////////////////

                  SizedBox(height: 16),

                  //subjects
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('specialities')
                        .doc(selectedSpeciality)
                        .collection('niveaux')
                        .doc(selectedLevel)
                        .collection('matieres')
                        .snapshots(),
                    builder: (context, snapshot) {
                      List<DropdownMenuItem<String>> subjectItems = [];

                      if (!snapshot.hasData || selectedSpeciality == null) {
                        return Container();
                      }

                      subjectItems.add(DropdownMenuItem(
                        value: null,
                        child: Text('Select a subject'),
                      ));
                      snapshot.data?.docs.forEach((doc) {
                        subjectItems.add(DropdownMenuItem(
                          value: doc.id,
                          child: Text(doc['name']),
                        ));
                      });

                      return DropdownButton<String>(
                        items: subjectItems,
                        value: selectedSubject,
                        isExpanded: false,
                        hint: Text('Select a subject'),
                        onChanged: (subjectValue) {
                          setState(() {
                            selectedSubject = subjectValue!;
                            selectedGroup = null;
                          });
                          print(subjectValue);
                        },
                      );
                    },
                  ),

                  /////////////////////////////////

                  SizedBox(height: 16),

                  //groups
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('specialities')
                        .doc(selectedSpeciality)
                        .collection('niveaux')
                        .doc(selectedLevel)
                        .collection('matieres')
                        .doc(selectedSubject)
                        .collection('groupes')
                        .snapshots(),
                    builder: (context, snapshot) {
                      List<DropdownMenuItem<String>> groupItems = [];

                      if (!snapshot.hasData || selectedSpeciality == null) {
                        return Container();
                      }

                      groupItems.add(DropdownMenuItem(
                        value: null,
                        child: Text('Select a group'),
                      ));
                      snapshot.data?.docs.forEach((doc) {
                        groupItems.add(DropdownMenuItem(
                          value: doc.id,
                          child: Text(doc['name']),
                        ));
                      });

                      return DropdownButton<String>(
                        items: groupItems,
                        value: selectedGroup,
                        isExpanded: false,
                        hint: Text('Select a group'),
                        onChanged: (groupValue) {
                          setState(() {
                            selectedGroup = groupValue!;
                          });
                          print(groupValue);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
*/