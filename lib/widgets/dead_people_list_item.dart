import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:lista_de_tarefas/models/deadpeople.dart';

class DeadPeopleListItem extends StatelessWidget {
  const DeadPeopleListItem({
    Key? key,
    required this.dead,
    required this.onDelete,
  }) : super(key: key);

  final DeadPeople dead;
  final Function(DeadPeople) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.38,
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              onPressed: ((context) {
                onDelete(dead);
              }),
              icon: Icons.delete,
              label: 'Delete',
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            SlidableAction(
              onPressed: ((context) {}),
              icon: Icons.edit,
              label: 'Edit',
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            )
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.grey[300],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                DateFormat('dd/MM/yyyy - HH:mm').format(dead.dateTime),
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
              Text(
                dead.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
