import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixa/Mobile/Screen/MHomePage.dart';
import 'package:flutter/material.dart';

class TesterLoginPage extends StatefulWidget {
  @override
  _TesterLoginPageState createState() => _TesterLoginPageState();
}

class _TesterLoginPageState extends State<TesterLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    checkLoggedInUser();
  }

  void checkLoggedInUser() {
    User? user = _auth.currentUser;
    if (user != null) {
      // User is already logged in, navigate to the home page
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Mhomepage()),
        );
      });
    }
  }

  Future<void> login() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Successful!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Mhomepage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'An unknown error occurred.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void skipLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Mhomepage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Login Page',style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login to Fixa',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            if (isLoading)
              CircularProgressIndicator()
            else
              Column(
                children: [
                  ElevatedButton(
                    onPressed: login,
                    child: Text('Login'),
                  ),
                  TextButton(
                    onPressed: skipLogin,
                    child: Text('Skip'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
