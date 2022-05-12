import 'package:money_manager/core/locator.dart';
import 'package:money_manager/core/models/group.dart';
import 'package:money_manager/core/services/database_service.dart';
import 'package:money_manager/core/services/group_service.dart';
import 'package:money_manager/core/view_models/base_viewmodel.dart';

class HomeViewModel extends BaseViewModel {
  final GroupService _groupService = locator<GroupService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  List<Group> _userGroups = [];

  Future<List<Group>> get groups async {
    await fetchAllGroups();
    return _userGroups;
  }

  Future<bool> createGroup(String name) async {
    String groupId = "";
    try {
      groupId = await _groupService.createGroup(name);
      _databaseService.addGroupToUser(groupId);
    } on Exception catch (e) {
      setErrorMessage(e.toString());
      return false;
    }
    _userGroups.add(await _groupService.getGroupFromId(groupId));
    notifyListeners();
    return true;
  }

  Future<bool> joinGroup(String groupId) async {
    bool exists = await _groupService.ifGroupExist(groupId);
    if (exists) {
      _databaseService.addGroupToUser(groupId);
      _groupService.addUserToGroup(groupId);
      _userGroups.add(await _groupService.getGroupFromId(groupId));
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> fetchAllGroups() async {
    List<Group> groups = await _groupService.getGroups();
    _userGroups = groups;
  }

  Future<Group> getGroup(String id) async {
    return await _groupService.getGroupFromId(id);
  }
}
