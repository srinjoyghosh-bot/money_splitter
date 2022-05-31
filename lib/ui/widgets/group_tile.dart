import 'package:flutter/material.dart';
import 'package:money_manager/ui/views/group_view.dart';

import '../../core/models/group.dart';

class GroupTile extends StatefulWidget {
  const GroupTile({
    Key? key,
    required this.group,
  }) : super(key: key);

  final Group group;

  @override
  _GroupTileState createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Colors.green,
      ))),
      child: ListTile(
        title: Hero(
          tag: 'grp-name${widget.group.id}',
          child: Text(
            widget.group.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
          child: CircleAvatar(
            radius: 50,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                getInitials(widget.group.name),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            backgroundColor: Colors.greenAccent,
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, GroupView.id, arguments: widget.group);
        },
      ),
    );
  }

  String getInitials(String name) {
    name = " " + name;
    String initials = "";
    for (int i = 0; i < name.length; i++) {
      if (name[i] == ' ') {
        initials += name[i + 1];
      }
    }
    return initials.toUpperCase();
  }
}
