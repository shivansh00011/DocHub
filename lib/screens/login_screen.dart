import 'package:gdocs/colors.dart';
import 'package:gdocs/models/user_model.dart';
import 'package:gdocs/repository/auth_repository.dart';
import 'package:gdocs/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gdocs/colors.dart';
import 'package:routemaster/routemaster.dart';


class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

 void signInWithGoogle(WidgetRef ref, BuildContext context) async {
  final sMessenger = ScaffoldMessenger.of(context);
  
  final errorModel = await ref.read(authRepositoryProvider).signInWithGoogle();
  final navigator = Routemaster.of(context);

  // Log the error model data
  print('ErrorModel: ${errorModel.error}');
  print('ErrorModel Data: ${errorModel.data}');

  if (errorModel.error == null) {
    ref.read(userProvider.notifier).update((state) => errorModel.data);
    print('Updating userProvider with ID: ${errorModel.data?.id}'); // Log the ID
    navigator.replace('/'); // Navigate to the home screenf
  } else {
    sMessenger.showSnackBar(
      SnackBar(
        content: Text(errorModel.error!),
      ),
    );
  }
}



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => signInWithGoogle(ref, context), // Trigger sign-in
          icon: Image.asset(
            'assets/glogo.png', // Ensure this asset exists
            height: 20,
          ),
          label: const Text(
            'Sign in with Google',
            style: TextStyle(
              color: kBlackColor, // Customize text color
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: kWhiteColor, // Customize button background color
            minimumSize: const Size(150, 50), // Set minimum button size
          ),
        ),
      ),
    );
  }
}
