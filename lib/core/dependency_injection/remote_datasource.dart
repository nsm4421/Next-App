import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';
import 'package:portfolio/features/auth/data/datasource/auth.datasource_impl.dart';

@module
abstract class RemoteDataSource {
  final _dio = Dio();
  final _client = Supabase.instance.client;
  final _logger = Logger();

  AuthDataSource get auth =>
      AuthDataSourceImpl(client: _client, logger: _logger);
}