import 'package:dio/dio.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

class TokenStorage {
  static String? _accessToken;

  // Access Token 저장
  static void saveToken(String token) {
    _accessToken = token;
  }

  // Access Token 가져오기
  static String? getToken() {
    return _accessToken;
  }

  // Access Token 삭제
  static void clearToken() {
    _accessToken = null;
  }
}

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.baseUrl = 'http://52.79.56.132:8080/api/v1';
  }

  //이메일 인증 링크 전송
  Future<void> sendVerificationLink(String email) async {
    try {
      final response = await _dio.post(
        '/user/link',
        data: {'email': email},
        options: Options(headers: {
          'Content-type': 'application/json',
        }),
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
        options: Options(headers: {
          'Content-type': 'application/json',
        }),
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

  //로그인
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/user/session',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(headers: {
          'Content-type': 'application/json',
        }),
      );

      print(response.statusCode);

      if (response.statusCode == 201) {
        TokenStorage.saveToken(response.data['data']['access_token']);
        //print(response.data['data']['access_token']);
        //print(response.data[data]['access_token']);
        //print(responseData['data']['access_token']);
        print('Login successful.');
      } else {
        print(response.data);
        throw Exception('로그인에 실패했습니다. 다시 시도해주세요.');
      }
    } catch (e) {
      print(e);
      throw Exception('로그인에 실패했습니다. 다시 시도해주세요.');
    }
  }

  // 스케치북 리스트 조회
  Future<dynamic> fetchSketchbookList() async {
    try {
      String? accessToken = TokenStorage.getToken();
      final response = await _dio.get(
        '/doc/2d/list',
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        print(responseData);

        // 응답 데이터를 반환
        return responseData;
      } else {
        throw Exception('스케치북 리스트 조회에 실패했습니다. 다시 시도해주세요.');
      }
    } catch (e) {
      print(e);
      throw Exception('네트워크 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  // 스케치북 새로 만들기 (PNG 파일 업로드)
  Future<dynamic> createSketchbook({
    required String title, // 스케치북 제목
    required File file, // PNG 파일
  }) async {
    try {
      String? accessToken = TokenStorage.getToken();

      // MultipartFile로 파일 변환
      MultipartFile multipartFile = await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last, // 파일 이름 지정
        contentType: MediaType('image', 'png'), // MIME 타입 지정
      );

      // POST 요청 보내기 (multipart/form-data)
      final response = await _dio.post(
        '/doc/2d',
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken', // 토큰 추가
          'Content-type': 'multipart/form-data', // Content-Type 지정
        }),
        data: FormData.fromMap({
          'title': title, // 요청에 필요한 필드
          'file': multipartFile, // PNG 파일 업로드
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data;
        print('스케치북 생성 성공: $responseData');
        return responseData; // 생성된 스케치북 데이터 반환
      } else {
        throw Exception('스케치북 생성에 실패했습니다. 다시 시도해주세요.');
      }
    } catch (e) {
      print(e);
      throw Exception('네트워크 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

// 3D 아이템 조회

  Future<dynamic> fetchThreeDItems() async {
    try {
      String? accessToken = await TokenStorage
          .getToken(); // Assuming this fetches the token asynchronously
      final response = await _dio.get(
        '/doc/3d/list', // Replace with your actual API endpoint for 3D items
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        print(responseData);

        // 응답 데이터를 반환
        return responseData;
      } else {
        throw Exception('3D 아이템 리스트 조회에 실패했습니다. 다시 시도해주세요.');
      }
    } catch (e) {
      print(e);
      throw Exception('네트워크 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  // 3D 세부 조회 API 함수
  Future<dynamic> fetch3DItemDetails({required int contentId}) async {
    try {
      // Access Token을 비동기로 가져오기
      String? accessToken = await TokenStorage.getToken();

      // GET 요청 보내기 (세부 조회 경로에 contentId 포함)
      final response = await _dio.get(
        '/doc/$contentId', // 경로에 contentId 삽입
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      // 응답 확인
      if (response.statusCode == 200) {
        final responseData = response.data;
        print(responseData);
        return responseData['data'];
      } else {
        throw Exception('3D 아이템 세부 조회에 실패했습니다. 다시 시도해주세요.');
      }
    } catch (e) {
      print(e);
      throw Exception('네트워크 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }
}
