import 'dart:convert';

import 'package:emim/models/assignment.dart';
import 'package:emim/screens/assignments/attachment_list.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

final formater = DateFormat.yMMMEd();

class AddAssignmentScreen extends StatefulWidget {
  const AddAssignmentScreen({super.key, required this.selectedAssignment});

  // final List<Assignment> assignments;
  final Assignment? selectedAssignment;

  @override
  State<AddAssignmentScreen> createState() {
    return _AddAssignmentScreenState();
  }
}

class _AddAssignmentScreenState extends State<AddAssignmentScreen> {
  final formkey = GlobalKey<FormState>();

  String? assignmentTitle;
  String? description;
  DateTime? dueDate;
  List<PlatformFile> attachments = [];

  void _addAssignment(BuildContext context) async {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      final myUri = Uri.https(
          'emimbacke-default-rtdb.firebaseio.com', 'assignments.json');

      final currentContext = context; // Capture the context

      try {
        final response = await http.post(
          myUri,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'assignmentTitle': assignmentTitle,
            'description': description,
            'deadline': formater.format(dueDate!).toString(),
            'course': 'Course'
          }),
        );
        print(response.body);

        if (currentContext.mounted) {
          Navigator.of(currentContext).pop<Assignment>(
            Assignment(
              assignmentId: response.body,
              assignmentTitle: assignmentTitle!,
              course: 'Course',
              deadline: formater.format(dueDate!),
              description: description!,
            ),
          );
        }
      } catch (error) {
        print(error);
      }
    }
  }

  void _addAttachment() async {
    final pickedFiles =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (pickedFiles == null) return;
    for (final file in pickedFiles.files) {
      if (attachments.contains(file)) {
        _showSnackBar('File ${file.name} already attached');
        return;
      }
      setState(() {
        attachments = [...attachments, file];
      });
    }

    print(attachments.length);
  }

  void _removeAttachment(int index) {
    if (attachments.isNotEmpty) {
      setState(() {
        _showSnackBar('File ${attachments[index].name} removed');
        attachments.removeAt(index);
      });
    }
  }

  void _openDatePicker() async {
    final firstDate = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: DateTime(firstDate.year + 1),
    );

    if (selectedDate == null) return;

    setState(() {
      dueDate = selectedDate;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  DateTime parsedDate(String date) {
    // Example date string
    String dateString = date;

    // Define the format of the input date string
    DateFormat inputFormat = DateFormat('E, MMM dd, yyyy');

    // Parse the date string into a DateTime object
    DateTime parsedDate = inputFormat.parse(dateString);

    return parsedDate;
  }

  @override
  void dispose() {
    super.dispose();
    formkey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assignment = widget.selectedAssignment;

    if (assignment != null) {
      dueDate = parsedDate(assignment.deadline);
    }

    return Scaffold(
      appBar: AppBar(
        title: assignment == null
            ? const Text('Add Assignment')
            : const Text('Assignment details'),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(8, 3, 8, 0),
        padding: const EdgeInsets.all(8),
        child: Form(
          key: formkey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 4,
                ),
                TextFormField(
                  initialValue: assignment?.assignmentTitle,
                  decoration: const InputDecoration(
                    label: Text('Assignment title'),
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter a valid title with charachers not less than 5';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    assignmentTitle = value;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  initialValue: assignment?.description,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    label: Text('Assignment Description'),
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter a valid description with charachers not less than 5';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    description = value;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: _openDatePicker,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Theme.of(context).colorScheme.onBackground,
                          width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month),
                          const SizedBox(width: 6),
                          const Text('Deadline:'),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(dueDate == null
                              ? 'Select Date'
                              : formater.format(dueDate!).toString()),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'ATTACHMENTS',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: _addAttachment,
                                  icon: Icon(Icons.add_box_outlined,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 250,
                              child: AttachmentList(
                                  attachments: attachments,
                                  onAttachmentDeleted: _removeAttachment),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                assignment == null
                    ? ElevatedButton(
                        onPressed: () {
                          _addAssignment(context);
                        },
                        child: const Text('Add Assignment'),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text('Delete'),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Update'),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
