class Failure {}

class ServerFailure extends Failure {
  final String message;

  ServerFailure(this.message);

  @override
  String toString() => message;
}

class CacheFailure extends Failure {}
