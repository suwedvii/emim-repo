import 'package:emim/data/districts.dart';
import 'package:emim/models/district.dart';
import 'package:emim/widgets/custom_drop_down_button.dart';
import 'package:emim/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

enum Titles { mr, ms, mrs, prof, dr, sir }

enum Genders { male, female, other }

class UpdateContactDetailsModal extends StatefulWidget {
  const UpdateContactDetailsModal(
      {super.key, required this.user, required this.detailCategory});

  final Map<String, dynamic> user;
  final String detailCategory;

  @override
  State<UpdateContactDetailsModal> createState() =>
      _UpdateContactDetailsModalState();
}

class _UpdateContactDetailsModalState extends State<UpdateContactDetailsModal> {
  final form = GlobalKey<FormState>();
  List<District> listOfDistricts = [];
  String? selectedTitle = Titles.mr.name;
  String? selectedGender = Genders.male.name;
  String? enteredEmail;
  String? enteredNationality;
  String? enteredDOB;
  String? enteredPhysicalAddress;
  String? enteredPostalAddress;
  String selectedDistrict = '';
  String? selectedTa;

  @override
  void initState() {
    super.initState();
    enteredEmail = widget.user['emailAddress'];
    enteredNationality = widget.user['nationality'];
    enteredDOB = widget.user['dateOfBirth'];
    enteredPhysicalAddress = widget.user['contactPhysicalAddress'];
    enteredPostalAddress = widget.user['contactPostalAddress'];
    selectedDistrict = widget.user['contactDistrict'] == 'N/A'
        ? districts[0].name
        : districts[widget.user['contactDistrict']].name;
  }

  @override
  void dispose() {
    super.dispose();
    form.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    final traditionalAuthorities = districts
        .firstWhere((district) => district.name == selectedDistrict)
        .traditionalAuthorities;

    selectedTa = !traditionalAuthorities.contains(widget.user['contactTA'])
        ? traditionalAuthorities[0]
        : traditionalAuthorities[widget.user['contactTA']];
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.fromLTRB(16, 8, 16, keyboardSpace + 8),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'UPDATE ${widget.detailCategory.toUpperCase()}',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  CustomDropdown(
                      items: Titles.values.map((title) => title.name).toList(),
                      value: selectedTitle.toString(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          selectedTitle = value;
                        });
                      },
                      label: 'Title'),
                  const SizedBox(height: 8),
                  CustomDropdown(
                      items:
                          Genders.values.map((gender) => gender.name).toList(),
                      value: selectedGender.toString(),
                      onChanged: (String? value) {
                        if (value == null) return;
                        setState(() {
                          selectedGender = value;
                        });
                      },
                      label: 'Gender'),
                  const SizedBox(height: 8),
                  MyTextFormFiled(
                      initialValue: enteredEmail,
                      onValidate: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length < 8 ||
                            !value.contains('@')) {
                          return 'Enter a valide Email address';
                        }
                        return null;
                      },
                      onValueSaved: (value) {
                        enteredEmail = value;
                      },
                      label: 'Email'),
                  const SizedBox(height: 8),
                  MyTextFormFiled(
                      initialValue: enteredNationality,
                      onValidate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter a valide Nationality';
                        }
                        return null;
                      },
                      onValueSaved: (value) {
                        enteredNationality = value;
                      },
                      label: 'Nationality'),
                  const SizedBox(height: 8),
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
                            const Text('Date of Birth:'),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(enteredDOB == 'N/A'
                                ? 'Select Date'
                                : enteredDOB!),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  MyTextFormFiled(
                      initialValue: enteredPostalAddress,
                      onValidate: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length < 8) {
                          return 'Enter a valide Postal Address';
                        }
                        return null;
                      },
                      onValueSaved: (value) {
                        enteredPostalAddress = value;
                      },
                      label: 'Address'),
                  const SizedBox(height: 8),
                  MyTextFormFiled(
                      initialValue: enteredPhysicalAddress,
                      onValidate: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length < 8) {
                          return 'Enter a valide Phsical Address';
                        }
                        return null;
                      },
                      onValueSaved: (value) {
                        enteredPhysicalAddress = value;
                      },
                      label: 'Village/Area'),
                  const SizedBox(height: 8),
                  CustomDropdown(
                      items:
                          districts.map((district) => district.name).toList(),
                      value: selectedDistrict == 'N/A'
                          ? 'Select District'
                          : selectedDistrict,
                      onChanged: (String? value) {
                        if (value == null) return;
                        setState(() {
                          selectedDistrict = value;
                        });
                      },
                      label: 'District'),
                  const SizedBox(height: 8),
                  CustomDropdown(
                      items: traditionalAuthorities,
                      value: selectedTa!,
                      onChanged: (String? value) {
                        if (value == null) return;
                        setState(() {
                          selectedTa = value;
                        });
                      },
                      label: 'T/A'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openDatePicker() async {
    final firstDate = DateTime.parse(
      DateTime(DateTime.now().year - 80).toString(),
    );
    final result = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: DateTime.now(),
    );

    if (result == null) return;

    setState(() {
      enteredDOB = result.toString();
    });
  }
}
