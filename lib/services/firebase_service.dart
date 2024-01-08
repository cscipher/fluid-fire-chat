import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  static final realtimeDB = FirebaseDatabase.instance;

  static DatabaseReference getRef(String path, {String? childPath}) {
    var ref = realtimeDB.ref(path);
    if (childPath != null) {
      ref = ref.child(childPath);
    }
    return ref;
  }

  static Future<Object?> getDbSnapshot(String path, {String? childPath}) async {
    final ref = getRef(path, childPath: childPath);
    return ((await ref.get()).value);
  }

  static Future<void> setToPath(String path, {required Map<String, dynamic> data, String? childPath}) async {
    final ref = getRef(path, childPath: childPath);
    await ref.set(data);
  }

  static Future<void> updateToPath(String path, {required Map<String, dynamic> updatedData, String? childPath}) async {
    final ref = getRef(path, childPath: childPath);
    await ref.update(updatedData);
  }

  static Future<void> removeFromDB(String path) async {
    final ref = getRef(path);
    await ref.remove();
  }
}
