import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/subject.dart';
import '../subjects_page.dart'; // Subject model

class FirestoreService {
  final CollectionReference subjectCollection =
  FirebaseFirestore.instance.collection('subjects');

  Future<void> addSubject(String username, Subject subject) async {
    await subjectCollection.add({
      'username': username,
      'name': subject.name,
      'credit': subject.credit,
      'grade': subject.grade,
      'semester': subject.semester,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Subject>> getSubjects(String username) {
    return subjectCollection
        .where('username', isEqualTo: username)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Subject(
        name: data['name'],
        credit: data['credit'],
        grade: data['grade'],
        semester: data['semester'],
      );
    }).toList());
  }

  Future<void> deleteSubject(String id) async {
    await subjectCollection.doc(id).delete();
  }

  Future<void> updateSubject(String id, Subject subject) async {
    await subjectCollection.doc(id).update({
      'name': subject.name,
      'credit': subject.credit,
      'grade': subject.grade,
      'semester': subject.semester,
    });
  }
}
