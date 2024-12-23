import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_app/block/auth_cubit.dart';
import 'package:social_network_app/screens/chat_screen.dart';
import 'package:social_network_app/screens/create_post_screen.dart';
import 'package:social_network_app/screens/post_screen.dart';
import 'package:social_network_app/screens/sign_in_screen.dart';
import 'package:social_network_app/screens/sign_up_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        theme: ThemeData.dark(),
        home: SignUpScreen(),
        routes: {
          SignInScreen.id: (context) => SignInScreen(),
          SignUpScreen.id: (context) => SignUpScreen(),
          PostsScreen.id: (context) => PostsScreen(),
          // CreatePostScreen.id: (context) => CreatePostScreen(),
          // ChatScreen.id: (context) => ChatScreen(),
        },
      ),
    );
  }
}
