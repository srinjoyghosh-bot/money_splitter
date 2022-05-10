import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_manager/core/models/group.dart';

class GroupService {
  Future<String> createGroup(String name) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('users').doc(uid);
    final snapshot = await userDoc.get();
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;

    int num = userData['groups'] != null ? userData['groups'].length + 1 : 1;
    String groupId = uid + num.toString();
    Group group = Group(id: groupId, name: name, participants: [uid]);
    CollectionReference reference =
        FirebaseFirestore.instance.collection('groups');
    reference.doc(groupId).set(group.toJson());
    return groupId;
  }
}
