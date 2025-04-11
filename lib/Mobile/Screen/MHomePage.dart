import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixa/Mobile/Screen/MBrandList.dart';
import 'package:fixa/Mobile/Widget/IssueWidget.dart';
import 'package:fixa/Mobile/Widget/ScrollingReviewWidget.dart';
import 'package:fixa/PrivacyPolicy/PrivacyPolicy.dart';
import 'package:fixa/Utils/Colors.dart';
import 'package:fixa/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Services/LoginWithGoogle.dart';
import '../../Utils/CustomPageRoute.dart';
import '../../Utils/PageNavigator.dart';
import '../../Utils/Toast.dart';
import '../Widget/BookWidget.dart';
import '../Widget/FooterWidget.dart';
import '../Widget/HowRepairWidget.dart';
import '../Widget/PosterSlider.dart';
import '../Widget/PotraitPoster.dart';

import 'package:device_info_plus/device_info_plus.dart';

import 'MBookingList.dart';
import 'MProfile.dart';
class Mhomepage extends StatefulWidget {
  final int initialIndex; // Add this parameter

  const Mhomepage({super.key, this.initialIndex = 0}); // Default to 0

  @override
  State<Mhomepage> createState() => _MhomepageState();
}


class _MhomepageState extends State<Mhomepage> {
  int _currentIndex = 0;
  int _backPressCount = 0;
  late User? user;
  String deviceBrand = ''; // To hold the detected device brand
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _fetchDeviceBrand();
    user = FirebaseAuth.instance.currentUser;
  }


  Future<void> _fetchDeviceBrand() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String brand = '';

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      brand = androidInfo.brand ?? ''; // Get brand for Android devices
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      brand = iosInfo.utsname.machine ?? ''; // Get model for iOS devices
    }

    setState(() {
      deviceBrand = brand;
    });
  }

  Future<bool> _onWillPop() async {
    _backPressCount++;

    if (_backPressCount == 1) {
      Fluttertoast.showToast(
        msg: "Press back again to exit",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false; // Prevent the default back action
    } else {
      return true; // Allow the back action to exit the app
    }
  }


  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut(); // Sign out from Firebase
      Fluttertoast.showToast(
        msg: "Logged out successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.pushReplacement(context,    MaterialPageRoute(builder: (context) => SignInScreen()), ); // Redirect to login page
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Logout failed. Try again!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      SingleChildScrollView(
        child: Column(
          children: [
          PosterSliderWidget(),
            Padding(
              padding: const EdgeInsets.all(1),
              child: buildCustomCard(
                headerText: 'Are you Ready to Fix your Device?',
                subtitleText: deviceBrand.isEmpty ? 'Device Brand' : deviceBrand, // Use dynamic brand name here
                buttonText: 'Repair Now',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MBrandListScreen(),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 1, bottom: 0),
              child: Text(
                'Common Issue In Your Phone',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 90, right: 90, bottom: 0),
              child: Divider(thickness: 1.5),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 6, bottom: 10),
              child: IssueWidget(),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 4, bottom: 2),
              child: Text(
                'Fixa Offers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 90, right: 90, bottom: 0),
              child: Divider(thickness: 1.5),
            ),
            Container(height: 340, child: PotraitPoster()),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 4, bottom: 2),
              child: Text(
                'How Fixa Work',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 90, right: 90, bottom: 0),
              child: Divider(thickness: 1.5),
            ),
            howWeRepairYourPhoneWidget(),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 4, bottom: 2),
              child: Text(
                'Review by Customer',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ReviewWidget(),
            ),
            SizedBox(height: 10),
            FooterWidget(),
          ],
        ),
      ),
      MBookingScreen(),
      Mprofile()
    ];

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        drawer: SafeArea(
          child: Drawer(
            backgroundColor: Colors.white,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  child:Image.asset('assets/images/fixalogo.png',color: Colors.white,)
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () {
                    setState(() {
                      _currentIndex = 0;
                    });
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                ListTile(
                  leading: Icon(Icons.bookmark),
                  title: Text('Booking'),
                  onTap: () {
          
                    setState(() {
          
                      _currentIndex = 1;
                    });
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                  onTap: () {
                    setState(() {
                      _currentIndex = 2;
                    });
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                ListTile(
                  leading: Icon(Icons.privacy_tip),
                  title: Text('Privacy Policy'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrivacyPolicyPage(),
                      ),
                    );
                  },
                ),

                Divider(),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () async {
                    await _logout();
                  },
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title:Padding(
            padding: const EdgeInsets.only(top:10),
            child: Image.asset('assets/images/fixalogo.png',height:40,width: 120,color: Colors.white,),
          ),
          backgroundColor: Colors.black,


        ),
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.background,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: 'Booking',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _currentIndex,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.black,
          onTap: (index) {
      changeTab(index);
      },
        ),
      ),
    );
  }

  }
