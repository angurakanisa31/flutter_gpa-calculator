import 'package:flutter/material.dart';
import 'result_page.dart';
import 'subjects_page.dart';

class SummaryPage extends StatelessWidget {
  final String username;
  final String year;
  final String branch;
  final List<Subject> subjects;

  SummaryPage({
    required this.username,
    required this.year,
    required this.branch,
    required this.subjects,
  });

  Map<int, double> calculateSGPAs() {
    Map<String, int> gradePoints = {
      'O': 10,
      'A+': 9,
      'A': 8,
      'B+': 7,
      'B': 6,
      'C': 5,
      'P': 4,
      'F': 0,
    };

    Map<int, int> creditPerSemester = {};
    Map<int, int> totalPointsPerSemester = {};

    for (var sub in subjects) {
      int gp = gradePoints[sub.grade] ?? 0;
      creditPerSemester[sub.semester] = (creditPerSemester[sub.semester] ?? 0) + sub.credit;
      totalPointsPerSemester[sub.semester] =
          (totalPointsPerSemester[sub.semester] ?? 0) + (gp * sub.credit);
    }

    Map<int, double> sgpas = {};
    for (var sem in creditPerSemester.keys) {
      int totalCredits = creditPerSemester[sem]!;
      int totalPoints = totalPointsPerSemester[sem]!;
      sgpas[sem] = totalCredits == 0 ? 0.0 : totalPoints / totalCredits;
    }

    return sgpas;
  }

  double calculateCGPA(Map<int, double> sgpas, Map<int, int> creditPerSemester) {
    double totalWeightedGPA = 0;
    int totalCredits = 0;

    for (var sem in sgpas.keys) {
      totalWeightedGPA += sgpas[sem]! * creditPerSemester[sem]!;
      totalCredits += creditPerSemester[sem]!;
    }

    return totalCredits == 0 ? 0.0 : totalWeightedGPA / totalCredits;
  }

  @override
  Widget build(BuildContext context) {
    Map<int, double> sgpas = calculateSGPAs();

    // For CGPA calculation
    Map<int, int> creditPerSemester = {};
    for (var sub in subjects) {
      creditPerSemester[sub.semester] =
          (creditPerSemester[sub.semester] ?? 0) + sub.credit;
    }

    double cgpa = calculateCGPA(sgpas, creditPerSemester);

    // Group subjects by semester
    Map<int, List<Subject>> semesterWiseSubjects = {};
    for (var sub in subjects) {
      semesterWiseSubjects.putIfAbsent(sub.semester, () => []).add(sub);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Summary'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFFFF9C4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Student: $username 👨‍🎓',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal[900]),
              ),
              SizedBox(height: 6),
              Text(
                'Year: $year   |   Department: $branch',
                style: TextStyle(fontSize: 16, color: Colors.teal[800]),
              ),
              SizedBox(height: 10),
              Divider(color: Colors.teal),

              // Semester wise subjects and SGPA
              Expanded(
                child: ListView(
                  children: semesterWiseSubjects.keys.map((sem) {
                    final semSubjects = semesterWiseSubjects[sem]!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Semester $sem',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal[800]),
                        ),
                        ...semSubjects.map((sub) => Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: Icon(Icons.book, color: Colors.teal),
                            title: Text(sub.name, style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('Credit: ${sub.credit}   |   Grade: ${sub.grade}'),
                          ),
                        )),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            'SGPA (Sem $sem): ${sgpas[sem]!.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.teal[700]),
                          ),
                        ),
                        Divider(thickness: 1),
                      ],
                    );
                  }).toList(),
                ),
              ),

              // CGPA display
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  'CGPA: ${cgpa.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 22, color: Colors.teal[800], fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.calculate),
                  label: Text('View Result'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResultPage(gpa: cgpa),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
