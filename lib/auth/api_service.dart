import 'package:education_app/auth/user_models.dart';
import 'package:dio/dio.dart';

class ApiService {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  static Future<UserModel> getUser() async {
    final response = await dio.get('users/1');
    return UserModel.fromJson(response.data);
  }

  // DIO SERVICE
  //  فقط اگر API خارجی نیاز شداین قسمت فعال می‌شود
  /*
  static final Dio dio = Dio(

    BaseOptions(

      baseUrl: 'https://dummyjson.com/',

      connectTimeout:
          Duration(seconds: 10),

      receiveTimeout:
          Duration(seconds: 10),
    ),
  );

  // GET USER

  static Future getUser() async {

    final response =
        await dio.get('users/1');

    return response.data;
  }
  */
}
