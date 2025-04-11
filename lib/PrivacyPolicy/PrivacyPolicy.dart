import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Effective Date: 19/01/2025',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'At Fixa Repair App, we are committed to protecting your privacy. '
                    'This Privacy Policy outlines how we collect, use, and safeguard '
                    'your personal information when you use our mobile application. '
                    'By using our app, you agree to the practices described in this policy.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Information We Collect',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'We collect the following personal information to provide and improve our services:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '1. Name: To identify you and personalize your experience.\n'
                    '2. Phone Number: To contact you regarding your repair requests and provide updates.\n'
                    '3. Address: To provide door-step mobile repair services.\n'
                    '4. Location Permission: To accurately determine your location for service delivery.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'How We Use Your Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'We use your personal information strictly to:\n'
                    '- Facilitate door-step mobile repair services.\n'
                    '- Communicate with you regarding your requests and updates.\n'
                    '- Ensure efficient and timely service delivery.\n\n'
                    'We do not share your personal information with any third parties. '
                    'Your data is used exclusively for the operation of our app and to provide you with high-quality service.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Data Security',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'We take the security of your personal information seriously:\n'
                    '- Your data is encrypted and stored securely.\n'
                    '- Access to your data is limited to authorized personnel only.\n'
                    '- We regularly update our security practices to protect against unauthorized access or disclosure.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Location Permissions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'We require access to your location to accurately provide services at your doorstep. '
                    'Your location data is used only during the service request and is not stored or shared with any third party.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Availability',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Fixa Repair App is currently available only in Patna.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'If you have any questions or concerns about our Privacy Policy, please contact us at:\n'
                    '- Email: fixaservices01@gmail.com\n'
                    '- Phone: +91 9852367405',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'By using the Fixa Repair App, you acknowledge that you have read and understood this Privacy Policy. '
                    'Thank you for trusting us with your mobile repair needs!',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
