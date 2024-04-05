import 'dart:async';

import 'package:emim/models/registration.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final registrationRef = FirebaseDatabase.instance.ref().child('registrations');

class RegistrationsNotifier
    extends AutoDisposeAsyncNotifier<List<Registration>> {
  @override
  FutureOr<List<Registration>> build() async {
    await for (final event in registrationRef.onValue) {
      final List<Registration> foundRegistrations = [];
      for (final registrationSnapshot in event.snapshot.children) {
        final retrievedregistration =
            Registration().fromSnapshot(registrationSnapshot);
        foundRegistrations.add(retrievedregistration);
      }
      return foundRegistrations;
    }
    return [];
  }
}

final registrationsProvider =
    AsyncNotifierProvider.autoDispose(RegistrationsNotifier.new);
