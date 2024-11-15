import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gdocs/models/error_model.dart';
import 'package:gdocs/repository/auth_repository.dart';
import 'package:gdocs/router.dart';
import 'package:gdocs/screens/home_screen.dart';
import 'package:gdocs/screens/login_screen.dart';
import 'package:routemaster/routemaster.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  ErrorModel? errorModel;
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    errorModel = await ref.read(authRepositoryProvider).getUserData();
    print("ErrorModel: $errorModel");
    print("ErrorModel data: ${errorModel?.data}");

    if (errorModel != null && errorModel!.data != null) {
      ref.read(userProvider.notifier).update((state) => errorModel!.data);
      print("User updated in provider: ${errorModel!.data}");
    } else {
      print("No user data found, showing login screen");
    }

    setState(() {
      isLoading = false; // Update loading state after completing fetch
    });
  }

  @override
  Widget build(BuildContext context) {
   
  

    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerDelegate: RoutemasterDelegate(routesBuilder: (context){
         final user = ref.watch(userProvider);
         if(user!=null && user.token.isNotEmpty){
            return loggedInRoute;
         }
         return loggedOutRoute;

      }),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}
