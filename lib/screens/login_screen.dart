import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/services/api_service.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  final ApiService apiService;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({required this.apiService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 100, color: Colors.blue),
             // SizedBox(height: 20),
            //  TextField(
             //   controller: usernameController,
             //   decoration: InputDecoration(
             //     labelText: "name",
             //     prefixIcon: Icon(Icons.person),
             //     border: OutlineInputBorder(
             //       borderRadius: BorderRadius.circular(10),
              //    ),
             //   ),
            //  ),
              SizedBox(height: 15),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: "user name",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "password",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("✅ تسجيل الدخول ناجح!")),
                    );
                    // ✅ الانتقال إلى الشاشة الرئيسية بعد تسجيل الدخول الناجح
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("❌ خطأ: ${state.error}")),
                    );
                  }
                },
                builder: (context, state) {
                  return state is AuthLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(context).add(
                        LoginRequested(
                          username: usernameController.text.trim(),
                          password: passwordController.text.trim(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("تسجيل الدخول", style: TextStyle(fontSize: 18)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
