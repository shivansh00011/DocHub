import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gdocs/colors.dart';
import 'package:gdocs/common/loader.dart';
import 'package:gdocs/models/document_model.dart';
import 'package:gdocs/models/error_model.dart';
import 'package:gdocs/repository/auth_repository.dart';
import 'package:gdocs/repository/document_repository.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  void signOut(WidgetRef ref){
    ref.read(authRepositoryProvider).signOut();
    ref.read(userProvider.notifier).update((state)=>null);
  }
  void createDocument(BuildContext context,WidgetRef ref) async{
    String token = ref.read(userProvider)!.token;
    final navigator = Routemaster.of(context);
    final snackbar = ScaffoldMessenger.of(context);

    final errorModel = await ref.read(DocumentRepositoryProvider).createDocument(token);

    if(errorModel.data!=null){
      navigator.push('/document/${errorModel.data.id}');
    } else{
      snackbar.showSnackBar(SnackBar(content: Text(errorModel.error!)));
    }

  }

  void navigateToDocument(BuildContext context, String documentId){
    Routemaster.of(context).push('/document/$documentId');
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: ()=> createDocument(context,ref), icon: Icon(Icons.add)),
          IconButton(onPressed: ()=>signOut(ref), icon: Icon(Icons.logout, color: kRedColor,)),
        ],
      ),
      body: FutureBuilder(
  future: ref.watch(DocumentRepositoryProvider).getDocuments(ref.watch(userProvider)!.token),
  builder: (context, AsyncSnapshot<ErrorModel> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Loader();
    }

    if (snapshot.hasData) {
      final errorModel = snapshot.data!;
      if (errorModel.error != null) {
        print('ErrorModel error: ${errorModel.error}');
        return Center(child: Text('Error: ${errorModel.error}'));
      } else if (errorModel.data != null) {
        final documents = errorModel.data as List<DocumentModel>;
        return Center(
          child: Container(
            width: 600,
            margin: const EdgeInsets.only(top: 10),
            child: ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                DocumentModel document = documents[index];
                return InkWell(
                  onTap: ()=> navigateToDocument(context,document.id),
                  child: SizedBox(
                    height: 50,
                    child: Card(
                      child: Center(
                        child: Text(
                          document.title,
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }
    }

    print('No documents found or unexpected error.');
    return Center(child: Text('No documents found'));
  },
),



    );
  }
}
