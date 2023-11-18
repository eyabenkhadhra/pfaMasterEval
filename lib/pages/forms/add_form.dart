import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfa_2023_iit/models/question.dart';
import 'package:pfa_2023_iit/pages/widget/input_field.dart';
import 'package:pfa_2023_iit/utils/dimensions/dimensions.dart';
import 'package:pfa_2023_iit/utils/global.colors.dart';

class AddForm extends StatefulWidget {
  const AddForm({Key? key}) : super(key: key);

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  TextEditingController label = TextEditingController();
  List<TextEditingController> controllers = [];
  bool loading = false;
  @override
  void initState() {
    super.initState();
    controllers.add(TextEditingController()); // Initialize the first controller
  }

  @override
  void dispose() {
    // Dispose the controllers to avoid memory leaks
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: globalcolors.mainColor,
          title: Text("Ajouter formulaire")),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: InputField(
                  hintText: "Libellé de formulaire",
                  height: Constants.screenHeight * 0.06,
                  width: Constants.screenWidth,
                  controller: label,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: controllers.map((e) {
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: InputField(
                          controller: controllers[controllers.indexOf(e)],
                          hintText: 'Question  ${controllers.indexOf(e) + 1}',
                          height: Constants.screenHeight * 0.04,
                          width: Constants.screenWidth,
                          suffix: IconButton(
                            icon: Icon(
                              Icons.remove,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                controllers.remove(e);
                              });
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: loading
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
                                onPressed: () {
                                  setState(() {
                                    controllers.add(
                                        TextEditingController()); // Add a new controller
                                  });
                                },
                                child: Text('Ajouter question'),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (controllers.isNotEmpty) {
                                      setState(() {
                                        loading = true;
                                      });
                                      var form = await FirebaseFirestore
                                          .instance
                                          .collection("forms");
                                      var doc = form.doc();
                                      form.doc(doc.id).set({
                                        "label": label.text,
                                        'id': doc.id,
                                        "date": DateTime.now()
                                      });

                                      for (var q in controllers) {
                                        form
                                            .doc(doc.id)
                                            .collection("questions")
                                            .add(Question(question: q.text)
                                                .toJson());
                                      }
                                      setState(() {
                                        loading = false;
                                      });
                                      Get.back();
                                    } else {
                                      final snackBar = SnackBar(
                                        content: Text(
                                            "Merci d'ajouter au moins un question"),
                                        backgroundColor: (Colors.red),
                                        behavior: SnackBarBehavior.floating,
                                        showCloseIcon: true,
                                        margin: EdgeInsets.all(52),
                                        closeIconColor: Colors.white,
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
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
      ),
    );
  }
}
