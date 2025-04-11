import 'dart:async';
import 'dart:convert'; // Import this for JSON encoding and decoding
import 'package:firebase_database/firebase_database.dart';
import 'package:fixa/Mobile/Screen/MHomePage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:http/http.dart' as http; // Import for HTTP requests

import '../Model/UserModel.dart';
import '../Utils/Colors.dart';


class SignInScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('Login toFixa'),
      ),
      body: SignInBottomSheet(onSuccessLogin: (){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Mhomepage()),
        );
      })
    );
  }
}

class SignInBottomSheet extends StatefulWidget {
  final VoidCallback onSuccessLogin; // Function argument

  SignInBottomSheet({required this.onSuccessLogin}); // Constructor

  @override
  _SignInBottomSheetState createState() => _SignInBottomSheetState();
}

class _SignInBottomSheetState extends State<SignInBottomSheet> {
  bool otpSent = false;
  late String _phoneNumber = "";
  late String _otp;
  late String buttontext = 'Get OTP';
  late String _name;
  String _verificationId = "";

  @override
  void initState() {
    super.initState();
  }

  Future<void> sendOtp() async {
    print("\n[SEND OTP] Attempting to send OTP for: $_phoneNumber");

    if (_phoneNumber.isEmpty) {
      print("[SEND OTP] Error: Phone number is empty.");
      return;
    }

    if (_phoneNumber == "+919525581574") {
      print("[SEND OTP] Using Firebase PhoneAuth for $_phoneNumber");
      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: _phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            print("[SEND OTP] Auto Verification Triggered");
            await FirebaseAuth.instance.signInWithCredential(credential);
            print("[SEND OTP] Auto Verification Completed Successfully");
            _pushUserModelToRealtimeDB();
            widget.onSuccessLogin();
          },
          verificationFailed: (FirebaseAuthException e) {
            print("[SEND OTP] Firebase Auth Failed: ${e.message}");
          },
          codeSent: (String verificationId, int? resendToken) {
            setState(() {
              otpSent = true;
              _verificationId = verificationId;
            });
            print("[SEND OTP] OTP sent via Firebase. Verification ID: $verificationId");
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            print("[SEND OTP] Auto retrieval timeout. Verification ID: $verificationId");
          },
        );
      } catch (e) {
        print("[SEND OTP] Exception occurred: $e");
      }
    } else {
      print("[SEND OTP] Sending OTP via API for $_phoneNumber");
      final url = Uri.parse("https://us-central1-instant-text-413611.cloudfunctions.net/Send_Otp");
      try {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({"phoneNumber": _phoneNumber}),
        );

        print("[SEND OTP] API Response: ${response.statusCode}, Body: ${response.body}");

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            otpSent = true;
          });
          print("[SEND OTP] OTP sent successfully via API: ${data['message']}");
        } else {
          print("[SEND OTP] Failed to send OTP: ${response.body}");
        }
      } catch (error) {
        print("[SEND OTP] Error sending OTP: $error");
      }
    }
  }

  Future<void> verifyOtpAndAuthenticate() async {
    print("\n[VERIFY OTP] Verifying OTP for $_phoneNumber");

    if (_phoneNumber.isEmpty || _otp.isEmpty) {
      print("[VERIFY OTP] Error: Phone number or OTP is empty.");
      return;
    }

    if (_phoneNumber == "+919525581574") {
      print("[VERIFY OTP] Using Firebase PhoneAuth for $_phoneNumber");
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!,
          smsCode: _otp,
        );

        print("[VERIFY OTP] Signing in with Firebase credential.");
        await FirebaseAuth.instance.signInWithCredential(credential);
        print("[VERIFY OTP] User authenticated successfully.");

        User? user = FirebaseAuth.instance.currentUser;
        print("[VERIFY OTP] User UID: ${user?.uid}");
        _pushUserModelToRealtimeDB();
        widget.onSuccessLogin();
      } catch (error) {
        print("[VERIFY OTP] Error verifying OTP with Firebase: $error");
      }
    } else {
      print("[VERIFY OTP] Verifying OTP via API for $_phoneNumber");
      final url = Uri.parse("https://us-central1-instant-text-413611.cloudfunctions.net/verifyfixa");
      try {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({"phoneNumber": _phoneNumber, "otp": _otp}),
        );

        print("[VERIFY OTP] API Response: ${response.statusCode}, Body: ${response.body}");

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final firebaseToken = data['firebaseToken'];
          print("[VERIFY OTP] Firebase Token Received: $firebaseToken");

          await FirebaseAuth.instance.signInWithCustomToken(firebaseToken);
          print("[VERIFY OTP] User authenticated successfully via API.");

          User? user = FirebaseAuth.instance.currentUser;
          print("[VERIFY OTP] User UID: ${user?.uid}");
          _pushUserModelToRealtimeDB();
          widget.onSuccessLogin();
        } else {
          print("[VERIFY OTP] Error verifying OTP: ${response.body}");
        }
      } catch (error) {
        print("[VERIFY OTP] Error verifying OTP: $error");
      }
    }
  }
  void _pushUserModelToRealtimeDB() async {
    String phoneNumber = _phoneNumber.substring(3, 13);
    String externalId = phoneNumber;
    OneSignal.login(externalId);
    OneSignal.User.pushSubscription.optIn();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        final DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('Fixa')
            .child('User').child(user.uid);
        UserModel userModel = UserModel(
          name: _name,
          userPhone: phoneNumber,
          uid: user.uid,
          deviceId: kIsWeb ? 'web' : 'app',
          regDate: DateFormat('d/M/yy').format(DateTime.now()),
        );
        Map<String, dynamic> userMap = userModel.toMap();
        await usersRef.update(userMap);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Account created')));
      } catch (e) {
        print('Error adding user data to Realtime Database: $e'); // Log the error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding user data to Realtime Database: $e')));
      }
    } else {
      print('User is not authenticated');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset('assets/images/fixalogo.png', height: 80),
              ),
              SizedBox(height: 4),
              Card(
                margin: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      const SizedBox(height: 2),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextFormField(
                          onChanged: (value) {
                            _name = value;
                          },
                          maxLength: 25,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Enter Your Name',
                            labelStyle: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.bold),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                            prefixIcon: Icon(
                              Icons.person,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextFormField(
                          onChanged: (value) {
                            _phoneNumber = '+91' + value;
                          },
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Enter your Phone Number',
                            labelStyle: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.bold),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                            prefixIcon: Icon(
                              Icons.phone_android,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      if (otpSent) // Only show OTP text field when OTP is sent
                        TextField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: 'Enter OTP',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            _otp = value;
                          },
                          maxLength: 6,
                        ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (buttontext == 'Get OTP') {
                                if (_phoneNumber.length == 13) {
                                  setState(() {
                                    buttontext = 'OTP Sending';
                                  });
                                  try {
                                    await sendOtp();
                                    setState(() {
                                      buttontext = 'Verify OTP';
                                      otpSent = true; // Set OTP sent state
                                    });
                                  } catch (e) {
                                    print('ओटीपी भेजने में त्रुटि: $e');
                                    setState(() {
                                      buttontext = 'Send OTP';
                                    });
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Wrong Phone Number')),
                                  );
                                }
                              } else {
                                  setState(() {
                                    buttontext = 'Verifying OTP';
                                  });
                                  try {
                                    await verifyOtpAndAuthenticate();
                                    setState(() {
                                      buttontext = 'OTP Verified';
                                    });
                                  } catch (e) {
                                    print('ओटीपी सत्यापित करने में त्रुटि: $e');
                                    setState(() {
                                      buttontext = 'Verify OTP';
                                    });
                                  }

                              }
                            },
                            child: buttontext == 'OTP Sending' || buttontext == 'Verifying OTP'
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(buttontext,style: TextStyle(color: Colors.white),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
