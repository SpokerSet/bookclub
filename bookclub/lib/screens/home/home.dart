import 'dart:async';

import 'package:bookclub/screens/addBook/addBook.dart';
import 'package:bookclub/screens/noGroup/noGroup.dart';
import 'package:bookclub/screens/review/review.dart';
import 'package:bookclub/screens/root/root.dart';
import 'package:bookclub/states/currentGroup.dart';
import 'package:bookclub/states/currentUser.dart';
import 'package:bookclub/widgets/ourContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/timeLeft.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen>{
  List<String> _timeUntil = ["",""];

  late Timer _timer;

  void _startTimer(CurrentGroup currentGroup){
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState((){
        _timeUntil = OurTimeLeft().timeLeft(currentGroup.getCurrentGroup.currentBookDue!.toDate());
      });
    });
  }
@override
  void initState() {
    super.initState();

    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    CurrentGroup _currentGroup = Provider.of<CurrentGroup>(context, listen: false);

    _currentGroup.updateStateFromDataBase(_currentUser.getCurrentUser?.groupId ?? "", _currentUser.getCurrentUser?.uid ?? "");
    _startTimer(_currentGroup);
  }

  @override
  void dispose(){
    _timer.cancel();
    super.dispose();
  }

  void _goToAddBook(BuildContext context){
    Navigator.push(
      context, MaterialPageRoute(
        builder: (context) => OurAddBook(
          onGroupCreation: false,
        ),
      ),
    );
  }

  void _goToReview(BuildContext context){
    CurrentGroup _currentGroup = Provider.of<CurrentGroup>(context, listen: false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OurReview(
          currentGroup: _currentGroup,
        ),
      ),
    );
  }

  void _signOut(BuildContext context) async{

    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _returnString = await _currentUser.signOut();
    if(_returnString == "success"){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder:
              (context) => OurRoot(),
        ),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: OurContainer(
              child: Consumer<CurrentGroup>(
                builder: (BuildContext context, value, Widget? child) {
                  return Column(
                    children: <Widget>[
                      Text(
                        value.getCurrentBook.name ?? "Загрузка...",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.grey[600],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          children: <Widget>[
                            Text("Остаётся: ",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.grey[600],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                _timeUntil[0],
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: BorderSide(
                                  color: Theme
                                      .of(context)
                                      .secondaryHeaderColor,
                                  width: 1,
                                )
                            )
                        ),
                        child: const Text(
                          "Закончить книгу",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: ()=> value.getDoneWithCurrentBook ? null : _goToReview(context),

                      ),
                    ],
                  );
                }
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: OurContainer(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Следующая\nкнига: ",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.grey[600],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          _timeUntil[1],
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(
                        color: Theme.of(context).secondaryHeaderColor,
                        width: 1,
                      )
                  )
              ),
              onPressed: () => _goToAddBook(context),
              child: const Text("Книжный клуб",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(
                    color: Theme.of(context).secondaryHeaderColor,
                    width: 1,
                  )
                )
              ),
              onPressed: () => _signOut(context),
              child: const Text("Выход"),
            ),
          ),
        ],
      ),
    );
  }
}
