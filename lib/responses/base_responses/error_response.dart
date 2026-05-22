class RequestErrorResponse {
  late bool success;
  String? error;
  String? body;

  RequestErrorResponse({this.success = false, this.error, this.body});

  RequestErrorResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    error = json['error'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['body'] = body;
    return data;
  }
}
