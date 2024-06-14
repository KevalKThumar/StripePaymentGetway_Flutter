import 'package:prectical_exam/auth_provider.dart';
import 'package:prectical_exam/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign In',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sign In.',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              AuthField(
                hintText: 'Email',
                controller: emailController,
                focusNode: emailFocusNode,
                nextFocus: passwordFocusNode,
                prefixIcon: const Icon(
                  Icons.email,
                  color: Colors.black,
                ),
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),
              AuthField(
                hintText: 'Password',
                controller: passwordController,
                isObscureText: true,
                focusNode: passwordFocusNode,
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Colors.black,
                ),
                textInputType: TextInputType.visiblePassword,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      context.read<FirebaseAuthMethods>().loginWithEmail(
                            email: emailController.text,
                            password: passwordController.text,
                            context: context,
                          );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Already have an account

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
