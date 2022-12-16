import 'package:bookclub/models/group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';
import '../models/user.dart';

class OurDataBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createUser(OurUser user) async {
    String retVal = "error";

    try {
      await _firestore.collection("users").doc(user.uid).set({
        'fullName': user.fullName,
        'email': user.email,
        'accountCreated': Timestamp.now(),
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<OurUser> getUserInfo(String uid) async {
    OurUser retVal = OurUser();

    try {
      DocumentSnapshot _docSnapshot = await _firestore.collection("users").doc(uid).get();
      retVal.uid = uid;
      retVal.fullName = _docSnapshot["fullName"];
      retVal.email = _docSnapshot["email"];
      retVal.accountCreated = _docSnapshot["accountCreated"];
      retVal.groupId = _docSnapshot["groupId"];

    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> createGroup(String groupName, String userUid, OurBook initialBook) async {
    String retVal = "error";
    List<String> members = [];

    try {
      members.add(userUid);
      DocumentReference _docRef = await _firestore.collection("groups").add({
        "name" : groupName,
        "leader" : userUid,
        "members" : members,
        "groupCreate" : Timestamp.now(),
      });

      await _firestore.collection("users").doc(userUid).update({
        "groupId" : _docRef.id,
      });

      addBook(_docRef.id, initialBook);

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> joinGroup(String groupId, String userUid) async {
    String retVal = "error";
    List<String> members = [];
    try {
      members.add(userUid);
      await _firestore.collection("groups").doc(groupId).update({
        "members" : FieldValue.arrayUnion(members),
      });
      await _firestore.collection("users").doc(userUid).update({
        "groupId" : groupId,
      });

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<OurGroup> getGroupInfo(String groupId) async {
    OurGroup retVal = OurGroup();

    try {
      DocumentSnapshot _docSnapshot = await _firestore.collection("groups").doc(groupId).get();
      retVal.id = groupId;
      retVal.name = _docSnapshot["name"];
      retVal.leader = _docSnapshot["leader"];
      retVal.groupCreated = _docSnapshot["groupCreate"];
      retVal.currentBookId = _docSnapshot["currentBookId"];
      retVal.currentBookDue = _docSnapshot["currentBookDue"];
      retVal.members = List<String>.from(_docSnapshot["members"]);


    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<OurBook> getCurrentBook(String groupId, String? bookId) async {
    OurBook retVal = OurBook();

    try {
      DocumentSnapshot _docSnapshot = await _firestore.collection("groups").doc(groupId).collection("books").doc(bookId).get();
      retVal.id = bookId;
      retVal.name = _docSnapshot["name"];
      retVal.author = _docSnapshot["author"];
      retVal.length = _docSnapshot["length"];
      retVal.dateCompleted = _docSnapshot["dateCompleted"];


    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> addBook(String groupId, OurBook book) async {
    String retVal = "error";

    try {
      DocumentReference _docRef = await _firestore.collection("groups").doc(groupId).collection("books").add({
        'name': book.name,
        'author': book.author,
        'length': book.length,
        'dateCompleted': book.dateCompleted,
      });

      await _firestore.collection("groups").doc(groupId).update({
        "currentBookId": _docRef.id,
        "currentBookDue": book.dateCompleted,
      });

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> finishedBook(String groupId, String bookId, String uid, int rating, String review) async{
    String retVal = "error";
    try{
      await _firestore.collection("groups").doc(groupId).collection("books").doc(bookId).collection("reviews").doc(uid).set({
        "rating": rating,
        "review": review,
      });
    }catch(e){
      print(e);
    }

    return retVal;
  }

  Future<bool> isUserDoneWithBook(String groupId, String bookId, String uid) async{
    bool retVal = false;
    try{
      DocumentSnapshot _docSnapshot =  await _firestore.collection("groups").doc(groupId).collection("books").doc(bookId).collection("reviews").doc(uid).get();

      if(_docSnapshot.exists){
        retVal = true;
      }

    }catch(e){
      print(e);
    }

    return retVal;
  }
}