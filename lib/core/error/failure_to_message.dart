import 'package:privac/core/error/failures.dart';

String mapFailureToMessage(Failure failure) {
  if (failure is ServerFailure) {
    return failure.message;
  }
  switch (failure.runtimeType) {
    case CacheFailure _:
      return 'Cache Failure';
    default:
      return 'Unexpected error';
  }
}
