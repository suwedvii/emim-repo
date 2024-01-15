import 'package:emim/models/payment.dart';
import 'package:emim/screens/payments/add_payment_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;

class Payments extends StatefulWidget {
  const Payments({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Payments> createState() {
    return _PaymentsState();
  }
}

class _PaymentsState extends State<Payments> {
  bool isLoading = true;

  List<Payment> payments = [];

  void _addPayment(Payment paymnet) {
    setState(() {
      payments.add(paymnet);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPayments();
  }

  void _openAddPaymentButtomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      useSafeArea: true,
      context: context,
      builder: (ctx) => AddPaymentBottomSheet(
          onAddPayment: _addPayment, loadPayments: _loadPayments),
    );
  }

  void _loadPayments() async {
    final url =
        Uri.https('emimbacke-default-rtdb.firebaseio.com', 'payments.json');

    try {
      final response = await http.get(url);
      print(response.body);
      print(response.statusCode);

      print(payments[0].amount);
    } catch (error) {
      print('Error found: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('Oops, nothing found!'),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.list_view,
        overlayOpacity: 0,
        // label: const Text('Options'),
        spacing: 5,
        children: [
          SpeedDialChild(
              label: 'Add Payment',
              child: const Icon(Icons.payments_rounded),
              onTap: () {
                _openAddPaymentButtomSheet();
              })
        ],
      ),
      body: content,
      // Add your payment-related UI components here
    );
  }
}
