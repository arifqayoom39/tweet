// ignore_for_file: empty_catches

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/auth/view/login_view.dart';
import 'package:twitter_clone/features/auth/widgets/auth_field.dart';
import 'package:twitter_clone/theme/theme.dart';

class SignUpView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignUpView(),
      );
  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void onSignUp() async {
    final email = emailController.text;
    final password = passwordController.text;


    try {
      ref.read(authControllerProvider.notifier).signUp(
            email: email,
            password: password,
            context: context,
          );
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      body: isLoading
          ? const Loader()
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Modern logo header with subtle animation
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Pallete.blueColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(75),
                        ),
                        // ignore: prefer_const_constructors
                        child: Center(
                          child: const Icon(
                            Icons.bolt_rounded,
                            color: Pallete.blueColor,
                            size: 70,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Modern welcome text
                      const Text(
                        'Join Tweet Clone!',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Create an account to start sharing your thoughts with the world.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Email field
                      AuthField(
                        controller: emailController,
                        hintText: 'Enter your email',
                        
                      ),
                      const SizedBox(height: 20),
                      // Password field
                      AuthField(
                        controller: passwordController,
                        hintText: 'Create a password',
                        
                      
                      ),
                      const SizedBox(height: 40),
                      // Sign Up button with modern design
                      GestureDetector(
                        onTap: onSignUp,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 28),
                          decoration: BoxDecoration(
                            color: Pallete.blueColor,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Pallete.blueColor.withOpacity(0.5),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Text(
                            'Sign Up',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Login prompt
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: "Already have an account?",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                            children: [
                              TextSpan(
                                text: ' Login',
                                style: const TextStyle(
                                  color: Pallete.blueColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      LoginView.route(),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
