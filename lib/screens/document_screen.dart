import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gdocs/colors.dart';
import 'package:gdocs/common/loader.dart';
import 'package:gdocs/models/document_model.dart';
import 'package:gdocs/models/error_model.dart';
import 'package:gdocs/repository/auth_repository.dart';
import 'package:gdocs/repository/document_repository.dart';
import 'package:gdocs/repository/socket_repository.dart';
import 'package:routemaster/routemaster.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  final String id;
  const DocumentScreen({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  final TextEditingController _titleController = TextEditingController(text: 'Untitled Document');
  QuillController? _controller ;
  ErrorModel? errorModel;
  SocketRepository socketRepository = SocketRepository();
  @override
  void initState() {
    
    super.initState();
    socketRepository.joinRoom(widget.id);
    fetchDocumentData();
    socketRepository.changeListner((data){
      _controller?.compose(Delta.fromJson(data['delta']),_controller?.selection?? const TextSelection.collapsed(offset: 0), ChangeSource.remote);
    });
    Timer.periodic(const Duration(seconds: 2), (timer){
      socketRepository.autoSave(<String,dynamic>{
      'delta': _controller!.document.toDelta(),
      'room': widget.id,
    }); 
    });
  }
  void fetchDocumentData() async{
     errorModel = await ref.read(DocumentRepositoryProvider).getDocumentById(ref.read(userProvider)!.token, widget.id);

     if(errorModel!.data!=null){
      _titleController.text = (errorModel!.data as DocumentModel).title;
      _controller = QuillController(document: errorModel!.data.content.isEmpty? Document():Document.fromDelta(Delta.fromJson(errorModel!.data.content)), selection: const TextSelection.collapsed(offset: 0));
      setState(() {
        
      });
     }
     _controller!.document.changes.listen((DocChange event) {
  // Check the source of the change.
  if (event.source == ChangeSource.local) {
    // Access the delta data directly from the event.
    Map<String, dynamic> map = {
      'delta': event.change, // Access `change` instead of `item2`.
      'room': widget.id,
    };
    socketRepository.typing(map);
  }
});


  }
  @override
  void dispose() {
    _titleController.dispose();
   
    super.dispose();
  }

  void updateTitle(WidgetRef ref, String title){
    ref.read(DocumentRepositoryProvider).updateTitle(token: ref.read(userProvider)!.token, id: widget.id, title: title);
  }

  @override
  Widget build(BuildContext context) {
    if(_controller==null){
      return const Scaffold(
        body: Loader(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: 'http://localhost:3000/#/document/${widget.id}')).then((value){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Link Copied')));
                });

              },
              icon: const Icon(Icons.lock, size: 16),
              label: const Text('Share'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kBlueColor,
                foregroundColor: kWhiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
        title: Row(
          children: [
            GestureDetector(
              onTap: (){
                Routemaster.of(context).replace('/');
              },
              child: Image.asset('assets/docslogo.png', height: 40)),
            const SizedBox(width: 10),
            SizedBox(
              width: 180,
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kBlueColor),
                  ),
                  contentPadding: EdgeInsets.only(left: 10),
                ),
                onSubmitted: (value)=> updateTitle(ref,value),
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: kGreyColor,
                width: 0.1,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
         QuillToolbar.simple(
         configurations: QuillSimpleToolbarConfigurations(controller: _controller!, sharedConfigurations: const QuillSharedConfigurations(locale: Locale('en')))
),
Expanded(
  child: SizedBox(
    width: 750,
    child: Card(
      shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(4), // Set border radius here
  ),
      color: kWhiteColor,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: QuillEditor.basic(
         configurations: QuillEditorConfigurations(controller: _controller!, sharedConfigurations: const QuillSharedConfigurations(locale: Locale('en'))),
        ),
      ),
    ),
  ),
)
        ],
      ),
    );
  }
}
