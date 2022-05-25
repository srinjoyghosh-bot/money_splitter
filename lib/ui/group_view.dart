import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_manager/core/locator.dart';
import 'package:money_manager/core/models/group.dart';
import 'package:money_manager/core/models/group_payment.dart';
import 'package:money_manager/core/models/member.dart';
import 'package:money_manager/core/services/local_storage_service.dart';
import 'package:money_manager/core/view_models/group_viewmodel.dart';
import 'package:money_manager/ui/utils/snackbars.dart';
import 'package:money_manager/ui/widgets/payment_dialog.dart';
import 'package:provider/provider.dart';

class GroupView extends StatefulWidget {
  const GroupView({Key? key, required this.group}) : super(key: key);
  final Group group;
  static const String id = 'group';

  @override
  _GroupViewState createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView>
    with SingleTickerProviderStateMixin {
  final LocalStorageService _service = locator<LocalStorageService>();

  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'History'),
    const Tab(text: 'Owe'),
    const Tab(text: 'Lent'),
  ];
  late GroupViewModel _model;
  late TabController _controller;

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
  void initState() {
    super.initState();

    Provider.of<GroupViewModel>(context, listen: false).reset();
    _controller = TabController(length: 3, vsync: this);
    _controller.addListener(() {
      if (_controller.index != 0) {
        Provider.of<GroupViewModel>(context, listen: false)
            .calculatePaymentSummary();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  } // @override

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
              controller: _controller,
              tabs: myTabs,
            ),
            actions: [
              PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem<int>(
                      child: Text('Copy ID'),
                      value: 0,
                    ),
                  ];
                },
                onSelected: (value) {
                  if (value == 0) {
                    Clipboard.setData(ClipboardData(text: _group.id))
                        .then((value) => showSuccessSnackbar(
                              'Group ID copied to clipboard!',
                              context,
                            ));
                  }
                },
              )
            ],
          ),
          body: TabBarView(
            controller: _controller,
            children: [
              _buildHistoryBody(_model, _group.id),
              _buildOweBody(_model),
              _buildLentBody(_model),
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
        return const Center(child: Text('No payments yet'));
      },
      future: model.getPayments(groupId),
    );
  }

  Widget _buildOweBody(GroupViewModel model) {
    Map<String, double> summary = model.paymentSummary;
    final oweEntries = summary.entries.where((entry) => entry.value > 0);
    print(summary);
    if (oweEntries.isNotEmpty) {
      return ListView(
        children: List<Widget>.from(oweEntries.map((e) => _paymentSummaryItem(
              e.key,
              e.value,
            ))),
      );
    }
    return const Center(child: Text('You don\'t owe anyone'));
  }

  Widget _buildLentBody(GroupViewModel model) {
    Map<String, double> summary = model.paymentSummary;
    final lentEntries = summary.entries.where((entry) => entry.value < 0);
    if (lentEntries.isNotEmpty) {
      return ListView(
        children: List<Widget>.from(lentEntries.map((e) => _paymentSummaryItem(
              e.key,
              -e.value,
            ))),
      );
    }
    return const Center(child: Text('You did not lend anyone'));
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
              'Rs \n ${(payment.totalAmount / (payment.participants.length)).toStringAsFixed(1)}',
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

  Widget _paymentSummaryItem(String username, double amount) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Colors.green,
      ))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(username),
          Chip(
            label: Text('Rs ${amount.toStringAsFixed(1)}'),
            backgroundColor: Colors.green,
          )
        ],
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
                'Total Amount : ${payment.totalAmount.toStringAsFixed(1)}',
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
                  'You owe Rs ${(payment.totalAmount / payment.participants.length).toStringAsFixed(1)}',
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
