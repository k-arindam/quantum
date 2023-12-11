import 'package:mongo_dart/mongo_dart.dart';

class DatabaseController {
  final _db = Db("mongodb://localhost:27017/quantum");

  Future<void> connect() async => await _db.open().then((_) =>
      print("--->>> Database connected :: ${_db.databaseName}@${_db.state}!"));

  // Init
  static final DatabaseController _shared = DatabaseController._();

  factory DatabaseController() => _shared;
  DatabaseController._();

  static DatabaseController get shared => _shared;
}
