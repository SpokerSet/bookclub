import 'package:cloud_firestore/cloud_firestore.dart';

class OurGroup {
  String? id;
  String? name;
  String? leader;
  String? currentBookId;
  Timestamp? groupCreated;
  Timestamp? currentBookDue;
  List<String>? members;

  OurGroup({
    this.id,
    this.name,
    this.leader,
    this.currentBookId,
    this.currentBookDue,
    this.groupCreated,
    this.members,

  });


}