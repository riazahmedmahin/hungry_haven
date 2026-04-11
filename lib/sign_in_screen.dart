import 'package:flutter/material.dart';
import 'forget_password.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Hello Again !',
                        style:
                            TextStyle(fontSize: 38, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Welcome back Login to Continue',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                      const SizedBox(height: 24),

                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildField(
                              hint: 'Email',
                              icon: Icons.email_outlined,
                            ),
                            const SizedBox(height: 12),
                            _buildField(
                              hint: 'Password',
                              icon: Icons.lock_outline,
                              obscure: true,
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) => const ForgetPassword()),
                                  );
                                },
                                child: Text(
                                  'Forget Password',
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () {
                                  // validate and then navigate to Home
                                  Navigator.of(context).pushReplacementNamed('/home');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1976D2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Login',style: TextStyle(color: Colors.white),),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                    child: Divider(color: Colors.grey.shade300)),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text('or'),
                                ),
                                Expanded(
                                    child: Divider(color: Colors.grey.shade300)),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _socialBox(
                                    'https://cdn-icons-png.flaticon.com/128/281/281764.png'),
                                const SizedBox(width: 12),
                                _socialBox(
                                    'https://cdn-icons-png.flaticon.com/128/0/747.png'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Don’t have an account? ',
                              style: TextStyle(color: Colors.grey.shade600)),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => const SignUpScreen()));
                            },
                            child: const Text('Register',
                                style: TextStyle(
                                    color: Color(0xFF1976D2),
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildField(
      {required String hint, required IconData icon, bool obscure = false}) {
    return TextFormField(
      obscureText: obscure ? _obscurePassword : false,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF1F5F6),
        prefixIcon: Icon(icon, color: Colors.grey.shade600),
        hintText: hint,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        suffixIcon: obscure
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey.shade600,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : null,
      ),
    );
  }

  Widget _socialBox(String url) {
    return Container(
      height: 56,
      width: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Image.network(url, fit: BoxFit.contain),
      ),
    );
  }
}
