import 'package:emim/data/districts.dart';
import 'package:emim/data/relationships.dart';
import 'package:emim/models/district.dart';
import 'package:emim/widgets/custom_drop_down_button.dart';
import 'package:emim/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class UpdateNokDetailsModal extends StatefulWidget {
  const UpdateNokDetailsModal(
      {super.key, required this.detailCategory, required this.user});

  final String detailCategory;
  final Map<String, dynamic> user;

  @override
  State<UpdateNokDetailsModal> createState() => _UpdateHomeDetailsModalState();
}

class _UpdateHomeDetailsModalState extends State<UpdateNokDetailsModal> {
  String? enteredNokName;
  String? enteredContactNumber;
  String? enteredAddress;
  String? selectedDistrict;
  String? enteredPhysicalAddress;
  String? selectedRelationship;
  String? selectedSourceOfIncome;
  String? enteredPhoneNumber;
  String? selectedTa;

  @override
  void initState() {
    super.initState();
    enteredNokName = widget.user['nokName'];
    enteredContactNumber = widget.user['nokAddress'];
    enteredAddress = widget.user['nokContactNumber'];
    enteredPhysicalAddress = widget.user['nokPhysicalAddress'];
    selectedDistrict = getSelectedDistrict(widget.user);
    selectedRelationship = getSelectedRelationship(
        widget.user, widget.user['relationshipWithNok']);
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
              initialValue: enteredNokName,
              onValidate: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value.trim().length < 8 ||
                    value.contains(' ')) {
                  return 'Enter a valid name';
                }
                return null;
              },
              onValueSaved: (value) {
                enteredNokName = value;
              },
              label: 'Full Name'),
          const SizedBox(height: 16),
          MyTextFormFiled(
              initialValue: enteredContactNumber,
              inputType: TextInputType.number,
              onValidate: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value.trim().length < 10 ||
                    !value.startsWith('0')) {
                  return 'Enter a valid Phone Number';
                }
                return null;
              },
              onValueSaved: (value) {
                enteredContactNumber = value;
              },
              label: 'Phone Number'),
          const SizedBox(height: 16),
          MyTextFormFiled(
              initialValue: enteredAddress,
              onValidate: (value) {
                if (value == null || value.isEmpty || value.trim().length < 8) {
                  return 'Enter a valid Phsical Address';
                }
                return null;
              },
              onValueSaved: (value) {
                enteredAddress = value;
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
                  : selectedDistrict!,
              onChanged: (String? value) {
                if (value == null) return;
                setState(() {
                  selectedDistrict = value;
                });
              },
              label: 'District'),
          const SizedBox(height: 8),
          CustomDropdown(
              items: getTraditionalAuthorities(selectedDistrict!),
              value: getSelectedTa(
                  widget.user, widget.user['homeTA'], selectedDistrict)!,
              onChanged: (String? value) {
                if (value == null) return;
                setState(() {
                  selectedTa = value;
                });
              },
              label: 'T/A'),
          const SizedBox(height: 8),
          CustomDropdown(
              items: relationshipsList,
              value: getSelectedRelationship(widget.user, selectedRelationship),
              onChanged: (String? value) {
                if (value == null) return;
                setState(() {
                  selectedRelationship = value;
                });
              },
              label: 'Relationship with Next of Kin'),
          const SizedBox(height: 8),
          CustomDropdown(
              items: sourceOfIncome,
              value: getSourceOfIncome(widget.user),
              onChanged: (String? value) {
                if (value == null) return;
                setState(() {
                  selectedSourceOfIncome = value;
                });
              },
              label: 'Next of Kin Source of Income'),
        ])),
      ),
    );
  }
}
