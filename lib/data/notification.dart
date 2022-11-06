import 'package:firebase_database/firebase_database.dart';

class Notification {
  Notification(this.modificationDate, this.message, this.iconID);

  String modificationDate;
  String message;
  int iconID;

  static List<Notification> parseFromSnapshot(DataSnapshot snapshot) {
    if (!snapshot.exists) return List.empty();

    List<Notification> notes = List.empty(growable: true);

    for (var child in snapshot.children) {
      Notification note = Notification("", "", 0);

      if (child.hasChild("message")) {
        note.message = child.child("message").value as String;
      }
      if (child.hasChild("modified")) {
        note.modificationDate = child.child("modified").value as String;
      }
      if (child.hasChild("iconID")) {
        note.iconID = child.child("iconID").value as int;
      }

      if (note.iconID != 0 &&
          note.message != "" &&
          note.modificationDate != "") {
        notes.add(note);
      }
    }

    return notes;
  }
}
