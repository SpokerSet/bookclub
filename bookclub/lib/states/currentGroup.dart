import 'package:bookclub/models/book.dart';
import 'package:bookclub/models/group.dart';
import 'package:bookclub/services/database.dart';
import 'package:flutter/material.dart';

class CurrentGroup extends ChangeNotifier {
  OurGroup _currentGroup = OurGroup();
  OurBook _currentBook = OurBook();
  bool _doneWithCurrentBook = false;

  OurGroup get getCurrentGroup => _currentGroup;
  OurBook get getCurrentBook => _currentBook;
  bool get getDoneWithCurrentBook => _doneWithCurrentBook;

  void updateStateFromDataBase(String groupId, String userUid) async{
    try{
      _currentGroup = await OurDataBase().getGroupInfo(groupId);
      _currentBook = await OurDataBase().getCurrentBook(groupId, _currentGroup.currentBookId ?? "");
      _doneWithCurrentBook = await OurDataBase().isUserDoneWithBook(groupId, _currentGroup.currentBookId ?? "", userUid);
      notifyListeners();

    }catch(e){
      print(e);
    }
  }

  void finishedBook(String userUid, int rating, String review) async{
    try{
      await OurDataBase().finishedBook(_currentGroup.id ?? "", _currentGroup.currentBookId ?? "", userUid, rating, review);
      _doneWithCurrentBook = true;
      notifyListeners();
    }catch(e){
      print(e);
    }
  }
}
