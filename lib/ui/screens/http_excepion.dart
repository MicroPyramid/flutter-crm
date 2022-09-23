class HttpException implements Exception {
  final String errorMessage;

  HttpException(this.errorMessage);

  @override
  String toString() {
    return errorMessage;
  }
}
