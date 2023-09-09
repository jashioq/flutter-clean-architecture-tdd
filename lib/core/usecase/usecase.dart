import 'package:tdd_tutorial/core/utils/typedef.dart';

abstract class UsecaseWithParams<Type, Params> {
  const UsecaseWithParams();

  ResultFuture<Type> call(Params params);
}

abstract class UsecaseWithoutPrams<Type> {
  const UsecaseWithoutPrams();

  ResultFuture<Type> call();
}
