class ApiResponseModel<T> {
  final bool success;
  final String message;
  final T? data;

  const ApiResponseModel({this.success = false, this.message = '', this.data});

  factory ApiResponseModel.fromJson(Map<String, dynamic> json,
      T Function(dynamic value)? parser) {
    final raw = json['data'];
    return ApiResponseModel<T>(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: raw == null ? null : parser?.call(raw),
    );
  }
}
