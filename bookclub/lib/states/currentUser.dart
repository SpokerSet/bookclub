import 'package:bookclub/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user.dart';

class CurrentUser extends ChangeNotifier {
  OurUser? _currentUser;

  OurUser? get getCurrentUser => _currentUser;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> onStartUp() async{
    String retVal = "error";
    try{
      User _firebaseUser = await _auth.currentUser!;
      _currentUser = await OurDataBase().getUserInfo(_firebaseUser.uid);
      if(_currentUser != null){
        retVal = "success";
      }
    }catch(e){
      print(e);
    }
    return retVal;
  }

  Future<String> signOut() async{
    String retVal = "error";
    try{
      await _auth.signOut();
      _currentUser = null;
      retVal = "success";
    }catch(e){
      print(e);
    }
    return retVal;
  }

  Future<String> sighUpUser(String email, String password, String fullName) async{
    String retVal = "error";
    OurUser _user = OurUser();
    try{
      UserCredential _authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      _user.uid = _authResult.user?.uid;
      _user.email = _authResult.user?.email!;
      _user.fullName = fullName;
      String _returnString = await OurDataBase().createUser(_user);
      if(_returnString == "success"){
        retVal = "success";
      }
    }on PlatformException catch(e){
      retVal = e.toString();
    }catch(e){
      print(e);
    }
    return retVal;
  }

  Future<String> loginUserWithEmail(String email, String password)async{
    String retVal = "error";

    try{
      UserCredential _authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);

      _currentUser = await OurDataBase().getUserInfo(_authResult.user!.uid);
      if(_currentUser != null){
        retVal = "success";
      }
    }catch(e){
      retVal = e.toString();
    }
    return retVal;
  }

  Future<String> loginUserWithGoogle()async{
    String retVal = "error";
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    try{
      OurUser _user = OurUser();
      GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication? _googleAuth = await _googleUser?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(idToken: _googleAuth?.idToken, accessToken: _googleAuth?.accessToken);
      UserCredential _authResult = await _auth.signInWithCredential(credential);

      if(_authResult.additionalUserInfo!.isNewUser){
        _user.uid = _authResult.user?.uid;
        _user.email = _authResult.user?.email;
        _user.fullName = _authResult.user?.displayName;
        OurDataBase().createUser(_user);
      }
      _currentUser = await OurDataBase().getUserInfo(_authResult.user!.uid);
      if(_currentUser != null){
        retVal = "success";
      }
      final user = _authResult.user;
      if(user != null){
        _currentUser?.uid = user.uid;
        _currentUser?.email = user.email!;
        retVal = "success";
      }
    }catch(e){
      retVal = e.toString();
    }
    return retVal;
  }
}
