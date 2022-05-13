import 'package:flutter/material.dart';
import 'package:money_manager/core/view_models/group_viewmodel.dart';
import 'package:provider/provider.dart';

class ParticipantListItem extends StatefulWidget {
  const ParticipantListItem({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  _ParticipantListItemState createState() => _ParticipantListItemState();
}

class _ParticipantListItemState extends State<ParticipantListItem> {
  bool isSelected = false;
  late GroupViewModel _groupViewModel;

  @override
  Widget build(BuildContext context) {
    _groupViewModel = Provider.of<GroupViewModel>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: CheckboxListTile(
        value: isSelected,
        onChanged: (value) {
          if (value == null) {
            return;
          }
          if (value) {
            // selectedParticipants.add(id);
            _groupViewModel.selectParticipant(widget.id);
          } else {
            // selectedParticipants.remove(id);
            _groupViewModel.unselectParticipant(widget.id);
          }
          setState(() {
            isSelected = value;
          });
        },
        shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.green, width: 2)),
        title: Text(widget.id),
      ),
    );
  }
}
