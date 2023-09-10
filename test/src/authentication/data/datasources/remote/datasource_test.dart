import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/utils/constants.dart';
import 'package:tdd_tutorial/src/authentication/data/datasources/remote/datasource.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthenticationRemoteDatasource remoteDatasource;

  setUp(
    () {
      client = MockClient();
      remoteDatasource = AuthenticationRemoteDatasourceImpl(client);
    },
  );

  group(
    'createUser',
    () {
      test(
        'should complete succesfully when the status code is 200 or 201',
        () async {
          when(() => client.post(any(), body: any(named: 'body'))).thenAnswer(
            (_) async => http.Response('User created successfully', 201),
          );

          final methodCall = remoteDatasource.createUser;

          expect(
              () => methodCall(
                    createdAt: 'createdAt',
                    name: 'name',
                    avatar: 'avatar',
                  ),
              completes);

          verify(
            () => client.post(
              Uri.parse('$kBaseUrl$kCreateUserEndpoint'),
              body: jsonEncode(
                {
                  'createdAt': 'createdAt',
                  'name': 'name',
                  'avatar': 'avatar',
                },
              ),
            ),
          ).called(1);

          verifyNoMoreInteractions(client);
        },
      );
    },
  );
}
