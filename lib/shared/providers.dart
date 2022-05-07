import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class Providers {
  static final firestore = Provider((ref) {
    return FirebaseFirestore.instance;
  });
}
