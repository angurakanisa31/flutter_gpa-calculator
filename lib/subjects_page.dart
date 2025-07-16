import 'package:flutter/material.dart';
import 'models/subject.dart';
import 'services/firestore_service.dart';
import 'summary_page.dart';

class SubjectsPage extends StatefulWidget {
  final String username;
  SubjectsPage({required this.username});

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final creditController = TextEditingController();
  final customSubjectController = TextEditingController();

  String selectedDepartment = 'CSE';
  int selectedYear = 1;
  int selectedSemester = 1;
  String selectedSubject = '';
  String selectedGrade = 'O';
  bool isCustomSubject = false;

  final FirestoreService firestoreService = FirestoreService();

  final List<String> departments = ['CSE', 'IT', 'CSBS', 'AIDS', 'AIML', 'EEE', 'ECE', 'MECH'];
  final List<int> years = [1, 2, 3, 4];
  final List<int> semesters = [1, 2, 3, 4, 5, 6, 7, 8];
  final List<String> grades = ['O', 'A+', 'A', 'B+', 'B', 'C', 'P', 'F'];

  List<Subject> subjects = [];
  late AnimationController _listAnimationController;

  final Map<String, Map<int, Map<int, List<String>>>> subjectMap = {
    'CSE': {
      1: {
        1: ['Linear Algebra', 'Physics', 'C Program', 'Technical English', 'Tamil'],
        2: ['Data Structure', 'OOPS', 'EMP', 'Python', 'Business English']
      },
      2: {
        3: ['Discrete Maths', 'DAA', 'DBMS', 'SE', 'DPCO', 'Java'],
        4: ['FullStack', 'OS', 'CN', 'Business Ethics', 'Cloud', 'Design Thinking']
      },
      3: {5: ['IOT', 'Data Science', 'AIML'], 6: ['Cyber Security', 'Elective I', 'Elective II']},
      4: {7: ['Project I', 'OOAD'], 8: ['Project', 'Big Data']}
    },
    'IT': {
      1: {
        1: ['Linear Algebra', 'Physics', 'C Program', 'Tamil', 'English'],
        2: ['Python', 'OOPS', 'EMP', 'DSA']
      },
      2: {
        3: ['Java', 'DBMS', 'SE', 'DPCO', 'DAA', 'Discrete Maths'],
        4: ['OS', 'CN', 'Full stack', 'Cloud', 'Mission Vision']
      },
      3: {5: ['Web Tech', 'AI', 'IOT', 'Data Science'], 6: ['Cyber Security', 'Elective I']},
      4: {7: ['Blockchain', 'DevOps'], 8: ['Capstone', 'Big Data']}
    },
    'CSBS': {
      1: {
        1: ['Maths I', 'Stats', 'Physics', 'C Program', 'Tamil', 'English'],
        2: ['Data Structure', 'OOPS', 'EMP', 'Python', 'Business English']
      },
      2: {
        3: ['Java', 'DBMS', 'DPCO', 'DAA', 'Discrete Maths'],
        4: ['OS', 'CN', 'Full stack', 'Statics', 'IIPM']
      },
      3: {5: ['ML', 'IoT', 'Data Science', 'AI'], 6: ['Cyber Laws', 'SE']},
      4: {7: ['Data Mining', 'Big Data'], 8: ['Project']}
    }
  };

  @override
  void initState() {
    super.initState();
    _listAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _listAnimationController.dispose();
    creditController.dispose();
    customSubjectController.dispose();
    super.dispose();
  }

  void addSubject() {
    if (_formKey.currentState!.validate()) {
      final subject = Subject(
        name: isCustomSubject ? customSubjectController.text : selectedSubject,
        credit: int.parse(creditController.text),
        grade: selectedGrade,
        semester: selectedSemester,
      );

      setState(() {
        subjects.add(subject);
        _listAnimationController.forward(from: 0);
      });

      firestoreService.addSubject(widget.username, subject);

      creditController.clear();
      customSubjectController.clear();
      selectedGrade = 'O';
      isCustomSubject = false;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Subject added ✅'),
        backgroundColor: Colors.green,
      ));
    }
  }

  void goToSummary() {
    if (subjects.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SummaryPage(
            username: widget.username,
            year: '$selectedYear',
            branch: selectedDepartment,
            subjects: subjects,
          ),
        ),
      );
    }
  }

  Widget buildSubjectTile(Subject sub) {
    return FadeTransition(
      opacity: _listAnimationController,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: Icon(Icons.book, color: Colors.teal),
          title: Text(sub.name, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('Credit: ${sub.credit}  |  Grade: ${sub.grade}'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> availableSubjects =
        subjectMap[selectedDepartment]?[selectedYear]?[selectedSemester] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Subjects'),
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
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  'Hello, ${widget.username} 👋',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal[900]),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField(
                  value: selectedDepartment,
                  items: departments.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                  onChanged: (val) => setState(() => selectedDepartment = val.toString()),
                  decoration: InputDecoration(labelText: 'Department'),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField(
                  value: selectedYear,
                  items: years.map((y) => DropdownMenuItem(value: y, child: Text('$y'))).toList(),
                  onChanged: (val) => setState(() => selectedYear = val as int),
                  decoration: InputDecoration(labelText: 'Year'),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField(
                  value: selectedSemester,
                  items: semesters.map((s) => DropdownMenuItem(value: s, child: Text('Semester $s'))).toList(),
                  onChanged: (val) => setState(() => selectedSemester = val as int),
                  decoration: InputDecoration(labelText: 'Semester'),
                ),
                SizedBox(height: 10),
                Form(
                  key: _formKey,
                  child: Card(
                    color: Colors.white.withOpacity(0.95),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          if (!isCustomSubject)
                            DropdownButtonFormField(
                              value: availableSubjects.contains(selectedSubject)
                                  ? selectedSubject
                                  : (availableSubjects.isNotEmpty ? availableSubjects.first : null),
                              items: availableSubjects
                                  .map((subj) => DropdownMenuItem(value: subj, child: Text(subj)))
                                  .toList(),
                              onChanged: (val) => setState(() => selectedSubject = val.toString()),
                              decoration: InputDecoration(labelText: 'Subject'),
                            ),
                          if (isCustomSubject)
                            TextFormField(
                              controller: customSubjectController,
                              decoration: InputDecoration(labelText: 'Custom Subject Name'),
                              validator: (val) => val!.isEmpty ? 'Enter subject name' : null,
                            ),
                          TextButton(
                            onPressed: () => setState(() => isCustomSubject = !isCustomSubject),
                            child: Text(isCustomSubject ? 'Choose from list' : 'Add custom subject'),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: creditController,
                            decoration: InputDecoration(labelText: 'Credit'),
                            keyboardType: TextInputType.number,
                            validator: (val) => val!.isEmpty ? 'Enter credit' : null,
                          ),
                          SizedBox(height: 10),
                          DropdownButtonFormField(
                            value: selectedGrade,
                            items: grades.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                            onChanged: (val) => setState(() => selectedGrade = val.toString()),
                            decoration: InputDecoration(labelText: 'Grade'),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton.icon(
                            icon: Icon(Icons.add),
                            label: Text('Add Subject'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            onPressed: addSubject,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Column(children: subjects.map((s) => buildSubjectTile(s)).toList()),
                if (subjects.isNotEmpty) ...[
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: Icon(Icons.check_circle),
                    label: Text('View Summary'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    onPressed: goToSummary,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
