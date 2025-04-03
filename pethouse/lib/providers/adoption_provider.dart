import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/adoption.dart';

class AdoptionProvider with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> submitAdoption(Adoption adoption) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firestore.collection('adoptions').doc().set({
        'applications': FieldValue.arrayUnion([adoption.toJson()]),
      }, SetOptions(merge: true));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cancelAdoption(String docId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firestore.collection('adoptions').doc(docId).delete();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
