import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const testModel = UserModel.empty();
  final testJson = fixture('user.json');
  final testMap = jsonDecode(testJson) as DataMap;

  test(
    'should be a subclass of [User] entity',
    () {
      expect(testModel, isA<User>());
    },
  );

  group(
    'fromMap',
    () {
      test(
        'should return [UserModel] with the right data',
        () {
          final result = UserModel.fromMap(testMap);
          expect(result, equals(testModel));
        },
      );
    },
  );

  group(
    'fromJson',
    () {
      test(
        'should return [UserModel] with the right data',
        () {
          final result = UserModel.fromJson(testJson);
          expect(result, equals(testModel));
        },
      );
    },
  );

  group(
    'toMap',
    () {
      test(
        'should return [Map] with the right data',
        () {
          final result = testModel.toMap();
          expect(result, equals(testMap));
        },
      );
    },
  );

  group(
    'toJson',
    () {
      test(
        'should return [Json] string with the right data',
        () {
          final testJson = jsonEncode({
            "id": "1",
            "createdAt": "_empty.createdAt",
            "name": "_empty.name",
            "avatar": "_empty.avatar"
          });
          final result = testModel.toJson();
          expect(result, equals(testJson));
        },
      );
    },
  );

  group(
    'copyWith',
    () {
      test(
        'should return a [UserModel] with different data',
        () {
          const testName = 'TestName';
          final result = testModel.copyWith(name: testName);
          expect(result.name, equals(testName));
        },
      );
    },
  );
}
