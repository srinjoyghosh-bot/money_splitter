import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart' as usr;

class DatabaseService {
  void addUser(usr.User user) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.doc(user.uid).set(user.toJson());
  }

  void addGroupToUser(String groupId) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('users').doc(uid);
    final snapshot = await userDoc.get();
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
    List<String> newGroupList = [];
    if (userData['groups'] == null) {
      newGroupList = [groupId];
    } else {
      newGroupList = List.from(userData['groups'].map((e) => e['id']));
      newGroupList.add(groupId);
    }
    userData['groups'] = List.from(newGroupList.map((e) => {'id': e}));
    userDoc.set(userData);
  }
}
