import 'package:intl/intl.dart';

final formarter = DateFormat.yMd();

class Payment {
  String? paymentID;
  String? paymentDescription;
  String? payerName;
  String? amount;
  String? paymentDate;
  String? paymentStatus;
  String? imageUri;
  String? updatedAt;
  String? updatedBy;
  String? lastUpdated;
  String? lastUpdatedBy;

  String formatDate(DateTime date) {
    return formarter.format(date);
  }

  Payment(
      {required this.paymentID,
      required this.payerName,
      required this.amount,
      required this.paymentDate,
      required this.paymentDescription,
      this.paymentStatus = 'pending',
      this.updatedAt,
      this.updatedBy,
      this.lastUpdated,
      this.lastUpdatedBy,
      this.imageUri});
}
