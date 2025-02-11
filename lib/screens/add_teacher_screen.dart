/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';
import '../services/api_service.dart';

class AddTeacherScreen extends StatefulWidget {
  final ApiService apiService;
  const AddTeacherScreen({Key? key, required this.apiService}) : super(key: key);

  @override
  _AddTeacherScreenState createState() => _AddTeacherScreenState();
}

class _AddTeacherScreenState extends State<AddTeacherScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إضافة معلم جديد")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // الاسم
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "الاسم",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 15),

              // اسم المستخدم
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: "اسم المستخدم",
                  prefixIcon: Icon(Icons.account_circle),
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
              const SizedBox(height: 20),

              // زر الإضافة
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("تم إضافة المعلم بنجاح!")),
                    );
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
                      if (nameController.text.isEmpty || usernameController.text.isEmpty || passwordController.text.length < 8) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("❌ يرجى ملء جميع الحقول وكلمة المرور يجب أن تكون على الأقل 8 أحرف")),
                        );
                        return; // ❌ لا يتم تنفيذ باقي الكود إذا كان هناك خطأ
                      }

                      BlocProvider.of<AuthBloc>(context).add(
                        AddTeacherRequested(
                          name: nameController.text,
                          username: usernameController.text,
                          password: passwordController.text,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("إضافة معلم", style: TextStyle(fontSize: 18)),
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