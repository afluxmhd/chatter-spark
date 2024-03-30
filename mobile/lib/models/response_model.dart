// ignore_for_file: public_member_api_docs, sort_constructors_first
class ResponseModel {
  ResponseModel({required this.body, this.isError = false, this.errorMessage = ''});
  final String body;
  final bool isError;
  final String errorMessage;

  ResponseModel copyWith({
    String? body,
    bool? isError,
    String? errorMessage,
  }) =>
      ResponseModel(
        body: body ?? this.body,
        isError: isError ?? this.isError,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
