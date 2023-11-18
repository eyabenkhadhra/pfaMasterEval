import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pfa_2023_iit/pages/widget/input_field.dart';
import 'package:pfa_2023_iit/utils/dimensions/dimensions.dart';
import 'package:pfa_2023_iit/utils/global.colors.dart';

class AddSpeciality extends StatefulWidget {
  final int number;
  const AddSpeciality({super.key, required this.number});

  @override
  State<AddSpeciality> createState() => _AddSpecialityState();
}

class _AddSpecialityState extends State<AddSpeciality> {
  String id = DateTime.now().millisecondsSinceEpoch.toString();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /* -- Controllers Initialisation -- */
  final nameController = TextEditingController();
  final desController = TextEditingController();
  // Variable pour stocker la valeur sélectionnée
  /* --------------------------------- */

  /* -- Firebase Instance to "specialities" collection -- */
  final CollectionReference specialitiesCollectionReference =
      FirebaseFirestore.instance.collection('speciality');
  /* ----------------------- */

  /* -- Function that creates the user in the Firebase Firestore -- */
  Future<void> createSpeciality() async {
    await specialitiesCollectionReference.doc(id).set({
      "name": nameController.text,
      "description": desController.text,
      "id": id
    });
    await FirebaseFirestore.instance
        .collection("settings")
        .doc('first')
        .update({"spec": widget.number + 1});

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully added a speciality')));
  }
  /* --------------------------------------------------------------- */

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
                "Ajouter Specialité",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 4 / 10,
                child: Form(
                  key: _formKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InputField(
                          hintText: 'Nom',
                          height: Constants.screenHeight * 0.06,
                          width: 200,
                          controller: nameController),
                      InputField(
                          hintText: 'Description',
                          height: Constants.screenHeight * 0.06,
                          width: 200,
                          controller: desController),
                    ],
                  ),
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
                          createSpeciality();
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Créer une Specialité')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
