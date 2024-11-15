import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gdocs/constants.dart';
import 'package:gdocs/models/error_model.dart';
import 'package:gdocs/models/user_model.dart';
import 'package:gdocs/repository/local_storage_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
      googleSignIn: GoogleSignIn(),
      client: Client(),
      localStorageRepository: LocalStorageRepository(),
    ));

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStorageRepository _localStorageRepository;

  AuthRepository({
    required GoogleSignIn googleSignIn,
    required Client client,
    required LocalStorageRepository localStorageRepository,
  })  : _googleSignIn = googleSignIn,
        _client = client, _localStorageRepository = localStorageRepository;

Future<ErrorModel> signInWithGoogle() async {
  ErrorModel error = ErrorModel(error: 'Something went wrong', data: null);
  try {
    final user = await _googleSignIn.signIn();
    if (user != null) {
      final userAcc = UserModel(
        email: user.email,
        name: user.displayName!,
        profilePic: user.photoUrl!,
        id: '', // This will be updated after getting the response
        token: '', // This will be updated after getting the response
      );

      // Sending the POST request
      var res = await _client.post(
        Uri.parse('$host/api/signup'),
        body: jsonEncode(userAcc.toJson()),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print('Response Status Code: ${res.statusCode}');
      print('Response Body: ${res.body}');

      if (res.statusCode == 200) {
        final responseBody = jsonDecode(res.body);
        
        // Use _id from the response
        final newUser = userAcc.copyWith(
          id: responseBody['user']['_id'], // Correctly assigning _id to id
          token: responseBody['token'], // Assign token if available
        );

        // Return the new user with updated id and token
        error =  ErrorModel(error: null, data: newUser); // No error means success
        _localStorageRepository.setToken(newUser.token);
      } else {
        error = ErrorModel(error: 'Bad request. Please check the data being sent.', data: null);
      }
    } else {
      error = ErrorModel(error: 'User canceled the sign-in process', data: null);
    }
  } catch (e) {
    error = ErrorModel(error: 'Error occurred: ${e.toString()}', data: null);
  }
  return error;
}
Future<ErrorModel> getUserData() async {
  ErrorModel error = ErrorModel(error: 'Something went wrong', data: null);
  try {
    String? token = await _localStorageRepository.getToken();
    if(token !=null){
       var res = await _client.get(
        Uri.parse('$host/'),
       
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );
      if (res.statusCode == 200) {
        final responseBody = jsonDecode(res.body);
        
        // Use _id from the response
        final newUser = UserModel.fromJson(jsonEncode(jsonDecode(res.body)['user'])).copyWith(token: token);

        // Return the new user with updated id and token
        error =  ErrorModel(error: null, data: newUser); // No error means success
        _localStorageRepository.setToken(newUser.token);
      } else {
        error = ErrorModel(error: 'Bad request. Please check the data being sent.', data: null);
      }

    }

      
     

   

      
    
  } catch (e) {
    error = ErrorModel(error: 'Error occurred: ${e.toString()}', data: null);
  }
  return error;
}

void signOut() async{
  _localStorageRepository.setToken('');

}
}