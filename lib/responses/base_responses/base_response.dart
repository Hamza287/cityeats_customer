class BaseResponse {
  late bool success;
  String? error;
  // List<Errors>? errors = [];

  BaseResponse(this.success, {this.error});

  BaseResponse.fromJson(json) {
    success = json['success'] ?? false;
    error = json['error'];
  }

  toJson() {
    return {
      'success': success,
      // 'error': errors?.map((v) => v.toJson()).toList()
      'error': error
    };
  }
}

class Errors {
  String? type;
  String? message;

  Errors({this.type, this.message});

  Errors.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['message'] = message;
    return data;
  }
}
