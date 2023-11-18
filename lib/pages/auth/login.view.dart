import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:pfa_2023_iit/services/AuthServices.dart';

import '../../utils/global.colors.dart';
import '../../view/widgets/text.form.global.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 168),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 70,
                  backgroundImage: AssetImage("assets/images/logo1.png"),
                ),
              ),

              //SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Connectez-vous ',
                  style: TextStyle(color: globalcolors.textColor, fontSize: 30, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 10),
              //mail input
              Container(
                alignment: Alignment.center,
                child: TextFormGlobal(
                  controller: emailController,
                  text: 'Email',
                  obscure: false,
                  textInputType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(height: 10),

              //password input
              Container(
                alignment: Alignment.center,
                child: TextFormGlobal(
                    controller: passwordController,
                    text: 'Mot de passe',
                    textInputType: TextInputType.emailAddress,
                    obscure: true),
              ),
              SizedBox(height: 10),
              loading
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            AuthServices.checkSignIn(emailController.text, passwordController.text).then((value) {
                              setState(() {
                                loading = false;
                              });
                              if (value) {
                                Get.toNamed("/home");
                              } else {
                                final snackBar = SnackBar(
                                  content: Text("Merci de verfiez vous données"),
                                  backgroundColor: (Colors.red),
                                  behavior: SnackBarBehavior.floating,
                                  showCloseIcon: true,
                                  margin: EdgeInsets.all(52),
                                  closeIconColor: Colors.white,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                            });
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 150,
                          height: 25,
                          decoration: BoxDecoration(
                            color: globalcolors.mainColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: const Text(
                            'Se connecter',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
            ])),
      ),
    ));
  }
}
