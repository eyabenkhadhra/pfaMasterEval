import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pfa_2023_iit/models/evaluation.dart';
import 'package:pfa_2023_iit/models/group.model.dart';
import 'package:pfa_2023_iit/models/level.model.dart';
import 'package:pfa_2023_iit/models/question.dart';
import 'package:pfa_2023_iit/models/speciality.model.dart';
import 'package:pfa_2023_iit/models/subject.model.dart';
import 'package:pfa_2023_iit/pages/widget/input_field.dart';
import 'package:pfa_2023_iit/utils/dimensions/dimensions.dart';

class SubmitForm extends StatefulWidget {
  final String evalId;
  const SubmitForm({Key? key, required this.evalId}) : super(key: key);

  @override
  State<SubmitForm> createState() => _SubmitFormState();
}

class _SubmitFormState extends State<SubmitForm> {
  late Speciality speciality;
  late Level level;
  late Group group;
  late Subject subject;
  List<Question> questions = [];
  bool wrongData = false;
  bool loadingData = false;
  getData() async {
    setState(() {
      loadingData = true;
    });
    List<Question> qsList = [];
    var eval = await FirebaseFirestore.instance.collection("evaluations").doc(widget.evalId).get();
    if (!eval.exists) {
      setState(() {
        wrongData = true;
      });
      return;
    }
    Evaluation evaluation1 = Evaluation.fromJson(eval.data() as Map<String, dynamic>);
    var spec = await FirebaseFirestore.instance.collection("speciality").doc(evaluation1.specId).get();
    Speciality speciality1 = Speciality.fromJson(spec.data() as Map<String, dynamic>);
    var lev = await FirebaseFirestore.instance
        .collection("speciality")
        .doc(speciality1.id)
        .collection("levels")
        .doc(evaluation1.levelId)
        .get();
    Level level1 = Level.fromJson(lev.data() as Map<String, dynamic>);
    var grp = await FirebaseFirestore.instance
        .collection("speciality")
        .doc(speciality1.id)
        .collection("levels")
        .doc(evaluation1.levelId)
        .collection('groups')
        .doc(evaluation1.grpId)
        .get();
    Group group1 = Group.fromJson(grp.data() as Map<String, dynamic>);
    var sub = await FirebaseFirestore.instance
        .collection("speciality")
        .doc(speciality1.id)
        .collection("levels")
        .doc(evaluation1.levelId)
        .collection('groups')
        .doc(evaluation1.grpId)
        .collection("subjects")
        .doc(evaluation1.subjectId)
        .get();
    Subject subject1 = Subject.fromJson(sub.data() as Map<String, dynamic>);
    var qsData = await FirebaseFirestore.instance.collection("forms").doc(evaluation1.formId).collection("questions").get();
    for (var test in qsData.docs.toList()) {
      qsList.add(Question.fromJson(test.data() as Map<String, dynamic>));
    }
    setState(() {
      loadingData = false;
      speciality = speciality1;
      level = level1;
      group = group1;
      subject = subject1;
      questions = qsList;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  bool sendData = false;
  bool done = false;
  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    window.onBeforeUnload.listen((Event event) {
      // Cancel the event to prevent the page from refreshing
      event.preventDefault();

      // Set the message to display when the user tries to refresh the page
      (event as BeforeUnloadEvent).returnValue = 'Are you sure you want to leave this page?';
    });
    return WillPopScope(
      onWillPop: () async {
        window.close();
        return false;
      },
      child: RefreshIndicator(
        onRefresh: () async {
          window.close();
        },
        child: Scaffold(
            body: loadingData
                ? wrongData
                    ? Center(
                        child: Text("Merci de verfier le code Qr"),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      )
                : done
                    ? Center(
                        child: Text("Merci pour votre avis "),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue),
                                  width: Constants.screenWidth,
                                  height: Constants.screenHeight * 0.04,
                                  child: Text(
                                    "Specialité : ${speciality.name}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue),
                                  width: Constants.screenWidth,
                                  height: Constants.screenHeight * 0.04,
                                  child: Text(
                                    "Niveau : ${level.name}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue),
                                  width: Constants.screenWidth,
                                  height: Constants.screenHeight * 0.04,
                                  child: Text(
                                    "Group : ${group.name}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue),
                                  width: Constants.screenWidth,
                                  height: Constants.screenHeight * 0.04,
                                  child: Text(
                                    "Matiere : ${subject.name}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              ...questions.map((e) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${questions.indexOf(e) + 1} ) ${e.question} :",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: 'A',
                                            groupValue: e.option,
                                            onChanged: (value) {
                                              setState(() {
                                                e.option = value as String;
                                              });
                                            },
                                          ),
                                          Text('A'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: 'B',
                                            groupValue: e.option,
                                            onChanged: (value) {
                                              setState(() {
                                                e.option = value as String;
                                              });
                                            },
                                          ),
                                          Text('B'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: 'C',
                                            groupValue: e.option,
                                            onChanged: (value) {
                                              setState(() {
                                                e.option = value as String;
                                              });
                                            },
                                          ),
                                          Text('C'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: 'D',
                                            groupValue: e.option,
                                            onChanged: (value) {
                                              setState(() {
                                                e.option = value as String;
                                              });
                                            },
                                          ),
                                          Text('D'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: 'E',
                                            groupValue: e.option,
                                            onChanged: (value) {
                                              setState(() {
                                                e.option = value as String;
                                              });
                                            },
                                          ),
                                          Text('E'),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }),
                              InputField(
                                  lines: 5,
                                  hintText: "Ajouter commentaire",
                                  height: Constants.screenHeight * 0.1,
                                  width: Constants.screenWidth,
                                  controller: commentController),
                              sendData
                                  ? Container(
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(),
                                        ],
                                      ))
                                  : Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: SizedBox(
                                        width: Constants.screenWidth,
                                        height: Constants.screenHeight * 0.05,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                            onPressed: () async {
                                              setState(() {
                                                sendData = true;
                                              });
                                              int A = 0;
                                              int B = 0;
                                              int C = 0;
                                              int D = 0;
                                              int E = 0;
                                              for (var data in questions) {
                                                switch (data.option) {
                                                  case "A":
                                                    A++;
                                                    break;
                                                  case "B":
                                                    B++;
                                                    break;
                                                  case "C":
                                                    C++;
                                                    break;
                                                  case "D":
                                                    D++;
                                                    break;
                                                  case "E":
                                                    E++;
                                                    break;
                                                }
                                              }
                                              var data = await FirebaseFirestore.instance
                                                  .collection("evaluations")
                                                  .doc(widget.evalId)
                                                  .get();
                                              A = data.get("A") + A;
                                              B = data.get("B") + B;
                                              C = data.get("C") + C;
                                              D = data.get("D") + D;
                                              E = data.get("E") + E;
                                              await FirebaseFirestore.instance
                                                  .collection("evaluations")
                                                  .doc(widget.evalId)
                                                  .update({
                                                "A": A,
                                                "B": B,
                                                "C": C,
                                                "D": D,
                                                "E": E,
                                              });
                                              setState(() {
                                                sendData = false;
                                                done = true;
                                              });
                                            },
                                            child: Text("Sommetre")),
                                      ),
                                    )
                            ],
                          ),
                        ),
                      )),
      ),
    );
  }
}
