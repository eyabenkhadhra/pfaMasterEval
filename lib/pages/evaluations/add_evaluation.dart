import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfa_2023_iit/models/form.dart';
import 'package:pfa_2023_iit/models/group.model.dart';
import 'package:pfa_2023_iit/models/level.model.dart';
import 'package:pfa_2023_iit/models/speciality.model.dart';
import 'package:pfa_2023_iit/models/subject.model.dart';
import 'package:pfa_2023_iit/pages/widget/input_field.dart';
import 'package:pfa_2023_iit/utils/dimensions/dimensions.dart';
import 'package:pfa_2023_iit/utils/global.colors.dart';

class AddEvaluation extends StatefulWidget {
  const AddEvaluation({Key? key}) : super(key: key);

  @override
  State<AddEvaluation> createState() => _AddEvaluationState();
}

class _AddEvaluationState extends State<AddEvaluation> {
  Speciality? speciality;
  Level? selectedLevel;
  Group? selectedGroup;
  Subject? selectedSubject;
  Forms? selectedForm;

  TextEditingController label = TextEditingController();
  bool loading = false;
  bool sendData = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Speciality> specialities = [];
  List<Level> filtredLevels = [];
  List<Group> filtredGroups = [];
  List<Subject> filtredSubjects = [];
  List<Forms> forms = [];

  bool load = false;

  getSpec() async {
    setState(() {
      load = true;
    });
    List<Speciality> specs = [];

    var spec = await FirebaseFirestore.instance.collection("speciality").get();
    for (var data in spec.docs.toList()) {
      specs.add(Speciality.fromJson(data.data() as Map<String, dynamic>));
    }
    setState(() {
      specialities = specs;
      load = false;
    });
  }

  getLevels() async {
    setState(() {
      load = true;
    });
    List<Level> lvls = [];

    var spec = await FirebaseFirestore.instance
        .collection("speciality")
        .where("id", isEqualTo: speciality!.id)
        .get();
    for (var data in spec.docs.toList()) {
      var test = await FirebaseFirestore.instance
          .collection("speciality")
          .doc(data.id)
          .collection("levels")
          .get();
      for (var lvl in test.docs.toList()) {
        lvls.add(Level.fromJson(lvl.data() as Map<String, dynamic>));
      }
    }
    setState(() {
      filtredLevels = lvls;
      load = false;
    });
  }

  getGroups() async {
    setState(() {
      load = true;
    });
    List<Group> grps = [];

    var spec = await FirebaseFirestore.instance
        .collection("speciality")
        .doc(speciality!.id)
        .collection("levels")
        .doc(selectedLevel!.id)
        .collection("groups")
        .get();
    for (var data in spec.docs.toList()) {
      grps.add(Group.fromJson(data.data() as Map<String, dynamic>));
    }
    setState(() {
      filtredGroups = grps;
      load = false;
    });
  }

  getSubjects() async {
    setState(() {
      load = true;
    });
    List<Subject> grps = [];

    var spec = await FirebaseFirestore.instance
        .collection("speciality")
        .doc(speciality!.id)
        .collection("levels")
        .doc(selectedLevel!.id)
        .collection("groups")
        .doc(selectedGroup!.id)
        .collection("subjects")
        .get();
    for (var data in spec.docs.toList()) {
      grps.add(Subject.fromJson(data.data() as Map<String, dynamic>));
    }
    setState(() {
      filtredSubjects = grps;
      load = false;
    });
  }

