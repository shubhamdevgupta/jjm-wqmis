import '../models/LoginResponse.dart';
import '../services/BaseApiService.dart';
import '../utils/CustomException.dart';

class UserRepository {
  final BaseApiService _apiService = BaseApiService();

  Future<LoginResponse> loginUser(String phoneNumber, String password) async {
    final response = await _apiService.post(
      'JJM_Mobile/Login',
      headers: {'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: {
        'phone': phoneNumber,
        'password': password,
      },
    );
    return LoginResponse.fromJson(response);
  }
}
