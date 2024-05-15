

class ErrorModel{
  String message;
  int statusCode;

  ErrorModel({
 required this.statusCode,
 required this.message
});

  factory ErrorModel.fromJson(Map<String, dynamic> json)=> ErrorModel(
    message: json['message'],
    statusCode: json['code']
  );
}