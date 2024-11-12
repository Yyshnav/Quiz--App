import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome text
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Welcome ! Glad to see you again!",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
              ),
            ),
            SizedBox(height: 20),

            // Login ID Field
            TextField(
              controller: loginController,
              decoration: InputDecoration(
                labelText: 'Login ID',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 20),

            // Password Field
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                suffixIcon: Icon(Icons.remove_red_eye),
              ),
            ),
            SizedBox(height: 20),

            // Forget Password link
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Handle "Forgot Password"
                },
                child: Text('Forgot your password?'),
              ),
            ),

            Expanded(child: SizedBox()), // This will take remaining space

            // Login Button at the bottom
            Container(
              width: double.infinity,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextButton(
                onPressed: () {
                  // Perform login and navigate to the next screen
                  Navigator.pushReplacementNamed(context, '/quiz');
                },
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20), // Space before "Register Now"
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      // Navigate to registration screen
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      "Register Now",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
