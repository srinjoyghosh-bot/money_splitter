import 'package:money_manager/core/models/group_payment.dart';
import 'package:money_manager/core/view_models/base_viewmodel.dart';

import '../locator.dart';
import '../services/group_service.dart';

class GroupViewModel extends BaseViewModel {
  final GroupService _groupService = locator<GroupService>();
  Map<String, double> paymentSummary = {};
  List<String> _selectedParticipants = [];

  List<String> get selected => _selectedParticipants;

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
    GroupPayment payment =
        GroupPayment(totalAmount: amount, title: title, participants: selected);
    await _groupService.addPaymentToGroup(groupId, payment);
  }
}
