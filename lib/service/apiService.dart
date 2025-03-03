

import 'package:dio/dio.dart';
import 'package:rooster_empployee/constants/errors.dart';

class ApiService {
  final Dio dio;

  ApiService(this.dio) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Optional: You can log the request here
        print('Request: ${options.method} ${options.uri}');
        return handler.next(options); // Continue with the request
      },
      onResponse: (response, handler) {
        // Optional: You can log the response here
        print('Response: ${response.statusCode} ${response.data}');
        return handler.next(response); // Continue with the response
      },
      onError: (DioException error, handler) {
        // Centralized error handling logic
        print('Error: ${error.message}');
        
        // Handling error types (timeout, no internet, etc.)
        if (error.type == DioExceptionType.connectionTimeout) {
          // Handle timeout error
          throw ApiError(message: 'Connection timeout. Please try again later.', type: 'api error');
        } else if (error.type == DioExceptionType.receiveTimeout) {
          // Handle receive timeout
          throw ApiError(message: 'The server took too long to respond.', type: 'api error');
        } else if (error.type == DioExceptionType.connectionError) {
          // Handle network errors (like no internet)
          throw ApiError(message: 'Network error. Please check your internet connection.', type: 'api error');
        }else if (error.type == DioExceptionType.cancel) {
          // Handle cancel errors (like server cancels request)
          throw ApiError(message: 'The request was canceled.', type: 'api error');
        } else if (error.response != null) {
          // Handle response errors (like 4xx, 5xx)
          final statusCode = error.response?.statusCode;
          if (statusCode == 404) {
            throw ApiError(message: 'Not Found: ${error.response?.data['message'] ?? 'No data found.'}', type: 'api error');
          } else if (statusCode == 500) {
            throw ApiError(message: 'Server Error. Please try again later.', type: 'api error');
          } else {
            throw ApiError(message: 'Unexpected error: ${error.response?.data['message'] ?? 'Please try again.'}', type: 'api error');
          }
        } else {
          // For any other errors
          throw ApiError(message: 'An unexpected error occurred: ${error.message}', type: 'api error');
        }
// Continue with the error
      },
    ));
  }

  // Example function to fetch data from an API
  Future<Map<String, dynamic>> fetchData(String url) async {
    try {
      final response = await dio.get(url);
      return response.data;
    } catch (error) {
      rethrow; // Rethrow the error to be caught by the repository or BLoC
    }
  }
}
