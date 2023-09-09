import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';

import 'authentication_repository.mock.dart';

void main() {
  late AuthenticationRepository repository;
  late GetUsers usecase;

  setUp(() {
    repository = MockAuthRepository();
    usecase = GetUsers(repository);
  });

  const testResponse = [User.empty()];

  test(
    "should call [AuthRepository.getUsers] and return [List<User>]",
    () async {
      when(() => repository.getUsers()).thenAnswer(
        (_) async => Right(testResponse),
      );
      final result = await usecase();

      expect(result, equals(const Right<dynamic, List<User>>(testResponse)));
      verify(() => repository.getUsers()).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
