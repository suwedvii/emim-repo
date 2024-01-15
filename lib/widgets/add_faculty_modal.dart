import 'dart:convert';

// import 'package:emim/providers/faculties_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class AddFacultyModal extends ConsumerStatefulWidget {
  const AddFacultyModal({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AddFacultyModalState();
  }
}

class _AddFacultyModalState extends ConsumerState<AddFacultyModal> {
  final facultyNameController = TextEditingController();

  void _addFaculty(String? faculty) async {
    Navigator.pop(context);

    if (faculty == '' || faculty == null) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                content: const Text(
                    'Oops! invalid input. Please enter valid Faculty name'),
                title: const Text('Invalid Input'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text('Okay'),
                  ),
                ],
              ));
      return;
    }

    // final Response facultyAdded =
    //     ref.read(facultiesProvider.notifier).addFaculty(faculty);
    // ScaffoldMessenger.of(context).clearSnackBars();
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(facultyAdded.body
    //         // facultyAdded
    //         //   ? 'Faculty $faculty was successfully added.'
    //         //   : 'Faculty $faculty was failed to be added.'
    //         ),
    //   ),
    // );

    final url =
        Uri.https('emimbacke-default-rtdb.firebaseio.com', 'faculties.json');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': faculty,
      }),
    );

    // print(ref.read(facultiesProvider));

    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    double keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Add Faculty',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: facultyNameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              label: Text('Faculty Name'),
            ),
            keyboardType: TextInputType.name,
            maxLines: 1,
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              _addFaculty(facultyNameController.text);
            },
            child: const Text('Add Faculty'),
          ),
        ],
      ),
    );
  }
}
