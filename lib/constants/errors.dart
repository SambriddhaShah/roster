class ApiError implements Exception {
  final String message;
  final int? statusCode;
  final String? type;

  ApiError( {required this.type,required this.message,  this.statusCode});

  @override
  String toString() => 'ApiError: $message';
}

class BlocError implements Exception{
  final String message;
  final String type;
  final String statuscode;

  BlocError( {required this.message,required this.type, required this.statuscode,});
}


