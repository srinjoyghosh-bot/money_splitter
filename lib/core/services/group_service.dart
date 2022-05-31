import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_manager/core/models/group.dart';
import 'package:money_manager/core/models/group_payment.dart';
import 'package:money_manager/core/models/member.dart';
import 'package:uuid/uuid.dart';

class GroupService {
  Future<String> createGroup(String name) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('users').doc(uid);
    final snapshot = await userDoc.get();
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
    Member member = Member(id: uid, username: userData['username']);

    String groupId = const Uuid().v1();
    Group group = Group(id: groupId, name: name, participants: [member]);
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
    final userData = await getUserData(uid);
    DocumentReference groupDoc =
        FirebaseFirestore.instance.collection('groups').doc(groupId);
    final snapshot = await groupDoc.get();
    Map<String, dynamic> groupData = snapshot.data() as Map<String, dynamic>;
    List<Member> newParticipantsList = [];
    newParticipantsList =
        List.from(groupData['participants'].map((e) => Member.fromJson(e)));
    newParticipantsList.add(Member(id: uid, username: userData['username']));
    groupData['participants'] =
        List.from(newParticipantsList.map((e) => e.toJson()));
    groupDoc.set(groupData);
  }

  // Future<List<Group>> getGroups() async {
  //   String uid = FirebaseAuth.instance.currentUser!.uid;
  //   final userData = await getUserData(uid);
  //
  //   if (userData['groups'] != null) {
  //     List<String> groupIds = List.from(userData['groups'].map((e) => e['id']));
  //
  //     List<Group> groups =
  //         List<Group>.from(await Future.wait(groupIds.map(getGroupFromId)));
  //     return groups;
  //   }
  //
  //   return [];
  // }

  Future<List<Group>> getUserGroups() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection('groups').get();
    List<Group> groupData = List.from(snap.docs
        .map((e) => Group.fromJson((e.data() as Map<String, dynamic>))));
    // List<Group> userGroups =
    //     groupData.where((group) => group.participants).toList();
    List<Group> userGroups = groupData
        .where((group) => group.participants.any((member) => member.id == uid))
        .toList();
    return userGroups;
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

  Future<List> getPayments(String groupId) async {
    Map<String, dynamic> data = await getGroupData(groupId);
    if (data['payments'] != null) {
      return List<GroupPayment>.from(
          data['payments'].map((e) => GroupPayment.fromJson(e)));
    }
    return [];
  }

  Future<Map<String, dynamic>> getUserData(String uid) async {
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('users').doc(uid);
    final snapshot = await userDoc.get();
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
    return userData;
  }

  Future<String> getUsername(String id) async {
    final userData = await getUserData(id);
    return userData['username'];
  }

  Future<void> removeGroupFromUser(String uid, String groupId) async {
    Map<String, dynamic> data = await getUserData(uid);
    List<String> groups = List.from(data['groups'].map((e) => e['id']));
    groups.remove(groupId);
    data['groups'] = List.from(groups.map((e) => {'id': e}));
    FirebaseFirestore.instance.collection('users').doc(uid).set(data);
  }

  Future<void> removeUserFromGroup(String uid, String groupId) async {
    Map<String, dynamic> data = await getGroupData(groupId);
    List<Member> members =
        List<Member>.from(data['participants'].map((e) => Member.fromJson(e)));
    if (members.length != 1) {
      members.removeWhere((member) => member.id == uid);
      data['participants'] = List.from(members.map((e) => e.toJson()));
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .set(data);
    } else {
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .delete();
    }
  }
}
