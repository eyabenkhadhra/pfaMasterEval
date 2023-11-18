import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pfa_2023_iit/pages/widget/input_field.dart';
import 'package:pfa_2023_iit/utils/dimensions/dimensions.dart';
import 'package:pfa_2023_iit/utils/global.colors.dart';

class AddSubject extends StatefulWidget {
  final String idLevel;
  final String idSpec;
  final String idGrp;
  final int number;
  const AddSubject(
      {super.key,
      required this.number,
      required this.idLevel,
      required this.idSpec,
      required this.idGrp});

  @override
  State<AddSubject> createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  String id = DateTime.now().millisecondsSinceEpoch.toString();

  /* -- Controllers Initialisation -- */
  final nameController = TextEditingController();

  /* -- Function that creates the user in the Firebase Firestore -- */
  Future<void> createSubject() async {
    print(widget.idSpec);
    print(widget.idGrp);
    print(widget.idLevel);
    await FirebaseFirestore.instance
        .collection('speciality')
        .doc(widget.idSpec)
        .collection("levels")
        .doc(widget.idLevel)
        .collection("groups")
        .doc(widget.idGrp)
        .collection("subjects")
        .doc(id)
        .set({"name": nameController.text, "id": id});
    await FirebaseFirestore.instance
        .collection("settings")
        .doc('first')
        .update({"subs": widget.number + 1});

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have successfully added a subject')));
  }

  /* --------------------------------------------------------------- */
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Ajouter Matiére",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 4 / 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Form(
                      child: InputField(
                          hintText: 'Nom',
                          height: Constants.screenHeight * 0.06,
                          width: 200,
                          controller: nameController),
                      key: _formKey,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Center(
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(globalcolors.mainColor),
                        fixedSize:
                            MaterialStateProperty.all(const Size(200, 40)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          createSubject();
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Créer une matiére')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
