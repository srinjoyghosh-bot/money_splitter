import 'package:flutter/material.dart';
import 'package:money_manager/core/models/member.dart';
import 'package:money_manager/core/view_models/group_viewmodel.dart';
import 'package:money_manager/ui/widgets/participant_list_item.dart';
import 'package:provider/provider.dart';

class PaymentDialog extends StatefulWidget {
  const PaymentDialog(
      {Key? key, required this.participantIds, required this.groupId})
      : super(key: key);
  final List<Member> participantIds;
  final String groupId;

  @override
  _PaymentDialogState createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  final _paymentFormKey = GlobalKey<FormState>();
  String title = '';
  double amount = 0;

  // List<String> selectedParticipants = [];

  void _onSave() async {
    final isValid = _paymentFormKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _paymentFormKey.currentState?.save();
    await Provider.of<GroupViewModel>(context, listen: false)
        .addPayment(title, amount, widget.groupId);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.black87, width: 2),
      ),
      backgroundColor: Colors.white,
      elevation: 5,
      child: Stack(children: [
        Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Form(
                key: _paymentFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter a title';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        title = value!;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter an amount';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        amount = double.parse(value!.trim());
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: ListView.builder(
                itemBuilder: (context, index) =>
                    ParticipantListItem(member: widget.participantIds[index]),
                itemCount: widget.participantIds.length,
              )),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: _onSave, child: const Text('Add Payment')),
              ),
            ],
          ),
        ),
        const Positioned(
          child: CloseButton(),
          top: 0,
          right: 0,
        )
      ]),
    );
  }

// Widget _participantListItem(String id) {
//   return Padding(
//     padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
//     child: CheckboxListTile(
//       value: false,
//       onChanged: (value) {
//         if (value == null) {
//           return;
//         }
//         if (value) {
//           selectedParticipants.add(id);
//         } else {
//           selectedParticipants.remove(id);
//         }
//       },
//       shape: const RoundedRectangleBorder(
//           side: BorderSide(color: Colors.green, width: 2)),
//       title: Text(id),
//     ),
//   );
// }
}
