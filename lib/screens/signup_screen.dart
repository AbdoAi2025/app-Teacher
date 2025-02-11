/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/screens/login_screen.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';
import '../services/api_service.dart';

class SignUpScreen extends StatefulWidget {
  final ApiService apiService;
  const SignUpScreen({Key? key, required this.apiService}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController roleIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إنشاء حساب جديد")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // اسم المستخدم
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: "اسم المستخدم",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 15),

              // البريد الإلكتروني
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "البريد الإلكتروني",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 15),

              // كلمة المرور
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "كلمة المرور",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 15),

              // Role ID (مثلاً 1073741824)
              TextField(
                controller: roleIdController,
                decoration: InputDecoration(
                  labelText: "رقم الدور (Role ID)",
                  prefixIcon: Icon(Icons.admin_panel_settings),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // زر إنشاء الحساب
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("تم إنشاء الحساب بنجاح!")),
                    );

                    // ✅ الانتقال إلى الشاشة الرئيسية بعد تسجيل الدخول الناجح
                   // Navigator.pushReplacement(
                    //  context,
                   //   MaterialPageRoute(builder: (context) =>  LoginScreen(apiService: apiService)),
                  //  );

                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("خطأ: ${state.error}")),
                    );
                  }
                },
                builder: (context, state) {
                  return state is AuthLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: () {


                      // ✅ التحقق من أن جميع الحقول ممتلئة وكلمة المرور صحيحة
                      if ( emailController.text.isEmpty||emailController.text.isEmpty||usernameController.text.isEmpty || passwordController.text.length < 8) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("❌ يرجى ملء جميع الحقول وكلمة المرور يجب أن تكون على الأقل 8 أحرف")),
                        );
                        return; // ❌ لا يتم تنفيذ باقي الكود إذا كان هناك خطأ
                      }


                      BlocProvider.of<AuthBloc>(context).add(
                        SignUpRequested(
                          username: usernameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                          roleId: int.tryParse(roleIdController.text) ?? 1073741824,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("إنشاء حساب", style: TextStyle(fontSize: 18)),
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
*/