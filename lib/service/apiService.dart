// import 'package:dio/dio.dart';
// import 'package:rooster_empployee/constants/errors.dart';
// import 'package:rooster_empployee/service/apiUrls.dart';

// class ApiService {
//   final Dio dio;
//   ApiService(this.dio){
//     dio.interceptors.add(InterceptorsWrapper(
//   onRequest: (options, handler) {
//     print('Request: ${options.method} ${options.uri}');
//     return handler.next(options);
//   },
//   onResponse: (response, handler) {
//     print('Response: ${response.statusCode} ${response.data}');
//     return handler.next(response);
//   },
//   onError: (DioException error, handler) {
//     print('Error: ${error.message}');

//     late ApiError customError;

//     if (error.type == DioExceptionType.connectionTimeout) {
//       customError = ApiError(
//         message: 'Connection timeout. Please try again later.',
//         type: 'connection_timeout',
//       );
//     } else if (error.type == DioExceptionType.receiveTimeout) {
//       customError = ApiError(
//         message: 'Server took too long to respond.',
//         type: 'receive_timeout',
//       );
//     } else if (error.type == DioExceptionType.connectionError) {
//       customError = ApiError(
//         message: 'No internet connection.',
//         type: 'network_error',
//       );
//     } else if (error.type == DioExceptionType.badResponse) {
//       final statusCode = error.response?.statusCode ?? 0;
//       final messageFromServer = error.response?.data['message'] ?? 'Unknown error';

//       if (statusCode == 404) {
//         customError = ApiError(
//           message: 'Not Found: $messageFromServer',
//           type: 'not_found',
//         );
//       } else if (statusCode == 500) {
//         customError = ApiError(
//           message: 'Server error. Try again later.',
//           type: 'server_error',
//         );
//       } else {
//         customError = ApiError(
//           message: 'Unexpected error: $messageFromServer',
//           type: 'unknown_error',
//         );
//       }
//     } else {
//       customError = ApiError(
//         message: 'Something went wrong. Please try again.',
//         type: 'unknown',
//       );
//     }

//     // 👇 Wrap ApiError inside DioException
//     final customDioError = DioException(
//       requestOptions: error.requestOptions,
//       response: error.response,
//       type: error.type,
//       error: customError, // Injecting our ApiError here
//     );

//     handler.reject(customDioError);
//   },
// ));

//   }

// //   ApiService(this.dio) {
// //     dio.interceptors.add(InterceptorsWrapper(
// //       onRequest: (options, handler) {
// //         // Optional: You can log the request here
// //         print('Request: ${options.method} ${options.uri}');
// //         return handler.next(options); // Continue with the request
// //       },
// //       onResponse: (response, handler) {
// //         // Optional: You can log the response here
// //         print('Response: ${response.statusCode} ${response.data}');
// //         return handler.next(response); // Continue with the response
// //       },
// //       onError: (DioException error, handler) {
// //         // Centralized error handling logic
// //         print('Error: ${error.message}');

// //         // Handling error types (timeout, no internet, etc.)
// //         if (error.type == DioExceptionType.connectionTimeout) {
// //           // Handle timeout error
// //           throw ApiError(
// //               message: 'Connection timeout. Please try again later.',
// //               type: 'api error');
// //         } else if (error.type == DioExceptionType.receiveTimeout) {
// //           // Handle receive timeout
// //           throw ApiError(
// //               message: 'The server took too long to respond.',
// //               type: 'api error');
// //         } else if (error.type == DioExceptionType.connectionError) {
// //           // Handle network errors (like no internet)
// //           throw ApiError(
// //               message: 'Network error. Please check your internet connection.',
// //               type: 'api error');
// //         } else if (error.type == DioExceptionType.cancel) {
// //           // Handle cancel errors (like server cancels request)
// //           throw ApiError(
// //               message: 'The request was canceled.', type: 'api error');
// //         } else if (error.response != null) {
// //           // Handle response errors (like 4xx, 5xx)
// //           final statusCode = error.response?.statusCode;
// //           if (statusCode == 404) {
// //             throw ApiError(
// //                 message:
// //                     'Not Found: ${error.response?.data['message'] ?? 'No data found.'}',
// //                 type: 'api error');
// //           } else if (statusCode == 500) {
// //             throw ApiError(
// //                 message: 'Server Error. Please try again later.',
// //                 type: 'api error');
// //           } else {
// //             throw ApiError(
// //                 message:
// //                     'Unexpected error: ${error.response?.data['message'] ?? 'Please try again.'}',
// //                 type: 'api error');
// //           }
// //         } else {
// //           // For any other errors
// //           throw ApiError(
// //               message: 'An unexpected error occurred: ${error.message}',
// //               type: 'api error');
// //         }
// // // Continue with the error
// //       },
// //     ));
// //   }