  getForms() async {
    setState(() {
      load = true;
    });
    List<Forms> frms = [];

    var spec = await FirebaseFirestore.instance.collection("forms").get();
    for (var data in spec.docs.toList()) {
      frms.add(Forms.fromJson(data.data() as Map<String, dynamic>));
    }
    setState(() {
      forms = frms;
      load = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getForms();
    getSpec();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globalcolors.mainColor,
        title: Text("Ajouter evaluation"),
      ),
      body: Center(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: InputField(
                      hintText: "Libellé d'evaluation",
                      height: Constants.screenHeight * 0.06,
                      width: Constants.screenWidth,
                      controller: label,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      height: Constants.screenHeight * 0.04,
                      width: Constants.screenWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                      ),
                      child: DropdownButton<Forms>(
                        borderRadius: BorderRadius.circular(10),
                        isExpanded: true,
                        value: selectedForm,
                        hint: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Selectionner un formulaire"),
                        ),
                        underline: SizedBox(
                          height: 0,
                        ),
                        items: forms.map<DropdownMenuItem<Forms>>((Forms ss) {
                          return DropdownMenuItem<Forms>(
                            key: Key(ss.id.toString()),
                            value: ss,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(ss.label),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedForm = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      height: Constants.screenHeight * 0.04,
                      width: Constants.screenWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                      ),
                      child: DropdownButton<Speciality>(
                        borderRadius: BorderRadius.circular(10),
                        isExpanded: true,
                        value: speciality,
                        hint: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Selectionner Specialité"),
                        ),
                        underline: SizedBox(
                          height: 0,
                        ),
                        items: specialities
                            .map<DropdownMenuItem<Speciality>>((Speciality ss) {
                          return DropdownMenuItem<Speciality>(
                            key: Key(ss.id.toString()),
                            value: ss,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(ss.name),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            speciality = value!;
                            getLevels();
                            selectedLevel = null;
                            filtredLevels = [];
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      height: Constants.screenHeight * 0.04,
                      width: Constants.screenWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                      ),
                      child: DropdownButton<Level>(
                        borderRadius: BorderRadius.circular(10),
                        isExpanded: true,
                        value: selectedLevel,
                        hint: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Selectionner Niveau"),
                        ),
                        underline: SizedBox(
                          height: 0,
                        ),
                        items: filtredLevels
                            .map<DropdownMenuItem<Level>>((Level ss) {
                          return DropdownMenuItem<Level>(
                            key: Key(ss.id.toString()),
                            value: ss,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(ss.name),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedLevel = value!;
                            getGroups();
                            selectedGroup = null;
                            filtredGroups = [];
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      height: Constants.screenHeight * 0.04,
                      width: Constants.screenWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                      ),
                      child: DropdownButton<Group>(
                        borderRadius: BorderRadius.circular(10),
                        isExpanded: true,
                        value: selectedGroup,
                        hint: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Selectionner un group"),
                        ),
                        underline: SizedBox(
                          height: 0,
                        ),
                        items: filtredGroups
                            .map<DropdownMenuItem<Group>>((Group ss) {
                          return DropdownMenuItem<Group>(
                            key: Key(ss.id.toString()),
                            value: ss,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(ss.name),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedGroup = value!;
                            getSubjects();
                            selectedSubject = null;
                            filtredSubjects = [];
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      height: Constants.screenHeight * 0.04,
                      width: Constants.screenWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                      ),
                      child: DropdownButton<Subject>(
                        borderRadius: BorderRadius.circular(10),
                        isExpanded: true,
                        value: selectedSubject,
                        hint: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Selectionner une matiere"),
                        ),
                        underline: SizedBox(
                          height: 0,
                        ),
                        items: filtredSubjects
                            .map<DropdownMenuItem<Subject>>((Subject ss) {
                          return DropdownMenuItem<Subject>(
                            key: Key(ss.id.toString()),
                            value: ss,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(ss.name),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedSubject = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: sendData
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : SizedBox(
                            width: Constants.screenWidth,
                            height: Constants.screenHeight * 0.03,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        if (selectedForm == null) {
                                          final snackBar = SnackBar(
                                            content: Text(
                                                "Merci de selectionner un formulaire"),
                                            backgroundColor: (Colors.red),
                                            behavior: SnackBarBehavior.floating,
                                            showCloseIcon: true,
                                            margin: EdgeInsets.all(52),
                                            closeIconColor: Colors.white,
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        } else if (speciality == null) {
                                          final snackBar = SnackBar(
                                            content: Text(
                                                "Merci de selectionner une specialité"),
                                            backgroundColor: (Colors.red),
                                            behavior: SnackBarBehavior.floating,
                                            showCloseIcon: true,
                                            margin: EdgeInsets.all(52),
                                            closeIconColor: Colors.white,
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        } else if (selectedLevel == null) {
                                          final snackBar = SnackBar(
                                            content: Text(
                                                "Merci de selectionner un niveau"),
                                            backgroundColor: (Colors.red),
                                            behavior: SnackBarBehavior.floating,
                                            showCloseIcon: true,
                                            margin: EdgeInsets.all(52),
                                            closeIconColor: Colors.white,
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        } else if (selectedGroup == null) {
                                          final snackBar = SnackBar(
                                            content: Text(
                                                "Merci de selectionner un group"),
                                            backgroundColor: (Colors.red),
                                            behavior: SnackBarBehavior.floating,
                                            showCloseIcon: true,
                                            margin: EdgeInsets.all(52),
                                            closeIconColor: Colors.white,
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        } else if (selectedSubject == null) {
                                          final snackBar = SnackBar(
                                            content: Text(
                                                "Merci de selectionner une matiére"),
                                            backgroundColor: (Colors.red),
                                            behavior: SnackBarBehavior.floating,
                                            showCloseIcon: true,
                                            margin: EdgeInsets.all(52),
                                            closeIconColor: Colors.white,
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        } else {
                                          setState(() {
                                            sendData = true;
                                          });
                                          var doc = await FirebaseFirestore
                                              .instance
                                              .collection("evaluations")
                                              .doc();
                                          FirebaseFirestore.instance
                                              .collection("evaluations")
                                              .doc(doc.id)
                                              .set({
                                            "label": label.text,
                                            "id": doc.id,
                                            "date": DateTime.now(),
                                            "specId": speciality!.id,
                                            "levelId": selectedLevel!.id,
                                            "grpId": selectedGroup!.id,
                                            "subjectId": selectedSubject!.id,
                                            "A": 0,
                                            "B": 0,
                                            "C": 0,
                                            "D": 0,
                                            "E": 0,
                                            "formId": selectedForm!.id,
                                          });
                                          setState(() {
                                            sendData = false;
                                            Get.back();
                                          });
                                        }
                                      }
                                    },
                                    child: Text('Terminer'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
            load
                ? Container(
                    alignment: Alignment.center,
                    color: globalcolors.mainColor.withOpacity(0.2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        Text(
                          "Chargement ...",
                          style: TextStyle(color: Colors.green),
                        )
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
