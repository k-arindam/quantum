import 'package:mongo_dart/mongo_dart.dart';

import '../models/quantum_user.dart';

class DatabaseController {
  static final _db = Db("mongodb://localhost:27017/quantum");

  final _userCollection = _db.collection("users");

  Future<void> connect() async => await _db.open().then((_) =>
      print("--->>> Database connected :: ${_db.databaseName}@${_db.state}!"));

  Future<bool> addUser(QuantumUser user) async =>
      (await _userCollection.insertOne(user.toJson())).isSuccess;

  Future<QuantumUser> getUser(String email) async {
    final user = await _userCollection.findOne(where.eq('email', email));

    if (user != null) {
      return QuantumUser.fromJson(user);
    }

    throw Exception("User not found !!!");
  }

  // Init
  static final DatabaseController _shared = DatabaseController._();

  factory DatabaseController() => _shared;
  DatabaseController._();

  static DatabaseController get shared => _shared;
}
