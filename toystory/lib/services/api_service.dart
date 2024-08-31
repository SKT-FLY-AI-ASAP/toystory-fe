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

    // 인터셉터 추가
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('--- Request ---');
        print('URL: ${options.uri}');
        print('Method: ${options.method}');
        print('Headers: ${options.headers}');
        print('Data: ${options.data}');
        print('----------------');
        handler.next(options); // 요청을 계속 진행
      },
      onResponse: (response, handler) {
        print('--- Response ---');
        print('Status code: ${response.statusCode}');
        print('Data: ${response.data}');
        print('----------------');
        handler.next(response); // 응답을 계속 진행
      },
      onError: (DioException e, handler) {
        print('--- Error ---');
        print('Error: ${e.message}');
        if (e.response != null) {
          print('Status code: ${e.response?.statusCode}');
          print('Data: ${e.response?.data}');
        }
        print('----------------');
        handler.next(e); // 오류를 계속 진행
      },
    ));
  }

  // 이메일 인증 링크 전송
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
      throw Exception('네트워크 오류가 발생했습니다. 다시 시도해주세요');
    }
  }

  // 닉네임 중복 확인
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

  // 이메일 인증상태 확인
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

  // 로그인
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
    required String title,
    required File file,
  }) async {
    try {
      String? accessToken = TokenStorage.getToken();

      MultipartFile multipartFile = await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
        contentType: MediaType('image', 'png'),
      );

      final response = await _dio.post(
        '/doc/2d',
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-type': 'multipart/form-data',
        }),
        data: FormData.fromMap({
          'title': title,
          'file': multipartFile,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data;
        print('스케치북 생성 성공: $responseData');
        return responseData;
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
      String? accessToken = await TokenStorage.getToken();
      final response = await _dio.get(
        '/doc/3d/list',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        print(responseData);

        return responseData;
      } else {
        throw Exception('3D 아이템 리스트 조회에 실패했습니다. 다시 시도해주세요.');
      }
    } catch (e) {
      print(e);
      throw Exception('네트워크 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  Future<dynamic> fetchSttItems() async {
    try {
      String? accessToken = await TokenStorage.getToken();
      final response = await _dio.get(
        '/doc/stt/list',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        print(responseData);

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
      String? accessToken = await TokenStorage.getToken();

      final response = await _dio.get(
        '/doc/$contentId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

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

  // 주문외우기 조회
  Future<dynamic> fetchMagicItems() async {
    try {
      String? accessToken = await TokenStorage.getToken();
      final response = await _dio.get(
        '/doc/stt/list',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        print(responseData);

        return responseData;
      } else {
        throw Exception('3D 아이템 리스트 조회에 실패했습니다. 다시 시도해주세요.');
      }
    } catch (e) {
      print(e);
      throw Exception('네트워크 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  // 로그아웃 함수
  Future<void> logout() async {
    try {
      String? accessToken = await TokenStorage.getToken();
      final response = await _dio.delete(
        '/user/session',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('로그아웃 성공');
        TokenStorage.clearToken();
      } else {
        throw Exception('로그아웃에 실패했습니다. 다시 시도해주세요.');
      }
    } catch (e) {
      print(e);
      throw Exception('네트워크 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  // 가입 정보 조회
  Future<dynamic> fetchUserInfo() async {
    try {
      String? accessToken = await TokenStorage.getToken();
      final response = await _dio.get(
        '/user/info',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        return responseData;
      } else {
        throw Exception('사용자 정보 조회에 실패했습니다. 다시 시도해주세요.');
      }
    } catch (e) {
      print(e);
      throw Exception('네트워크 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  // 스케치북 장난감 생성 요청
  Future<dynamic> createToy({
    required int sketch_id,
    required String title,
  }) async {
    try {
      String? accessToken = await TokenStorage.getToken();
      final response = await _dio.post(
        '/doc/2d/3d',
        data: {
          'sketch_id': sketch_id,
          'title': title,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201) {
        final responseData = response.data;
        return responseData;
      } else {
        throw Exception('장난감 생성에 실패했습니다. 다시 시도해주세요.');
      }
    } catch (e) {
      print(e);
      throw Exception('네트워크 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  // 주문 외우기 새로 만들기
  Future<void> createStt({
    required String title,
    required String prompt,
  }) async {
    try {
      String? accessToken = await TokenStorage.getToken();
      final response = await _dio.post(
        '/doc/stt/3d',
        data: {
          'title': title,
          'prompt': prompt,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201) {
        final responseData = response.data;
        return responseData;
      } else {
        throw Exception('주문외우기에 실패했습니다. 다시 시도해주세요.');
      }
    } catch (e) {
      print(e);
      throw Exception('네트워크 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }
}
