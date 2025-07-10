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

  double calculateGPA() {
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

    int totalCredits = 0;
    int totalPoints = 0;

    for (var sub in subjects) {
      int gp = gradePoints[sub.grade] ?? 0;
      totalCredits += sub.credit;
      totalPoints += gp * sub.credit;
    }

    return totalCredits == 0 ? 0.0 : totalPoints / totalCredits;
  }

  @override
  Widget build(BuildContext context) {
    double gpa = calculateGPA();

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
            children: [
              Text(
                'Student: $username 👨‍🎓',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[900],
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Year: $year   |   Department: $branch',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.teal[800],
                ),
              ),
              SizedBox(height: 10),
              Divider(color: Colors.teal),
              Expanded(
                child: ListView.builder(
                  itemCount: subjects.length,
                  itemBuilder: (_, index) {
                    final sub = subjects[index];
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.book, color: Colors.teal),
                        title: Text(
                          sub.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Credit: ${sub.credit}   |   Grade: ${sub.grade}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  'GPA: ${gpa.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.teal[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.calculate),
                label: Text('Calculate GPA'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ResultPage(gpa: gpa),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}