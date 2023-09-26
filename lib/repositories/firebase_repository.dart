import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateDataToFirebase(Map<String, dynamic> data) async {
    try {
      await _firestore.collection('mobile_data_store').add(data);
    } catch (e) {
      print('Error updating data to Firebase: $e');
    }
  }



 
}