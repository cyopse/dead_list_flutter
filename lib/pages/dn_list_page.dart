import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/models/deadpeople.dart';
import 'package:lista_de_tarefas/repositories/dead_repository.dart';
import 'package:lista_de_tarefas/widgets/dead_people_list_item.dart';

class DeathNoteListPage extends StatefulWidget {
  const DeathNoteListPage({Key? key}) : super(key: key);

  @override
  State<DeathNoteListPage> createState() => _DeathNoteListPageState();
}

class _DeathNoteListPageState extends State<DeathNoteListPage> {
  final TextEditingController deadPeopleController = TextEditingController();
  final DeadRepository deadRepository = DeadRepository();

  List<DeadPeople> deadPeople = [];
  DeadPeople? deletedDead;
  int? deletedDeadPos;

  String? errorText;

  @override
  void initState() {
    super.initState();
    deadRepository.getDeadList().then((value) {
      setState(() {
        deadPeople = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/shinigami.jfif'),
            fit: BoxFit.fill,
          )),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: deadPeopleController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 2,
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 2,
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            labelText: 'Add a Name',
                            hintText: 'Ex. vladimir putin',
                            labelStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            errorText: errorText,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          String text = deadPeopleController.text;
                          if (text.isEmpty) {
                            setState(() {
                              errorText = 'the name cannot be empty';
                            });
                            return;
                          }
                          setState(() {
                            DeadPeople newDeadPeople = DeadPeople(
                              title: text,
                              dateTime: DateTime.now(),
                            );
                            deadPeople.add(newDeadPeople);
                            errorText = null;
                          });
                          deadPeopleController.clear();
                          deadRepository.saveDeadList(deadPeople);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          padding: const EdgeInsets.all(16),
                          side: const BorderSide(
                            width: 2,
                            color: Colors.black,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for (DeadPeople dead in deadPeople)
                          DeadPeopleListItem(
                            dead: dead,
                            onDelete: onDelete,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${deadPeople.length} people died',
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showDeleteAllDeadConfirmationDialog();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                              padding: const EdgeInsets.all(16),
                              side: const BorderSide(
                                width: 2,
                                color: Colors.black,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Row(
                              children: const [
                                Text(
                                  'Clean',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Icon(
                                  Icons.delete,
                                  size: 26,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(DeadPeople dead) {
    deletedDead = dead;
    deletedDeadPos = deadPeople.indexOf(dead);
    setState(() {
      deadPeople.remove(dead);
    });
    deadRepository.saveDeadList(deadPeople);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${dead.title} has been deleted!'),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.red,
          onPressed: () {
            setState(() {
              deadPeople.insert(deletedDeadPos!, deletedDead!);
            });
            deadRepository.saveDeadList(deadPeople);
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void showDeleteAllDeadConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clean all?'),
        content: const Text('Are you sure you want to clean everything?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              primary: Colors.black,
            ),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteAllPeople();
            },
            style: TextButton.styleFrom(
              primary: Colors.red,
            ),
            child: const Text('Clean everything'),
          )
        ],
      ),
    );
  }

  void deleteAllPeople() {
    setState(() {
      deadPeople.clear();
    });
    deadRepository.saveDeadList(deadPeople);
  }
}
