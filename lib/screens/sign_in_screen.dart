import 'package:flutter/material.dart';
import 'package:social_network_app/block/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_app/screens/post_screen.dart';
import 'package:social_network_app/screens/sign_up_screen.dart';

class SignInScreen extends StatefulWidget {

  static const String id = "sign in screen";

  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";

  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submit(BuildContext context){
    FocusScope.of(context).unfocus();

    if(!_formKey.currentState!.validate()){
      //Invalid
      return;
    }
    _formKey.currentState!.save();
    context.read<AuthCubit>().signIn(email: _email, password: _password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (prevState, currentState){
          if(currentState is AuthSignedIn){
            Navigator.of(context).pushReplacementNamed(PostsScreen.id);
          }
          if(currentState is AuthFailure){
            ScaffoldMessenger.of(context).showSnackBar(

                SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text(currentState.messege)));
          }

        },
        builder: (context, state){
          if(state is AuthLoading){
            return Center(child: CircularProgressIndicator());
          }
          return SafeArea(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18.0),
                          child: Text("Social Media App", style: Theme.of(context).textTheme.headlineLarge,),
                        ),
                        SizedBox(height: 15,),
                        // email
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: "Enter you emaail",
                          ),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_){
                            FocusScope.of(context).requestFocus(_passwordFocusNode);
                          },
                          onSaved: (value){
                            _email = value!.trim();
                          },
                          validator: (value){
                            if(value!.isEmpty){
                              return "Please enter your email";
                            }
                            return null;
                          },
                        ),
                        // password
                        SizedBox(height: 15,),
                        TextFormField(
                          focusNode: _passwordFocusNode,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: "Enter you password",
                          ),
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_){
                            _submit(context);
                          },
                          onSaved: (value){
                            _password = value!.trim();
                          },
                          validator: (value){
                            if(value!.isEmpty){
                              return "Please enter your password";
                            }
                            if(value.length < 5){
                              return "Please enter your password more than 5 characters";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 15,),
                        TextButton(onPressed: (){
                          _submit(context);
                        },
                            child: Text("Sign In")
                        ),
                        TextButton(onPressed: (){
                          Navigator.of(context).pushReplacementNamed(SignUpScreen.id);
                        },
                            child: Text("Sign Up instead")
                        )
                      ],
                    ),
                  ),
                ),
              )
          );
        },
      ),
    );
  }
}
