import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/screens/home_screen.dart';
import 'package:notes/screens/signup_screen.dart';

import '../repository/userauthrepository.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState()  {
    UserAuthRepository userAuthRepository=UserAuthRepository();
    User? user= userAuthRepository.getCurrentUser();
    // userAuthRepository.signOut();
    if(user!=null)
    {
      WidgetsBinding.instance.addPostFrameCallback((_){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NotesScreen(),), (route) => false);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;
      UserAuthRepository userAuthRepository=UserAuthRepository();
      try {
        User? user = await userAuthRepository.signInWithEmailAndPassword(
            email, password);
        if (user != null) {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => NotesScreen(),), (
                  route) => false);
        }
      }
      catch(e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height=MediaQuery.sizeOf(context).height;
    final width=MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Container(
                height: height*0.62,
                width: width*0.9,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(35)
                  ,color: Color.fromRGBO(170,213,219,0.3),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
const Text('Sign in',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 35,color: Colors.teal),),
                      SizedBox(height: 30),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(

                          hintText: 'Email',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          prefixIcon: Icon(Icons.person, color: Colors.teal),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(color: Colors.teal),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                              // fontWeight: FontWeight.bold,
                              // backgroundColor: Colors.red[400],
                              color: Colors.red[900]
                          ),
                          hintText: 'Password',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          prefixIcon: Icon(Icons.lock, color: Colors.teal),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(color: Colors.teal),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: height*0.06,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            primary: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Log in',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                       const Text(
                          'Don\' have an account?',
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignupPage(),));
                          },
                          child: Text(
                            'Signup',
                          ),
                        ),
                      ],)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
