import 'dart:math';
import 'package:emim/models/payment.dart';
import 'package:emim/screens/payments/image_input.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formater = DateFormat().add_yMd();

class AddPaymentBottomSheet extends StatefulWidget {
  const AddPaymentBottomSheet(
      {super.key, required this.onAddPayment, required this.loadPayments});

  final Function(Payment payment) onAddPayment;
  final Function() loadPayments;
  @override
  State<AddPaymentBottomSheet> createState() {
    return _AddPaymentBottomSheetState();
  }
}

class _AddPaymentBottomSheetState extends State<AddPaymentBottomSheet> {
  final formKey = GlobalKey<FormState>();

  double enteredAmount = 0.0;

  void _addPayment() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        widget.onAddPayment(
          Payment(
              paymentID: 'payment${Random().nextInt(1000)}',
              payerName: 'Hamza',
              amount: enteredAmount.toString(),
              paymentDate: DateTime.now().toString(),
              paymentDescription: 'Fees payment'),
        );

        widget.loadPayments();
      });
    }
  }

  String formatDate(DateTime date) {
    return formarter.format(date);
  }

  @override
  void dispose() {
    super.dispose();
    formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 16 + keyboardSpace),
      padding: const EdgeInsets.all(8),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                    label: Text('Amount'), prefixText: 'MWK '),
                keyboardType: TextInputType.number,
                initialValue: '0.00',
                onSaved: (amount) {
                  enteredAmount = double.parse(amount!);
                },
                validator: (amount) {
                  if (amount == null || amount == '0.00') {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 8,
              ),
              const ImageInput(),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('Reset'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      _addPayment();
                    },
                    child: const Text('Add Payment'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
