import 'package:money_manager/core/locator.dart';
import 'package:money_manager/core/services/database_service.dart';
import 'package:money_manager/core/services/group_service.dart';
import 'package:money_manager/core/view_models/base_viewmodel.dart';

class GroupViewModel extends BaseViewModel {
  final GroupService _groupService = locator<GroupService>();
  final DatabaseService _databaseService = locator<DatabaseService>();

  Future<bool> createGroup(String name) async {
    try {
      String groupId = await _groupService.createGroup(name);
      _databaseService.addGroupToUser(groupId);
    } on Exception catch (e) {
      setErrorMessage(e.toString());
      return false;
    }
    return true;
  }

  Future<bool> joinGroup(String groupId) async {
    bool exists = await _groupService.ifGroupExist(groupId);
    if (exists) {
      _databaseService.addGroupToUser(groupId);
      _groupService.addUserToGroup(groupId);
      return true;
    }
    return false;
  }
}
