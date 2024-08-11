import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:portfolio/data/datasource/local/chat/impl/private_chat_message.local_datasource_impl.dart';

import '../../../core/util/local_db.util.dart';

abstract interface class BaseLocalDataSource<T> {
  String get tableName;
}

@module
abstract class LocalDatasource {
  final LocalDatabaseUtil _util = LocalDatabaseUtil.instance;
  final Logger _logger = Logger(
      level: (dotenv.env['ENV'] == 'PROD') ? Level.error : null,
      printer: PrettyPrinter(
          methodCount: 2,
          errorMethodCount: 8,
          lineLength: 120,
          colors: true,
          printEmojis: true,
          printTime: false));

  PrivateChatMessageLocalDataSource get privateChatMessage =>
      PrivateChatMessageLocalDataSourceImpl(
          database: _util.database, logger: _logger);
}
