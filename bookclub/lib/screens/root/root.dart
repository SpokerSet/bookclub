import 'package:bookclub/screens/home/home.dart';
import 'package:bookclub/screens/login/login.dart';
import 'package:bookclub/screens/noGroup/noGroup.dart';
import 'package:bookclub/screens/splashScreen/splashScreen.dart';
import 'package:bookclub/states/currentUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../states/currentGroup.dart';

enum AuthStatus {
  unknow,
  notLoggedIn,
  notInGroup,
  inGroup,
}

class OurRoot extends StatefulWidget {
  @override
  State<OurRoot> createState() => _OurRootState();
}

class _OurRootState extends State<OurRoot> {
  AuthStatus _authStatus = AuthStatus.unknow;

  @override
  void didChangeDependencies() async{
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    //get state, check user, set AuthStatus based on state
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _returnString = await _currentUser.onStartUp();
    if(_returnString == "success") {
      if (_currentUser.getCurrentUser?.groupId != null) {
        setState(() {
          _authStatus = AuthStatus.inGroup;
        });
      } else {
        setState(() {
          _authStatus = AuthStatus.notInGroup;
        });
      }
    }else {
      setState(() {
        _authStatus = AuthStatus.notLoggedIn;
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    late Widget retVal;
    switch (_authStatus) {
      case AuthStatus.unknow:
        retVal = OurSplashScreen();
        break;
      case AuthStatus.notLoggedIn:
        retVal = OurLogin();
        break;
      case AuthStatus.notInGroup:
        retVal = OurNoGroup();
        break;
      case AuthStatus.inGroup:
        retVal = ChangeNotifierProvider(
            create: (context) => CurrentGroup(),
            child: HomeScreen()
        );
        break;

      default:
    }
    return retVal;
  }
}
