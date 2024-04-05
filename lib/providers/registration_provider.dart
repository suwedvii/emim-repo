import 'package:emim/models/registration.dart';
import 'package:emim/providers/academic_year_provider.dart';
import 'package:emim/providers/registrations_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef parameters = ({String uid});

final studentRegistrationProvider = FutureProvider.autoDispose
    .family<Registration?, parameters>((ref, pars) async {
  final academicYearData = ref.watch(academicYearProvider);
  academicYearData.whenData((academicYear) {
    final data = ref.watch(registrationsProvider);
    data.whenData((registrations) {
      final foundRegiistrations = registrations as List<Registration>;
      return foundRegiistrations.firstWhere((registration) =>
          registration.academicYear == academicYear &&
          registration.studentId == pars.uid);
    });
  });
  return null;
});
