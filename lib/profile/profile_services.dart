import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

void getData() async {
  final dio = Dio();

  final response = await dio.get(
    'https://jsonplaceholder.typicode.com/posts',
  );

  if (kDebugMode) {
    print(response.data);
  }
}