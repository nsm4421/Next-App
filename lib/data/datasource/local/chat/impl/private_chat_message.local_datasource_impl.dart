import 'package:logger/logger.dart';

import 'package:portfolio/core/constant/supabase_constant.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../../core/util/exception.util.dart';
import '../../../../model/chat/private_chat_message/local_private_chat_message.model.dart';
import '../../../base/local_datasource.dart';

part '../abstract/private_chat_message.local_datasource.dart';

class PrivateChatMessageLocalDataSourceImpl
    implements PrivateChatMessageLocalDataSource {
  final Database _database;
  final Logger _logger;

  PrivateChatMessageLocalDataSourceImpl(
      {required Database database, required Logger logger})
      : _database = database,
        _logger = logger;

  @override
  String get tableName => TableName.privateChatMessage.name;

  @override
  Future<DateTime> getMaxCreatedAt() async {
    try {
      return await _database
          .rawQuery("SELECT MAX(CREATED_AT) MAX_CREATED_AT FROM $tableName;")
          .then((res) => res.first['MAX_CREATED_AT'] as String?)
          .then((res) => res != null
              ? DateTime.tryParse(res)!.toUtc()
              : DateTime.now().toUtc());
    } catch (e) {
      throw CustomException.from(e, logger: _logger);
    }
  }

  @override
  Future<Iterable<LocalPrivateChatMessageModel>> fetchLatestMessages(
      {int take = 20}) async {
    try {
      final res = await _database.rawQuery(
          "SELECT T.* FROM $tableName T INNER JOIN"
          " (SELECT CHAT_ID, MAX(CREATED_AT) AS MAX_CREATED_AT FROM $tableName GROUP BY CHAT_ID) T2"
          " ON T.CHAT_ID = T2.CHAT_ID AND T.CREATED_AT = T2.MAX_CREATED_AT ORDER BY T.CREATED_AT DESC LIMIT $take;");
      _logger.d(res);
      return res.isNotEmpty
          ? res.map((item) => LocalPrivateChatMessageModel.fromJson(item))
          : [];
    } catch (e) {
      throw CustomException.from(e, logger: _logger);
    }
  }

  @override
  Future<Iterable<LocalPrivateChatMessageModel>> fetch(
      {required String chatId,
      required DateTime beforeAt,
      int take = 20,
      bool ascending = false}) async {
    try {
      return await _database
          .query(tableName,
              where: "chat_id=? and created_at < ?",
              whereArgs: [chatId, beforeAt.toUtc().toIso8601String()],
              orderBy: 'created_at ${ascending ? 'ASC' : 'DESC'}',
              limit: take)
          .then((res) => res.map(LocalPrivateChatMessageModel.fromJson))
          .then((res) {
        _logger.d(res);
        return res;
      });
    } catch (e) {
      throw CustomException.from(e, logger: _logger);
    }
  }

  @override
  Future<void> save(LocalPrivateChatMessageModel model) async {
    try {
      _logger.d(model);
      await _database.insert(tableName, model.toJson());
    } catch (e) {
      throw CustomException.from(e, logger: _logger);
    }
  }

  @override
  Future<void> saveAll(Iterable<LocalPrivateChatMessageModel> messages) async {
    try {
      final batch = _database.batch();
      for (final item in messages) {
        batch.insert(tableName, item.toJson());
      }
      batch.commit(noResult: true);
    } catch (e) {
      throw CustomException.from(e, logger: _logger);
    }
  }

  @override
  Future<void> deleteById(String messageId, {bool soft = true}) async {
    try {
      if (soft) {
        await _database.update(
            tableName, {'content': 'deleted message', 'is_deleted': true},
            where: "id=?", whereArgs: [messageId]);
      } else {
        await _database
            .delete(tableName, where: "id=?", whereArgs: [messageId]);
      }
    } catch (e) {
      throw CustomException.from(e, logger: _logger);
    }
  }
}
