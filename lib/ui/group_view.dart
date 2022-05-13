import 'package:flutter/material.dart';
import 'package:money_manager/core/models/group.dart';
import 'package:money_manager/core/view_models/group_viewmodel.dart';
import 'package:money_manager/ui/widgets/payment_dialog.dart';
import 'package:provider/provider.dart';

class GroupView extends StatefulWidget {
  const GroupView({Key? key, required this.group}) : super(key: key);
  final Group group;
  static const String id = 'group';

  @override
  _GroupViewState createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView> {
  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'History'),
    const Tab(text: 'Owe'),
    const Tab(text: 'Lent'),
  ];

  void _showDialog(List<String> pIds, String id) {
    showDialog(
            context: context,
            builder: (_) {
              return PaymentDialog(participantIds: pIds, groupId: id);
            })
        .then((value) => Provider.of<GroupViewModel>(context, listen: false)
            .resetSelectedList());
  }

  @override
  Widget build(BuildContext context) {
    Group _group = widget.group;
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(_group.name),
            centerTitle: true,
            bottom: TabBar(
              tabs: myTabs,
            ),
          ),
          body: TabBarView(
            children: [
              _buildHistoryBody(),
              _buildOweBody(),
              _buildLentBody(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showDialog(_group.participants, _group.id);
            },
            tooltip: 'Add payment',
            child: const Icon(Icons.monetization_on_rounded),
            elevation: 12,
          ),
        ));
  }

  Widget _buildHistoryBody() {
    return const Center(
      child: Text('History'),
    );
  }

  Widget _buildOweBody() {
    return const Center(
      child: Text('Owe'),
    );
  }

  Widget _buildLentBody() {
    return const Center(
      child: Text('Lent'),
    );
  }
}
