import 'package:money_manager/core/models/group_payment.dart';
import 'package:money_manager/core/services/local_storage_service.dart';
import 'package:money_manager/core/view_models/base_viewmodel.dart';

import '../locator.dart';
import '../models/member.dart';
import '../services/group_service.dart';

class GroupViewModel extends BaseViewModel {
  final GroupService _groupService = locator<GroupService>();
  final LocalStorageService _storageService = locator<LocalStorageService>();
  Map<String, double> paymentSummary = {};
  List<String> _selectedParticipants = [];
  List<GroupPayment> _groupPayments = [];

  List<String> get selected => _selectedParticipants;

  Future<List<GroupPayment>> getPayments(String groupId) async {
    await _fetchPayments(groupId);
    return _groupPayments;
  }

  void selectParticipant(String id) {
    _selectedParticipants.add(id);
  }

  void unselectParticipant(String id) {
    _selectedParticipants.remove(id);
  }

  void resetSelectedList() {
    _selectedParticipants = [];
  }

  Future<void> addPayment(String title, double amount, String groupId) async {
    List<Member> members = [];
    for (int i = 0; i < selected.length; i++) {
      String username = await _groupService.getUsername(selected[i]);
      members.add(Member(id: selected[i], username: username));
    }
    String uid = _storageService.currentUserId;
    Member payCreator =
        Member(id: uid, username: await _groupService.getUsername(uid));
    GroupPayment payment = GroupPayment(
      totalAmount: amount,
      title: title,
      participants: members,
      creator: payCreator,
    );
    await _groupService.addPaymentToGroup(groupId, payment);
    _groupPayments.add(payment);
    notifyListeners();
  }

  Future<void> _fetchPayments(String groupId) async {
    _groupPayments =
        await _groupService.getPayments(groupId) as List<GroupPayment>;
  }
}
