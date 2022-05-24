import 'package:flutter/material.dart';
import 'package:money_manager/core/locator.dart';
import 'package:money_manager/core/models/group.dart';
import 'package:money_manager/core/models/group_payment.dart';
import 'package:money_manager/core/models/member.dart';
import 'package:money_manager/core/services/local_storage_service.dart';
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
  final LocalStorageService _service = locator<LocalStorageService>();

  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'History'),
    const Tab(text: 'Owe'),
    const Tab(text: 'Lent'),
  ];
  late GroupViewModel _model;

  void _showDialog(List<Member> members, String id) {
    showDialog(
            context: context,
            builder: (_) {
              return PaymentDialog(participantIds: members, groupId: id);
            })
        .then((value) => Provider.of<GroupViewModel>(context, listen: false)
            .resetSelectedList());
  }

  @override
  Widget build(BuildContext context) {
    Group _group = widget.group;
    _model = Provider.of<GroupViewModel>(context);
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
              _buildHistoryBody(_model, _group.id),
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

  Widget _buildHistoryBody(GroupViewModel model, String groupId) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List<GroupPayment> payments = snapshot.data as List<GroupPayment>;
            if (payments.isNotEmpty) {
              return ListView.builder(
                itemBuilder: (context, index) =>
                    _paymentListItem(payments[index]),
                itemCount: payments.length,
              );
            }
            return const Center(child: Text('No payments yet'));
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return const Center(
          child: Text('No payments yet'),
        );
      },
      future: model.getPayments(groupId),
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

  Widget _paymentListItem(GroupPayment payment) {
    bool isInvolved = payment.participants
        .any((element) => element.id == _service.currentUserId);
    String payer = payment.creator.id == _service.currentUserId
        ? 'You'
        : payment.creator.username;
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        border: const Border(
          bottom: BorderSide(
            color: Colors.green,
          ),
        ),
        color: isInvolved ? Colors.white : Colors.grey,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 60,
          backgroundColor: Colors.green,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              'Rs \n ${payment.totalAmount / (payment.participants.length)}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
        title: Text(payment.title),
        subtitle: Text('Paid by $payer'),
        onTap: () {
          _showDetailsDialog(payment, isInvolved, payer);
        },
      ),
    );
  }

  void _showDetailsDialog(GroupPayment payment, bool isInvolved, String payer) {
    showDialog(
        context: context,
        builder: (_) => detailsDialog(payment, isInvolved, payer));
  }

  Widget detailsDialog(GroupPayment payment, bool isInvolved, String payer) {
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(12),
      )),
      child: SizedBox(
        height: 500,
        child: Center(
          child: Column(
            children: [
              const Spacer(),
              Text(
                payment.title,
                softWrap: true,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Total Amount : ${payment.totalAmount}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              if (!isInvolved)
                const Text(
                  'NOT INVOLVED',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.red,
                  ),
                )
              else
                Text(
                  'You owe Rs ${payment.totalAmount / payment.participants.length}',
                  style: const TextStyle(
                    fontSize: 25,
                    color: Colors.red,
                  ),
                ),
              const SizedBox(height: 10),
              Text(
                'Pay to $payer',
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Participants :',
                style: TextStyle(fontSize: 25),
              ),
              Expanded(
                  child: ListView.builder(
                itemBuilder: (context, index) => Text(
                  payment.participants[index].username,
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                itemCount: payment.participants.length,
              )),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
