import 'package:path/path.dart';
import 'package:portfolio/core/constant/error_code.dart';
import 'package:portfolio/core/util/exception.util.dart';
import 'package:sqflite/sqflite.dart';

import '../constant/supabase_constant.dart';

class LocalDatabaseUtil {
  static const _databaseName = "my_database.db";
  static const _databaseVersion = 1;

  static Database? _database;

  Database get database {
    if (_isIntialized) {
      return _database!;
    } else {
      throw CustomException(
          errorCode: ErrorCode.sqlite,
          message: 'local database not initialized');
    }
  }

  bool _isIntialized = false;

  // 싱글톤 패턴
  LocalDatabaseUtil._privateConstructor();

  static final LocalDatabaseUtil instance =
      LocalDatabaseUtil._privateConstructor();

  Future<void> initDatabase() async {
    _database = await openDatabase(
        join(await getDatabasesPath(), _databaseName),
        version: _databaseVersion,
        onCreate: _onCreate);
    _isIntialized = true;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE IF NOT EXISTS ${TableName.privateChatMessage.name} (
        id TEXT PRIMARY KEY,
        chat_id TEXT NOT NULL,
        sender_uid TEXT NOT NULL,
        sender_nickname TEXT NOT NULL,
        sender_profile_image TEXT NOT NULL,
        receiver_uid TEXT NOT NULL,
        receiver_nickname TEXT NOT NULL,
        receiver_profile_image TEXT NOT NULL,
        content TEXT NOT NULL,
        created_at TEXT NOT NULL,
        is_deleted BOOL DEFAULT FALSE
        );''');
  }
}
