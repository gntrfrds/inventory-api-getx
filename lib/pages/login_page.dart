import 'package:flutter/material.dart';
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() =>
      _LoginPageState();
}

class _LoginPageState
    extends State<LoginPage> {
  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool isLoading = false;

  void login() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(
      const Duration(
        seconds: 1,
      ),
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const DashboardPage(),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(24),

          child: ConstrainedBox(
            constraints:
                const BoxConstraints(
              maxWidth: 400,
            ),

            child: Column(
              children: [
                const Icon(
                  Icons.inventory_2,
                  size: 80,
                ),

                const SizedBox(
                  height: 20,
                ),

                const Text(
                  'Inventory API App',

                  style: TextStyle(
                    fontSize: 26,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                TextField(
                  controller:
                      emailController,

                  keyboardType:
                      TextInputType.emailAddress,

                  decoration:
                      const InputDecoration(
                    labelText: 'Email',

                    border:
                        OutlineInputBorder(),

                    prefixIcon: Icon(
                      Icons.email,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),

                TextField(
                  controller:
                      passwordController,

                  obscureText: true,

                  decoration:
                      const InputDecoration(
                    labelText:
                        'Password',

                    border:
                        OutlineInputBorder(),

                    prefixIcon: Icon(
                      Icons.lock,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                SizedBox(
                  width: double.infinity,

                  height: 50,

                  child:
                      ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : login,

                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Login',
                          ),
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