//   // Example function to fetch data from an API
//   Future<Map<String, dynamic>> fetchData(String url) async {
//     try {
//       final response = await dio.get(url);
//       return response.data;
//     } catch (error) {
//       rethrow; // Rethrow the error to be caught by the repository or BLoC
//     }
//   }

//   Future<Map<String, dynamic>> loginCandidate(
//       String email, String password) async {
//     try {
//       final response = await dio.post(
//         ApiUrl.login,
//         data: {
//           'email': email,
//           'password': password,
//         },
//         options: Options(
//           headers: {
//             'accept': 'application/json',
//             'Content-Type': 'application/json',
//           },
//         ),
//       );
//       print('the login data is ${response.data}');

//       return response.data;
//     } catch (error) {
//       print('the ereror in function is $error');
//       rethrow;
//     }
//   }
// }
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rooster_empployee/constants/errors.dart';
import 'package:rooster_empployee/service/apiUrls.dart';
import 'package:rooster_empployee/service/flutterSecureData.dart';

class ApiService {
  final Dio dio;

  final List<String> excludeAuthUrls = [
    ApiUrl.login,
    ApiUrl.refreshToken,
  ];

  ApiService(this.dio) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        print('Request: ${options.method} ${options.uri}');

        // Skip token for excluded URLs
        if (!excludeAuthUrls.contains(options.path)) {
          final accessToken = await FlutterSecureData.getAccessToken();
          if (accessToken != null && accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
        }
        print('🔄 Sending Request:');
        print('➡️ Method: ${options.method}');
        print('📍 URL: ${options.uri}');
        print('🧾 Headers: ${options.headers}');
        print('📦 Body: ${options.data}');
        print('🔍 Query Params: ${options.queryParameters}');

        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('Response: ${response.statusCode} ${response.data}');
        return handler.next(response);
      },
      onError: (DioException error, handler) async {
        print('Error: ${error.message}');
        print('the data in error is ${error.response?.data}');

        final requestOptions = error.requestOptions;

        // 🔄 Attempt to refresh token on 401
        if (error.response?.statusCode == 401 &&
            !excludeAuthUrls.contains(requestOptions.path)) {
          final refreshToken = await FlutterSecureData.getRefreshToken();

          if (refreshToken != null && refreshToken.isNotEmpty) {
            try {
              // Send request to refresh token
              final tokenResponse = await dio.post(
                ApiUrl.refreshToken,
                data: {'refreshToken': refreshToken},
                options: Options(headers: {
                  'Content-Type': 'application/json',
                }),
              );

              final newAccessToken = tokenResponse.data['accessToken'];
              final newRefreshToken = tokenResponse.data['refreshToken'];

              if (newAccessToken != null && newRefreshToken != null) {
                // Save new tokens
                await FlutterSecureData.setAccessToken(newAccessToken);
                await FlutterSecureData.setRefreshToken(newRefreshToken);

                // Retry original request with new token
                final clonedRequest = await dio.request(
                  requestOptions.path,
                  data: requestOptions.data,
                  queryParameters: requestOptions.queryParameters,
                  options: Options(
                    method: requestOptions.method,
                    headers: {
                      ...requestOptions.headers,
                      'Authorization': 'Bearer $newAccessToken',
                    },
                  ),
                );

                return handler.resolve(clonedRequest);
              }
            } catch (refreshError) {
              // Handle refresh failure (e.g., logout user)
              print('Token refresh failed: $refreshError');
              return handler.reject(error);
            }
          }
        }

        // ✋ Custom error mapping
        late ApiError customError;

        if (error.type == DioExceptionType.connectionTimeout) {
          customError = ApiError(
            message: 'Connection timeout. Please try again later.',
            type: 'connection_timeout',
          );
        } else if (error.type == DioExceptionType.receiveTimeout) {
          customError = ApiError(
            message: 'Server took too long to respond.',
            type: 'receive_timeout',
          );
        } else if (error.type == DioExceptionType.connectionError) {
          customError = ApiError(
            message: 'No internet connection.',
            type: 'network_error',
          );
        } else if (error.type == DioExceptionType.badResponse) {
          final statusCode = error.response?.statusCode ?? 0;
          String messageFromServer = 'Unknown error';
          try {
            final messageFromServer =
                error.response?.data['message'] ?? 'Unknown error';
          } catch (er) {
            print('Error parsing message from server: $er');
            final messageFromServer = 'Unknown error';
          }

          if (statusCode == 404) {
            customError = ApiError(
              message: 'Not Found: $messageFromServer',
              type: 'not_found',
            );
          } else if (statusCode == 500) {
            customError = ApiError(
              message: 'Server error. Try again later.',
              type: 'server_error',
            );
          } else {
            customError = ApiError(
              message: '$messageFromServer',
              type: 'unknown_error',
            );
          }
        } else {
          customError = ApiError(
            message: 'Something went wrong. Please try again.',
            type: 'unknown',
          );
        }

        handler.reject(DioException(
          requestOptions: error.requestOptions,
          response: error.response,
          type: error.type,
          error: customError,
        ));
      },
    ));
  }

  Future<Map<String, dynamic>> loginCandidate(
      String email, String password) async {
    try {
      final response = await dio.post(
        ApiUrl.login,
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      final data = response.data['data'];
      final accessToken = data['accessToken'];
      final refreshToken = data['refreshToken'];
      final jobId = data["jobId"];
      final dynamic candidate =
          //  "63adf99d-292c-4bc6-b800-00bf64560b65";
          data['id'];

      if (accessToken != null && refreshToken != null) {
        await FlutterSecureData.setAccessToken(accessToken);
        await FlutterSecureData.setRefreshToken(refreshToken);
        await FlutterSecureData.setCandidateId(candidate);
        await FlutterSecureData.setCandidateJobId(jobId);
      }

      return response.data;
    } catch (error) {
      print('Login error: $error');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getCandiate() async {
    final id = await FlutterSecureData.getCandidateId();
    try {
      final response = await dio.get(ApiUrl.getCandidate + id!);
      print('the response is ${response.data}');
      return response.data;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getCandiateStage() async {
    final id = await FlutterSecureData.getCandidateId();
    final jobId = await FlutterSecureData.getCandidateJobId();
    try {
      final response = await dio.get(
          // "http://69.62.123.60:3000/api/v1/ats/jobs/$jobId/candidate-stage/$id/stage"
          "${ApiUrl.candidateStage}/$jobId/candidate-stage/$id/stage"

          // ApiUrl.candidateStage + jobId! + "/candidate-stage/$id/stage"
          );
      print('the response fro cadidate stage is ${response.data}');
      return response.data;
    } catch (error) {
      rethrow;
    }
  }

  //logout function
  Future<bool> logout() async {
    final refreshToken = await FlutterSecureData.getRefreshToken();
    try {
      final response =
          await dio.post(ApiUrl.logout, data: {"refreshToken": refreshToken});
      if (response.statusCode == 200) {
        print('the response is ${response.data}');
        // Clear stored tokens
        await FlutterSecureData.deleteAccessToken();
        await FlutterSecureData.deleteRefreshToken();
        await FlutterSecureData.deleteCandidateId();
        return true; // Logout successful
      }
      return false; // Logout failed
    } catch (error) {
      print('Logout error: $error');
      rethrow;
    }
  }
}
// yaleb70572@lhory.com 
// 733Tan0a
//http://69.62.123.60:3000/api-docs/#/

//devomegabpo@gmail.com
// Ashe79l8y9