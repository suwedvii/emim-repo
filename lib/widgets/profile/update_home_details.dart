import 'package:emim/data/districts.dart';
import 'package:emim/models/district.dart';
import 'package:emim/widgets/custom_drop_down_button.dart';
import 'package:emim/widgets/my_text_form_field.dart';
import 'package:flutter/material.dart';

class UpdateHomeDetailsModal extends StatefulWidget {
  const UpdateHomeDetailsModal(
      {super.key, required this.detailCategory, required this.user});

  final String detailCategory;
  final Map<String, dynamic> user;

  @override
  State<UpdateHomeDetailsModal> createState() => _UpdateHomeDetailsModalState();
}

class _UpdateHomeDetailsModalState extends State<UpdateHomeDetailsModal> {
  String? enteredPhysicalAddress;
  String selectedDistrict = '';
  String? enteredViillage;
  String? selectedTa;

  @override
  void initState() {
    super.initState();
    enteredPhysicalAddress = widget.user['homeAddress'];
    enteredViillage = widget.user['homeVillage'];
    selectedDistrict = widget.user['contactDistrict'] == 'N/A'
        ? districts[0].name
        : districts[widget.user['contactDistrict']].name;
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.fromLTRB(16, 8, 16, keyboardSpace + 8),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Form(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            'UPDATE ${widget.detailCategory.toUpperCase()}',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          MyTextFormFiled(
              initialValue: enteredPhysicalAddress,
              onValidate: (value) {
                if (value == null || value.isEmpty || value.trim().length < 8) {
                  return 'Enter a valide Phsical Address';
                }
                return null;
              },
              onValueSaved: (value) {
                enteredPhysicalAddress = value;
              },
              label: 'Address'),
          const SizedBox(height: 16),
          MyTextFormFiled(
              initialValue: enteredPhysicalAddress,
              onValidate: (value) {
                if (value == null || value.isEmpty || value.trim().length < 8) {
                  return 'Enter a valid village or area';
                }
                return null;
              },
              onValueSaved: (value) {
                enteredPhysicalAddress = value;
              },
              label: 'Village/Area'),
          const SizedBox(height: 8),
          CustomDropdown(
              items: districts.map((district) => district.name).toList(),
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
              items: getTraditionalAuthorities(selectedDistrict),
              value: getSelectedTa(
                  widget.user, widget.user['homeTA'], selectedDistrict)!,
              onChanged: (String? value) {
                if (value == null) return;
                setState(() {
                  selectedTa = value;
                });
              },
              label: 'T/A'),
        ])),
      ),
    );
  }
}
