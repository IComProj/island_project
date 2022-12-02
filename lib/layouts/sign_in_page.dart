import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:island_project/data/color_palette.dart';
import 'package:island_project/data/preference_constants.dart';
import 'package:island_project/data/userdata.dart';
import 'package:island_project/utilities/firebase_utilities.dart';
import 'package:island_project/utilities/layout_utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<StatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String _email = "";
  String _password = "";
  String _userName = "";

  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var emailField = TextField(
      onChanged: (value) {
        _email = value.trim();
      },
      decoration: const InputDecoration(
          border: OutlineInputBorder(), labelText: "Email"),
      cursorColor: Colors.white,
      controller: _emailController,
    );

    var pwdField = TextField(
      obscureText: true,
      decoration: const InputDecoration(
          border: OutlineInputBorder(), labelText: "Passwort"),
      onChanged: (value) {
        _password = value.trim();
      },
      cursorColor: Colors.white,
      controller: _pwdController,
    );

    var usrNameField = TextField(
      decoration: const InputDecoration(
          border: OutlineInputBorder(), labelText: "Benutzername"),
      onChanged: (value) {
        _userName = value;
      },
      cursorColor: Colors.white,
      maxLength: 20,
      controller: _userNameController,
    );

    SharedPreferences.getInstance().then((prefs) {
      var em = prefs.getString(PreferenceConstants.prefnameEmail);
      var pwd = prefs.getString(PreferenceConstants.prefnamePassword);
      var usrnm = prefs.getString(PreferenceConstants.prefnameUserName);

      _emailController.text = em ?? "";
      _email = em ?? "";

      _pwdController.text = pwd ?? "";
      _password = pwd ?? "";

      _userNameController.text = usrnm ?? "";
      _userName = usrnm ?? "";
    });

    return Scaffold(
        body: Center(
            child: Column(children: [
      Card(
        //color: ColorPalette.background,
        child: Center(
          heightFactor: 2,
          child: Text(
            //style: StyleCollection.defaultTextStyle,
            "Du musst dich anmelden, um auf das Projekt zuzugreifen.",
            textAlign: TextAlign.center,
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      emailField,
      pwdField,
      usrNameField,
      TextButton(
        onPressed: () {
          if (_userName == "") {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text(
                      "Fülle bitte auch das Benutzernamen-Feld aus!"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("OK"),
                    )
                  ],
                );
              },
            );

            return;
          }

          SharedPreferences.getInstance().then((prefs) async {
            //await prefs.clear();

            prefs.setString(PreferenceConstants.prefnameEmail, _email);
            prefs.setString(PreferenceConstants.prefnamePassword, _password);

            FirebaseUtilities.instance.signIn(_email, _password).then((value) {
              print(
                  "Saving user: $_userName , ${FirebaseAuth.instance.currentUser?.uid ?? ""}");

              FirebaseUtilities.instance.getCurrentUserData().then((userData) {
                if (userData.isEmpty) {
                  userData.uid = FirebaseAuth.instance.currentUser!.uid;
                }

                userData.name = _userName;

                userData.serializeToSharedPrefs();

                FirebaseUtilities.instance.updateUserData(userData);
              });
            });
          });
        },
        //style: StyleCollection.defaultButtonStyle,
        child: const Text("Sign in"),
      )
    ])));
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _pwdController.dispose();
    _userNameController.dispose();
  }
}
