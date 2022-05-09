import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';

class DatabaseService {
  void addUser(User user) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.doc(user.uid).set(user.toJson());
  }
}
