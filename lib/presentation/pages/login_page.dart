import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubuzima_connect/core/theme.dart';
import 'package:ubuzima_connect/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:ubuzima_connect/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:ubuzima_connect/presentation/blocs/auth_bloc/auth_state.dart';
import 'package:ubuzima_connect/presentation/pages/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignIn() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(AuthSignInEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E0D8),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.errorColor,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),

                  // Title
                  const Center(
                    child: Text(
                      'UbuzimaConnect',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Hero image from network
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1531983412531-1f49a365ffed?w=800&fit=crop',
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 220,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 220,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.image_outlined,
                            size: 60,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Welcome text
                  const Center(
                    child: Text(
                      'Murakaza neza!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Email label
                  const Text(
                    'Email Address',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Email input
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'user@example.com',
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: Colors.grey,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFF2E7D32),
                          width: 1.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                          .hasMatch(value.trim())) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Password label
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Password input
                  TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    obscureText: _obscurePassword,
                    onFieldSubmitted: (_) => _onSignIn(),
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(
                        Icons.lock_outlined,
                        color: Colors.grey,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFF2E7D32),
                          width: 1.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 28),

                  // LOGIN button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoadingState;
                      return SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _onSignIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            disabledBackgroundColor:
                                const Color(0xFF2E7D32).withValues(alpha: 0.6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'LOGIN / Injira',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Forgot Password link
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Implement forgot password
                        print('Forgot password tapped');
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Color(0xFF2E7D32),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // OR divider
                  const Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey)),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Google Sign-In Button
                  SizedBox(
                    height: 54,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context
                            .read<AuthBloc>()
                            .add(AuthSignInWithGoogleEvent());
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFFDDDDDD),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Text(
                        '🔵',
                        style: TextStyle(fontSize: 20),
                      ),
                      label: const Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Sign Up link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Color(0xFF2E7D32),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Help section
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'Need help? / Ukeneye ubufasha?',
                          style: TextStyle(
                            color: Color(0xFF555555),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () {
                            // Launch dialer for 114
                          },
                          child: const Text(
                            'Call 114',
                            style: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
