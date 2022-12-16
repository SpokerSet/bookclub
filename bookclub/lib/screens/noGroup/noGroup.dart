import 'package:bookclub/screens/joinGroup/joinGroup.dart';
import 'package:flutter/material.dart';
import '../createGroup/createGroup.dart';

class OurNoGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    void _goToJoin(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OurJoinGroup(
          ),
        ),
      );
    }
    void _goToCreate(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OurCreateGroup(),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                BackButton()
              ],
            ),
          ),
          const Spacer(
            flex: 1,
          ),
          Padding(
            padding: EdgeInsets.all(80.0),
            child: Image.asset("assets/logo.png"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              "Welcome to Book Club",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.grey[600],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Since you are not in a book club, you can select either " +
                  "to join a club or create a club.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.grey[600],
              ),
            ),
          ),
          const Spacer(
            flex: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(
                            color: Theme.of(context).secondaryHeaderColor,
                            width: 1,
                          )
                      )
                  ),
                  onPressed: () => _goToCreate(context),
                  child: const Text("Создать"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(
                            color: Theme.of(context).secondaryHeaderColor,
                            width: 1,
                          )
                      )
                  ),
                  onPressed: () => _goToJoin(context),
                  child: const Text("Присоединиться"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}