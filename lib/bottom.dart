// import 'package:flutter/material.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:quizapp/das.dart';
// import 'quiz_screen.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _pageIndex = 0;
//   final screens = [QuizScreen(), DashboardScreen()];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: screens[_pageIndex],
//       bottomNavigationBar: CurvedNavigationBar(
//         index: 0,
//         height: 60.0,
//         items: <Widget>[
//           Icon(Icons.question_answer, size: 30),
//           Icon(Icons.dashboard, size: 30),
//         ],
//         color: Colors.blue,
//         buttonBackgroundColor: Colors.blue,
//         backgroundColor: Colors.white,
//         animationCurve: Curves.easeInOut,
//         animationDuration: Duration(milliseconds: 300),
//         onTap: (index) {
//           setState(() {
//             _pageIndex = index;
//           });
//         },
//       ),
//     );
//   }
// }
