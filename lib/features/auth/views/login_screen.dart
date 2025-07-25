import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/insets.dart';
import '../../../core/utils/svg_icon.dart';
import '../providers/auth.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextTheme textTheme = Theme.of(context).textTheme;
    final authenticationProvider = ref.watch(authProvider.notifier);

    return Scaffold(
      body: Center(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(Insets.extraLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Sign In',
                  textAlign: TextAlign.center,
                  style: textTheme.headlineMedium,
                ),
                const SizedBox(height: Insets.extraLarge),
                Text('Email'),
                TextFormField(
                  autocorrect: false,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'example@email.com',
                  ),
                  validator: _emailValidator,
                ),
                const SizedBox(height: Insets.medium),
                Text('Password'),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your password',
                    suffixIcon: Icon(Icons.visibility_off),
                  ),
                  obscureText: true,
                  validator: _passwordValidator,
                ),
                Text(
                  'Forgot Password?',
                  textAlign: TextAlign.end,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.englishLavender,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.englishLavender,
                  ),
                ),
                const SizedBox(height: Insets.extraLarge),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );

                      await authenticationProvider.signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                    }
                  },
                  child: const Text('Sign In'),
                ),
                const SizedBox(height: Insets.extraLarge),
                Text('Or sign in with', textAlign: TextAlign.center),
                const SizedBox(height: Insets.large),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const SvgIcon(path: 'assets/icons/google_logo.svg'),
                      onPressed: () {
                        // Handle Google sign-in
                      },
                    ),
                    IconButton(
                      icon: const SvgIcon(
                        path: 'assets/icons/instagram_logo.svg',
                      ),
                      onPressed: () {
                        // Handle Instagram sign-in
                      },
                    ),
                    IconButton(
                      icon: const SvgIcon(
                        path: 'assets/icons/facebook_logo.svg',
                      ),
                      onPressed: () {
                        // Handle Facebook sign-in
                      },
                    ),
                  ],
                ),
                const SizedBox(height: Insets.extraLarge),
                Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    text: 'Don\'t have an account? ',
                    children: [
                      TextSpan(
                        text: 'Sign Up',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.englishLavender,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.englishLavender,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                context.pushNamed(Routes.createAccount.name);
                              },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
