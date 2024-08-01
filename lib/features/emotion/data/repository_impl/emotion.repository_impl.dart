import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:portfolio/features/emotion/data/datasource/emotion.datasource_impl.dart';
import 'package:portfolio/features/emotion/data/model/emotion.model.dart';
import 'package:portfolio/features/emotion/domain/entity/emotion.entity.dart';
import 'package:portfolio/features/main/core/constant/response_wrapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'package:portfolio/features/emotion/domain/repository/emotion.repository.dart';

@LazySingleton(as: EmotionRepository)
class EmotionRepositoryImpl implements EmotionRepository {
  final EmotionDataSource _dataSource;
  final Logger _logger = Logger();

  EmotionRepositoryImpl(this._dataSource);

  @override
  Future<ResponseWrapper<void>> deleteEmotionById(String id) async {
    try {
      return await _dataSource
          .deleteEmotionById(id)
          .then((_) => ResponseWrapper.success(null));
    } on PostgrestException catch (error) {
      _logger.e(error);
      return ResponseWrapper.error(error.message);
    } catch (error) {
      _logger.e(error);
      return ResponseWrapper.error(error.toString());
    }
  }

  @override
  Future<ResponseWrapper<void>> upsertEmotion(EmotionEntity entity) async {
    try {
      return await _dataSource
          .upsertEmotion(EmotionModel.fromEntity(entity))
          .then((_) => ResponseWrapper.success(null));
    } on PostgrestException catch (error) {
      _logger.e(error);
      return ResponseWrapper.error(error.message);
    } catch (error) {
      _logger.e(error);
      return ResponseWrapper.error(error.toString());
    }
  }

  @override
  RealtimeChannel getEmotionChannel(
      {void Function(EmotionEntity newModel)? onInsert,
      void Function(EmotionEntity oldModel, EmotionEntity newModel)? onUpdate,
      void Function(EmotionEntity oldModel)? onDelete}) {
    return _dataSource.getEmotionChannel(
      onInsert: onInsert == null
          ? null
          : (EmotionModel model) {
              onInsert(EmotionEntity.fromModel(model));
            },
      onUpdate: onUpdate == null
          ? null
          : (EmotionModel oldModel, EmotionModel newModel) {
              onUpdate(EmotionEntity.fromModel(oldModel),
                  EmotionEntity.fromModel(newModel));
            },
      onDelete: onDelete == null
          ? null
          : (EmotionModel model) {
              onDelete(EmotionEntity.fromModel(model));
            },
    );
  }
}
