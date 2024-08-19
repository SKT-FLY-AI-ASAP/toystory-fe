import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.baseUrl = 'http://52.79.56.132:8080/api/v1';
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
  }

  Future<void> checkEmailVerificationStatus(String email) async {
    try {
      final response =
          await _dio.get('/user/email', queryParameters: {'email': email});

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['message'] == "Verified.") {
          // 이메일 인증 완료
          print('Email verified. Proceeding with sign up...');
        } else {
          throw Exception('이메일 인증이 완료되지 않았습니다. 이메일을 확인해 주세요.');
        }
      } else {
        throw Exception('이메일 인증 상태 확인에 실패했습니다. 다시 시도해 주세요.');
      }
    } catch (e) {
      throw Exception('네트워크 오류가 발생했습니다. 다시 시도해 주세요.');
    }
  }

  Future<void> sendVerificationLink(String email) async {
    try {
      final response = await _dio.post(
        '/user/link',
        data: {'email': email},
      );

      if (response.statusCode == 201) {
        print('Verification link sent.');
      } else {
        throw Exception('Failed to send email. Please try again.');
      }
    } catch (e) {
      throw Exception('네트워크 오류가 발생했습니다. 다시 시도해 주세요.');
    }
  }
}
