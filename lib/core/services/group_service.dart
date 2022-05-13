import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_manager/core/models/group.dart';
import 'package:money_manager/core/models/group_payment.dart';

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

  Future<bool> ifGroupExist(String groupId) async {
    try {
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('groups').doc(groupId);
      final snapshot = await userDoc.get();
      return snapshot.exists;
    } on Exception catch (_) {
      return false;
    }
  }

  void addUserToGroup(String groupId) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference groupDoc =
        FirebaseFirestore.instance.collection('groups').doc(groupId);
    final snapshot = await groupDoc.get();
    Map<String, dynamic> groupData = snapshot.data() as Map<String, dynamic>;
    List<String> newParticipantsList = [];
    newParticipantsList =
        List.from(groupData['participants'].map((e) => e['id']));
    newParticipantsList.add(uid);
    groupData['participants'] =
        List.from(newParticipantsList.map((e) => {'id': e}));
    groupDoc.set(groupData);
  }

  Future<List<Group>> getGroups() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final userData = await getUserData(uid);
    // List<Group> groups = [];

    if (userData['groups'] != null) {
      List<String> groupIds = List.from(userData['groups'].map((e) => e['id']));
      return List.from(await Future.wait(groupIds.map((e) async {
        return await getGroupFromId(e);
      })));
    }

    return [];
  }

  Future<Group> getGroupFromId(String groupId) async {
    final groupData = await getGroupData(groupId);
    return Group.fromJson(groupData);
  }

  Future<Map<String, dynamic>> getGroupData(String groupId) async {
    DocumentReference groupDoc =
        FirebaseFirestore.instance.collection('groups').doc(groupId);
    final snapshot = await groupDoc.get();
    Map<String, dynamic> groupData = snapshot.data() as Map<String, dynamic>;
    return groupData;
  }

  Future<void> addPaymentToGroup(String groupId, GroupPayment payment) async {
    Map<String, dynamic> groupData = await getGroupData(groupId);
    if (groupData['payments'] == null) {
      groupData['payments'] = [payment.toJson()];
    } else {
      groupData['payments'].add(payment.toJson());
    }
    DocumentReference groupDoc =
        FirebaseFirestore.instance.collection('groups').doc(groupId);
    groupDoc.set(groupData);
  }

  Future<Map<String, dynamic>> getUserData(String uid) async {
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('users').doc(uid);
    final snapshot = await userDoc.get();
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
    return userData;
  }
}
