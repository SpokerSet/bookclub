import 'package:bookclub/screens/root/root.dart';
import 'package:bookclub/services/database.dart';
import 'package:bookclub/states/currentUser.dart';
import 'package:bookclub/widgets/ourContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/book.dart';

class OurAddBook extends StatefulWidget {
  final bool? onGroupCreation;
  final String? groupName;

  OurAddBook({
    this.onGroupCreation,
    this.groupName,
});
  @override
  _OurAddBookState createState() => _OurAddBookState();
}

class _OurAddBookState extends State<OurAddBook> {
  TextEditingController _bookNameController = TextEditingController();
  TextEditingController _authorController = TextEditingController();
  TextEditingController _lengthController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async{
    final DateTime? picked = await DatePicker.showDateTimePicker(context, showTitleActions: true);
    if(picked != null && picked != _selectedDate){
      setState((){
        _selectedDate = picked;
      });
    }
  }


  void _addBook(BuildContext context, String groupName, OurBook book) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _returnString;
    if(widget.onGroupCreation ?? false){
      _returnString = await OurDataBase().createGroup(groupName, _currentUser.getCurrentUser?.uid ?? "", book);
    }else{
      _returnString = await OurDataBase().addBook(_currentUser.getCurrentUser?.groupId ?? "", book);
    }

    if(_returnString == "success"){
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => OurRoot(),
          ),
              (route) => false
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[BackButton()],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: OurContainer(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _bookNameController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.group),
                      hintText: "Название",
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: _authorController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.group),
                      hintText: "Автор",
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: _lengthController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.group),
                      hintText: "Объём",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(DateFormat.yMMMd("en_US").format(_selectedDate)),
                  Text(DateFormat("H:mm").format(_selectedDate)),
                  TextButton(
                      onPressed: ()=> _selectDate(context),
                      child: Text("Поменять дату"),
                  ),

                  ElevatedButton(
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 80),
                        child: Text(
                          "Создать",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      onPressed: () {
                        OurBook book = OurBook();
                        book.name = _bookNameController.text;
                        book.author = _authorController.text;
                        book.length = int.parse(_lengthController.text);
                        book.dateCompleted = Timestamp.fromDate(_selectedDate);

                        _addBook(context, widget.groupName ?? "", book);

                      }
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}