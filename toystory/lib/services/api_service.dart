import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.baseUrl = 'http://52.79.56.132:8080/api/v1';
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
  }

  //이메일 인증 링크 전송
  Future<void> sendVerificationLink(String email) async {
    try {
      final response = await _dio.post(
        '/user/link',
        data: {'email': email},
      );

      if (response.statusCode == 201) {
        print('Verification link sent.');
      } else {
        print(response.data);
        throw Exception('이메일 전송에 실패했습니다. 다시 시도해주세요.');
      }
    } catch (e) {
      print(e);
      throw Exception('네트워크 오류가 발생했습니다 다시 시도해주세요');
    }
  }

  //닉네임 중복 확인
  Future<void> checkNicknameAvailability(String nickname) async {
    try {
      final response = await _dio.get(
        '/user/nickname',
        queryParameters: {'nickname': nickname},
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['message'] == "OK.") {
          print('Nickname is available.');
        } else {
          throw Exception('닉네임이 중복되었습니다. 다시 시도해 주세요. ');
        }
      } else {
        throw Exception('닉네임 중복 확인에 실패했습니다. 다시 시도해 주세요.');
      }
    } catch (e) {
      throw Exception('네트워크 오류가 발생했습니다. 다시 시도해 주세요.');
    }
  }

  //이메일 인증상태 확인
  Future<void> checkEmailVerificationStatus(String email) async {
    try {
      final response =
          await _dio.get('/user/email', queryParameters: {'email': email});

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['message'] == "Verified.") {
          print('이메일이 인증되었습니다. 회원가입을 진행해주세요.');
        } else {
          throw Exception('이메일 인증이 완료되지 않았습니다. 이메일을 확인해 주세요.');
        }
      } else {
        print(response.data);
        throw Exception('이메일 인증 상태 확인에 실패했습니다. 다시 시도해 주세요.');
      }
    } catch (e) {
      print(e);
      throw Exception('네트워크 오류 다시 시도해주세요');
    }
  }

  // 회원가입
  Future<void> signup({
    required String email,
    required String password,
    required String nickname,
    required String phone,
    required String address,
  }) async {
    try {
      final response = await _dio.post(
        '/user',
        data: {
          'email': email,
          'password': password,
          'nickname': nickname,
          'phone': phone,
          'address': address,
        },
      );

      if (response.statusCode == 201) {
        print('Signup successful.');
      } else {
        print(response);
        print('ee');
        throw Exception('회원가입에 실패했습니다. 다시 시도해주세요.');
      }
    } catch (e) {
      print(e);
      throw Exception('회원가입에 실패했습니다. 다시 시도해주세요.');
    }
  }
}
