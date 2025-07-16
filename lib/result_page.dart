import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final double gpa;

  ResultPage({required this.gpa});

  String getGpaRemark(double gpa) {
    if (gpa >= 9)
      return '🌟 Excellent!';
    else if (gpa >= 8)
      return '🎉 Great job!';
    else if (gpa >= 7)
      return '👍 Good work!';
    else if (gpa >= 6)
      return '📈 Keep improving!';
    else
      return '💡 Needs more effort!';
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout Confirmation'),
        content: Text('Do you want to logout?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(), // Close dialog
          ),
          TextButton(
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.pushNamedAndRemoveUntil(
                  context, '/', (route) => false); // Navigate to root
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String remark = getGpaRemark(gpa);

    return Scaffold(
      appBar: AppBar(
        title: Text('GPA Result'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFFFF9C4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Your GPA is:',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Colors.teal[900],
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 20),
                AnimatedContainer(
                  duration: Duration(seconds: 1),
                  curve: Curves.easeInOutBack,
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        gpa.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[800],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        remark,
                        style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton.icon(
                  icon: Icon(Icons.restart_alt),
                  label: Text('Back to Start'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    textStyle: TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
