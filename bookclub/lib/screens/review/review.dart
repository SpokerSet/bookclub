import 'package:bookclub/states/currentGroup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../states/currentUser.dart';
import '../../widgets/ourContainer.dart';

class OurReview extends StatefulWidget {
  late final CurrentGroup currentGroup;
  OurReview({required this.currentGroup});

  @override
  _OurReviewState createState() => _OurReviewState();
}

class _OurReviewState extends State<OurReview> {
  TextEditingController _reviewController = TextEditingController();
  int _dropdownValue = 1;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[BackButton()],
            ),
          ),
          Spacer(),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: OurContainer(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text("Рейтинг книги 1-10:"),
                      DropdownButton<int>(
                        value: _dropdownValue,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor),
                        underline: Container(
                          height: 2,
                          color: Theme.of(context).canvasColor,
                        ),
                        onChanged: (int? newValue) {
                          setState(() {
                            _dropdownValue = newValue!;
                          });
                        },
                        items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _reviewController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: "Отзыв",
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 80),
                        child: Text(
                          "Добавить отзыв",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      onPressed: () {
                        String? uid = Provider.of<CurrentUser>(context, listen: false).getCurrentUser?.uid;
                        widget.currentGroup.finishedBook(uid!, _dropdownValue, _reviewController.text);
                        Navigator.pop(context);
                      }
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}