import 'package:get/get.dart';
import 'package:osc25/core/data/network_client.dart';
import 'package:osc25/features/authentication/data/models/response/login_failure_response.dart';
import 'package:osc25/features/authentication/data/models/response/login_success_response.dart';
import 'package:dartz/dartz.dart';

class AuthDataSource {
  final networkClient = Get.find<NetworkClient>();

  Future<Either<LoginFailureResponse, LoginSuccessResponse>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await networkClient.postRequest(
        'api/mobile/v1/auth/login',
        // {'email': email, 'password': password},

        /// TODO: JUST FOR TESTING WILL BE REMOVED
        {"email": "manel.kacem@orange.com", "password": "test1234"},
        requiresAuthentication: false,
      );

      if (response.statusCode == 200) {
        return Right(LoginSuccessResponse.fromJson(response.data));
      } else {
        return Left(LoginFailureResponse.fromJson(response.data));
      }
    } catch (e) {
      print('error $e');
      return Left(LoginFailureResponse(message: 'error'));
    }
  }
}
