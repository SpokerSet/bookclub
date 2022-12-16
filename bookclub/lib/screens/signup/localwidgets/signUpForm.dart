import 'package:bookclub/states/currentUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/ourContainer.dart';


class OurSignUpForm extends StatefulWidget {
  @override
  State<OurSignUpForm> createState() => _OurSignUpFormState();
}

class _OurSignUpFormState extends State<OurSignUpForm> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswodController = TextEditingController();

  void _signUpUser(String email, String password, BuildContext context, String fullName)async{
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    try{
      String _returnString = await _currentUser.sighUpUser(email, password, fullName);
      if(_returnString == "success"){
        Navigator.pop(context);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_returnString),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OurContainer(
        child: Column(
          children: <Widget>[
            Padding(padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
              child: Text("Регистрация",
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextFormField(
              controller: _fullNameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_outlined),
                hintText: "Имя",
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.alternate_email),
                hintText: "Почта",
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                hintText: "Пароль",
              ),
              obscureText: true,
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: _confirmPasswodController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock_open),
                hintText: "Подтверждение пароля",
              ),
              obscureText: true,
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 100),
                child: Text(
                  "Регистрация",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.0,
                  ),
                ),
              ),
              onPressed: () {
                if(_passwordController.text == _confirmPasswodController.text){
                  _signUpUser(_emailController.text, _passwordController.text, context, _fullNameController.text);
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Password don't match"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ],
        )
    );
  }
}