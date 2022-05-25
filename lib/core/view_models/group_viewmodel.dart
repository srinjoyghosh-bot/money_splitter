import 'package:money_manager/core/constants/enum/view_state.dart';
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
    paymentSummary = {};
    return _groupPayments;
  }

  List<GroupPayment> get payments => _groupPayments;

  Map<String, double> get summary => paymentSummary;

  void selectParticipant(String id) {
    if (!_selectedParticipants.contains(id)) {
      _selectedParticipants.add(id);
    }
  }

  void unselectParticipant(String id) {
    if (_selectedParticipants.contains(id)) {
      _selectedParticipants.remove(id);
    }
  }

  void resetSelectedList() {
    _selectedParticipants = [];
  }

  void reset() {
    paymentSummary = {};
    _groupPayments = [];
  }

  Future<void> addPayment(String title, double amount, String groupId) async {
    setState(ViewState.busy);
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
    setState(ViewState.idle);
  }

  Future<void> _fetchPayments(String groupId) async {
    _groupPayments =
        await _groupService.getPayments(groupId) as List<GroupPayment>;
  }

  void calculatePaymentSummary() {
    paymentSummary = {};

    List<GroupPayment> involvedPayments = _groupPayments
        .where((payment) => payment.participants
            .any((member) => member.id == _storageService.currentUserId))
        .toList();
    for (GroupPayment payment in involvedPayments) {
      if (payment.creator.id != _storageService.currentUserId) {
        if (paymentSummary[payment.creator.username] == null) {
          paymentSummary[payment.creator.username] =
              payment.totalAmount / payment.participants.length;
        } else {
          paymentSummary.update(
              payment.creator.username,
              (value) =>
                  value + (payment.totalAmount / payment.participants.length));
        }
      } else {
        for (Member member in payment.participants) {
          if (member.id != _storageService.currentUserId) {
            if (paymentSummary[member.username] == null) {
              paymentSummary[member.username] =
                  -(payment.totalAmount / payment.participants.length);
            } else {
              paymentSummary.update(
                  member.username,
                  (value) =>
                      value -
                      (payment.totalAmount / payment.participants.length));
            }
          }
        }
      }
    }
    notifyListeners();
  }
}
