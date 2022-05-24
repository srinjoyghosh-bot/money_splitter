import 'package:flutter/material.dart';
import 'package:money_manager/core/view_models/authentication_viewmodel.dart';
import 'package:money_manager/core/view_models/home_viewmodel.dart';
import 'package:money_manager/ui/auth_view.dart';
import 'package:money_manager/ui/widgets/group_tile.dart';
import 'package:provider/provider.dart';

import '../core/constants/enum/view_state.dart';
import '../core/models/group.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);
  static const String id = 'home';

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeViewModel _model;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _model = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  child: Row(
                    children: const [
                      Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),
                      Text('Log out'),
                    ],
                  ),
                  value: 0,
                )
              ];
            },
            onSelected: (value) async {
              switch (value) {
                case 0:
                  bool logoutStatus =
                      await Provider.of<AuthenticationViewModel>(context,
                              listen: false)
                          .logout();
                  if (logoutStatus) {
                    Navigator.pushReplacementNamed(context, AuthView.id);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Logged out!'),
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.green,
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          Provider.of<AuthenticationViewModel>(context)
                              .errorMessage),
                      duration: const Duration(seconds: 3),
                      backgroundColor: Colors.red,
                    ));
                  }
              }
            },
          )
        ],
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<Group> _userGroups = snapshot.data as List<Group>;
              return _model.state == ViewState.idle
                  ? _userGroups.isNotEmpty
                      ? ListView.builder(
                          itemBuilder: (context, index) => GroupTile(
                                group: _userGroups[index],
                              ),
                          itemCount: _userGroups.length)
                      : const Center(
                          child: Text('No groups yet'),
                        )
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            }
            return const Center(
              child: Text('Some error occured!'),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
        future: _model.groups,
      ),
      // body: FutureBuilder(
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     } else {
      //       if (snapshot.error != null) {
      //         return const Center(
      //           child: Text('Some error occurred!'),
      //         );
      //       }
      //       return Consumer<HomeViewModel>(
      //           builder: (context, model, child) => ListView.builder(
      //                 itemBuilder: (context, index) =>
      //                     GroupTile(group: model.groups[index]),
      //                 itemCount: model.groups.length,
      //               ));
      //     }
      //   },
      //   future: _groupsFuture,
      // ),
      floatingActionButton: _floatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.add,
                      color: Colors.green,
                    ),
                    title: const Text(
                      "Create Group",
                      style: TextStyle(color: Colors.green),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      createGroupDialog();
                    },
                  ),
                  const Divider(thickness: 2),
                  ListTile(
                    leading: const Icon(
                      Icons.add,
                      color: Colors.green,
                    ),
                    title: const Text(
                      "Join Group",
                      style: TextStyle(color: Colors.green),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      joinGroupDialog();
                    },
                  ),
                ],
              );
            },
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))));
      },
      tooltip: "Create or join group",
      backgroundColor: Colors.green,
      elevation: 12,
      child: const Icon(Icons.add),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
      ),
    );
  }

  void createGroupDialog() {
    TextEditingController controller = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration:
                        const InputDecoration(hintText: 'Enter group name'),
                    controller: controller,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                          onPressed: () async {
                            bool isCreated = await _model
                                .createGroup(controller.text.trim());
                            if (isCreated) {
                              showSuccessSnackbar('Group created!');
                            } else {
                              showErrorSnackbar(_model.errorMessage);
                            }
                            Navigator.of(context).pop();
                          },
                          child: const Text('Create')),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void joinGroupDialog() {
    TextEditingController controller = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration:
                        const InputDecoration(hintText: 'Enter group id'),
                    controller: controller,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                          onPressed: () async {
                            bool isJoined =
                                await _model.joinGroup(controller.text);
                            if (isJoined) {
                              showSuccessSnackbar('Group joined!');
                            } else {
                              showErrorSnackbar('No group found');
                            }
                            Navigator.of(context).pop();
                          },
                          child: const Text('Join')),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void showErrorSnackbar(String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red,
    ));
  }

  void showSuccessSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.green,
    ));
  }
}
