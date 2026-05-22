class RequestResponse {
  late bool success;
  // List<Errors>? errors = [];
  String? error;

  Map<String, dynamic> data = {};

  RequestResponse(this.success, {this.error});

  RequestResponse.fromJson(json) {
    data = json;
    success = json['success'] ?? false;
    // if (json['errors'] != null) {
    //   errors = <Errors>[];
    //   json['errors'].forEach((v) {
    //     errors?.add(Errors.fromJson(v));
    //   });
    // }
    error = json['error'];
  }

  toJson() {
    return {
      'success': success,
      'data': data,
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
