import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pfa_2023_iit/models/speciality.model.dart';
import 'package:pfa_2023_iit/utils/global.colors.dart';

class EditSpeciality extends StatefulWidget {
  // Attribute which hold the information of the selected ressource
  //final DocumentSnapshot documentSnapshot;
  final Speciality speciality;

  /* -- Constructor -- */
  EditSpeciality({required this.speciality});
  /* ----------------- */

  @override
  State<EditSpeciality> createState() => _EditSpecialityState();
}

class _EditSpecialityState extends State<EditSpeciality> {
  /* -- Controllers Initialisation -- */
  final nameController = TextEditingController();
  final desController = TextEditingController();

  /* --------------------------------- */

  /* -- Firebase Instance to "ressources" collection -- */
  final CollectionReference specialitiesCollectionReference =
      FirebaseFirestore.instance.collection('speciality');
  /* ----------------------- */

  Future<void> updatespeciality(Speciality speciality) async {
    await specialitiesCollectionReference.doc(widget.speciality.id).update({
      "name": nameController.text,
      "description": desController.text,
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully edited the speciality')));
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.speciality.getName();
    desController.text = widget.speciality.getDes();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Modification Specialité",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 4 / 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textField(
                          hintText: 'Nom',
                          height: 100,
                          width: 200,
                          controller: nameController),
                      textField(
                          hintText: 'Description',
                          height: 100,
                          width: 200,
                          controller: desController),
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
                            // Missing Conditions
                            final String name = nameController.text;
                            final String description = desController.text;
                            updatespeciality(widget.speciality);
                            nameController.text = '';
                            desController.text = '';
                            Navigator.pop(context);
                          }
                        },
                        child: Text('Modifier ')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* -- Customized TextField Widget -- */
Widget textField(
    {required String hintText,
    required double height,
    required double width,
    required TextEditingController controller}) {
  return SizedBox(
    height: height,
    width: width,
    child: TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "champ obligatoire";
        }
      },
      controller: controller,
      decoration: InputDecoration(
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            width: 2.0,
            color: Colors.blue.withOpacity(0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: Colors.blue,
            width: 2.0,
          ),
        ),
      ),
    ),
  );
} /* --------------------------------- */
