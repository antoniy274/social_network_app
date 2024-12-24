import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_app/block/auth_cubit.dart';
import 'package:social_network_app/screens/post_screen.dart';
import 'package:social_network_app/screens/sign_in_screen.dart';


class SignUpScreen extends StatefulWidget {

  static const String id = "sign up screen";


  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _username = "";
  String _password = "";

  late final FocusNode _passwordFocusNode;
  late final FocusNode _usernameFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    _usernameFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _usernameFocusNode.dispose();
    super.dispose();
  }

  void _submit(BuildContext context){
    FocusScope.of(context).unfocus();

    if(!_formKey.currentState!.validate()){
      //Invalid
      print("1");
      return;
    }
    print("2");
    _formKey.currentState!.save();
    context.read<AuthCubit>().signUp(email: _email, username: _username, password: _password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
          listener: (prevState, currState){
            if(currState is AuthSignedUp){
              Navigator.of(context).pushReplacementNamed(PostsScreen.id);
            }
            if(currState is AuthFailure){
              ScaffoldMessenger.of(context).showSnackBar(

                  SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text(currState.messege)));
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
                              FocusScope.of(context).requestFocus(_usernameFocusNode);
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
                          // username
                          SizedBox(height: 15,),
                          TextFormField(
                            focusNode: _usernameFocusNode,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              labelText: "Enter you username",
                            ),
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_){
                              FocusScope.of(context).requestFocus(_passwordFocusNode);
                            },
                            onSaved: (value){
                              _username = value!.trim();
                            },
                            validator: (value){
                              if(value!.isEmpty){
                                return "Please enter your username";
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
                              child: Text("Sign Up")
                          ),
                          TextButton(onPressed: (){
                            Navigator.of(context).pushReplacementNamed(SignInScreen.id);
                          },
                              child: Text("Log In")
                            //Sign In instead
                          )
                        ],
                      ),
                    ),
                  ),
                )
            );
          }
      ),
    );
  }
}
