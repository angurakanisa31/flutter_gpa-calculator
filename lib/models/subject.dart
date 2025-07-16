class Subject {
  String id; // Firestore document ID
  String name;
  int credit;
  String grade;
  int semester;

  Subject({
    this.id = '',
    required this.name,
    required this.credit,
    required this.grade,
    required this.semester,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'credit': credit,
      'grade': grade,
      'semester': semester,
    };
  }

  factory Subject.fromFirestore(Map<String, dynamic> data, String docId) {
    return Subject(
      id: docId,
      name: data['name'],
      credit: data['credit'],
      grade: data['grade'],
      semester: data['semester'],
    );
  }
}
