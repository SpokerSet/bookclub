import 'package:bookclub/screens/root/root.dart';
import 'package:bookclub/states/currentUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/ourContainer.dart';
import '../../signup/signup.dart';

enum LoginType {
  email,
  google,
}

class OurLoginForm extends StatefulWidget {
  @override
  State<OurLoginForm> createState() => _OurLoginFormState();
}

class _OurLoginFormState extends State<OurLoginForm> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _loginUser({
    required LoginType type,
    required String email,
    required String password,
    required BuildContext context
  })async{
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);

    try{
      late String _returnString;

      switch (type) {
        case LoginType.email:
          _returnString = await _currentUser.loginUserWithEmail(email, password);
          break;
        case LoginType.google:
          _returnString = await _currentUser.loginUserWithGoogle();
          break;
        default:
      }

      if(_returnString == "success"){
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder:
                (context) => OurRoot(),
          ),
              (route) => false,
        );
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

  Widget _googleButton() {
    return OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
            ),
            side: const BorderSide(
                color: Colors.grey
            ),
          ),
          onPressed: () {
            _loginUser(
                type: LoginType.google,
                email: _emailController.text,
                password: _passwordController.text,
                context: context
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Image(image: AssetImage("assets/google_logo.png"), height: 25.0),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Вход с помощью Google',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OurContainer(
      child: Column(
        children: <Widget>[
          Padding(padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
          child: Text("Войти",
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
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
          ElevatedButton(
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: Text(
                "Войти",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            onPressed: () {
              _loginUser(
                  type: LoginType.email,
                  email: _emailController.text,
                  password: _passwordController.text,
                  context: context
              );
            },
          ),
          TextButton(
            style: const ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context)=>OurSignup(),)
              );
            },
            child: const Text("Нет аккаунта? Зарегистрируйся"),
          ),
          _googleButton()
        ],
      )
    );
  }
}