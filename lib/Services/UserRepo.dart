import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Model/UserModel.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._internal();
  final _database = FirebaseDatabase.instance;
  final String _userId = FirebaseAuth.instance.currentUser!.uid;
  UserModel? _user;

  UserRepository._internal();

  factory UserRepository() {
    return _instance;
  }

  Future<UserModel> getUserData() async {
    if (_user != null) {
      return _user!;
    } else {
      final snapshot = await _database.ref('Fixa/User/$_userId').get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        _user = UserModel.fromJson(data);
        return _user!;
      } else {
        throw Exception("User data not found");
      }
    }
  }
}
