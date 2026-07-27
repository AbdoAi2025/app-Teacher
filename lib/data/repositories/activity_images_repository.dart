import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:teacher_app/domain/models/activity_image_model.dart';
import 'package:teacher_app/services/api_service.dart';
import 'package:teacher_app/services/endpoints.dart';

class ActivityImagesRepository {
  Future<List<ActivityImageModel>> getImages(String activityId) async {
    final response = await ApiService.getInstance()
        .get(EndPoints.activityImages(activityId));
    final data = response.data?['data'] as List? ?? [];
    return data
        .map((e) => ActivityImageModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ActivityImageModel>> addImages(
      String activityId, List<File> files) async {
    final formData = FormData.fromMap({
      'files': await Future.wait(
        files.map((f) async => MultipartFile.fromFile(
              f.path,
              filename: f.path.split('/').last,
              contentType: MediaType('image', _ext(f.path)),
            )),
      ),
    });
    final response = await ApiService.getInstance().post(
      EndPoints.activityImages(activityId),
      data: formData,
    );
    final data = response.data?['data'] as List? ?? [];
    return data
        .map((e) => ActivityImageModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteImage(int imageId) async {
    await ApiService.getInstance()
        .delete(EndPoints.deleteActivityImage(imageId));
  }

  String _ext(String path) {
    final ext = path.split('.').last.toLowerCase();
    return switch (ext) {
      'png' => 'png',
      'gif' => 'gif',
      'webp' => 'webp',
      _ => 'jpeg',
    };
  }
}