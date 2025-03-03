

import 'package:rooster_empployee/service/apiService.dart';

class Signuprepository {
  final ApiService apiService;

  Signuprepository(this.apiService);

  // // Perform user login authentication.
  // Future<SignupResponse> Signup() async {
  //   var response = await apiService.Signup();

  //   SignupResponse productResposne =
  //       SignupResponse.fromJson(response!.data);
  //   return productResposne;
  // }
}