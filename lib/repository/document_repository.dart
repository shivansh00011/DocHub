import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gdocs/constants.dart';
import 'package:gdocs/models/document_model.dart';
import 'package:gdocs/models/error_model.dart';
import 'package:http/http.dart';

final DocumentRepositoryProvider = Provider((ref)=> DocumentRepository(client: Client()));

class DocumentRepository {
  final Client _client;
  DocumentRepository({
    required Client client,
  }): _client = client;

  Future<ErrorModel> createDocument(String token) async{
     ErrorModel error = ErrorModel(error: 'Something went wrong', data: null);
  try {
   
       var res = await _client.post(
        Uri.parse('$host/doc/create'),
       
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        }, body: jsonEncode({
          'createdAt': DateTime.now().millisecondsSinceEpoch,
        }),
      );
      if (res.statusCode == 200) {
       

        // Return the new user with updated id and token
        error =  ErrorModel(error: null, data: DocumentModel.fromJson(res.body)); // No error means success
        
      } else {
        error = ErrorModel(error: 'Bad request. Please check the data being sent.', data: null);
      }

    

      
     

   

      
    
  } catch (e) {
    error = ErrorModel(error: 'Error occurred: ${e.toString()}', data: null);
  }
  return error;

  }

 Future<ErrorModel> getDocuments(String token) async {
  ErrorModel error = ErrorModel(error: 'Something went wrong', data: null);
  try {
    final res = await _client.get(
      Uri.parse('$host/docs/me'), // Corrected URL
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      },
    );

    // Log the status code and response body
    print('Status code: ${res.statusCode}');
    print('Response body: ${res.body}');

    if (res.statusCode == 200) {
      List<DocumentModel> documents = (jsonDecode(res.body) as List)
          .map((doc) => DocumentModel.fromMap(doc))
          .toList();
      error = ErrorModel(error: null, data: documents);
    } else {
      error = ErrorModel(
          error: 'Failed to fetch documents. Status code: ${res.statusCode}', data: null);
    }
  } catch (e) {
    error = ErrorModel(error: 'Error occurred: ${e.toString()}', data: null);
    print('Error: $e'); // Log any exceptions
  }
  return error;
}

 void updateTitle({required String token,required String id,required String title}) async{
     
   
        await _client.post(
        Uri.parse('$host/doc/title'),
       
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        }, body: jsonEncode({
          'title': title,
          'id': id,
        }),
      );
      
  }

   Future<ErrorModel> getDocumentById(String token, String id) async {
  ErrorModel error = ErrorModel(error: 'Something went wrong', data: null);
  try {
    final res = await _client.get(
      Uri.parse('$host/doc/$id'), // Corrected URL
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      },
    );

    // Log the status code and response body
    print('Status code: ${res.statusCode}');
    print('Response body: ${res.body}');

    if (res.statusCode == 200) {
      error = ErrorModel(error: null, data: DocumentModel.fromJson(res.body));
    } 
  } catch (e) {
    error = ErrorModel(error: 'Error occurred: ${e.toString()}', data: null);
    print('Error: $e'); // Log any exceptions
  }
  return error;
}


}