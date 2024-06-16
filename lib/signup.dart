import 'package:prectical_exam/auth_provider.dart';
import 'package:prectical_exam/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up',
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
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sign Up.',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                AuthField(
                  hintText: 'Name',
                  controller: nameController,
                  focusNode: nameFocusNode,
                  nextFocus: emailFocusNode,
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  textInputType: TextInputType.name,
                ),
                const SizedBox(height: 15),
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
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<FirebaseAuthMethods>().signUpWithEmail(
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
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign In',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
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
        ),
      )),
    );
  }
}

class AuthField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;
  final Icon prefixIcon;
  final FocusNode focusNode;
  final FocusNode? nextFocus;
  final TextInputType textInputType;
  const AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
    required this.prefixIcon,
    required this.focusNode,
    this.nextFocus,
    required this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText,
        label: Text(hintText),
        prefixIcon: prefixIcon,
        labelStyle: const TextStyle(color: Colors.black, fontSize: 18),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
        focusColor: Colors.black,
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
      ),
      style: const TextStyle(color: Colors.black, fontSize: 18),
      validator: (value) {
        if (value!.isEmpty) {
          return "$hintText is missing!";
        }
        return null;
      },
      obscureText: isObscureText,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        }
      },
    );
  }
}
