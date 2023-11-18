import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pfa_2023_iit/pages/widget/input_field.dart';
import 'package:pfa_2023_iit/utils/global.colors.dart';

class EditLevel extends StatefulWidget {
  final DocumentSnapshot level;

  /* -- Constructor -- */
  EditLevel({required this.level});
  /* ----------------- */

  @override
  State<EditLevel> createState() => _EditLevelState();
}

class _EditLevelState extends State<EditLevel> {
  /* -- Controllers Initialisation -- */
  final nameController = TextEditingController();

  Future<void> updatelevel() async {
    await widget.level.reference.update({
      "name": nameController.text,
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully edited the level')));
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.level.get("name");
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          //width: MediaQuery.of(context).size.width * 4 / 10,
          height: 200,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Modification Niveau",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 4 / 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InputField(
                          hintText: 'Nom',
                          height: 100,
                          width: 200,
                          controller: nameController),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
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
                            final String name = nameController.text;
                            updatelevel();
                            nameController.text = '';
                            Navigator.pop(context);
                          }
                        },
                        child: Text('Modifier')),
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
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 25),
      Text(hintText,
          style: TextStyle(
              fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w600)),
      SizedBox(height: 2),
      SizedBox(
        height: height,
        width: width,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(border: UnderlineInputBorder()),
        ),
      ),
    ],
  );
}
