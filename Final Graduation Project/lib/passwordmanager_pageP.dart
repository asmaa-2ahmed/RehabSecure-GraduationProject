import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordManagerPageP extends StatefulWidget {
  const PasswordManagerPageP({super.key});

  @override
  _PasswordManagerPageState createState() => _PasswordManagerPageState();
}

class _PasswordManagerPageState extends State<PasswordManagerPageP> {
  final _formKey = GlobalKey<FormState>(); // المفتاح للتحقق من صحة المدخلات
  final currentPasswordController = TextEditingController(); // حقل كلمة المرور الحالية
  final newPasswordController = TextEditingController(); // حقل كلمة المرور الجديدة
  final confirmPasswordController = TextEditingController(); // حقل تأكيد كلمة المرور الجديدة

  // دالة لعرض رسائل الخطأ
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // دالة لعرض رسالة النجاح
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Your password has been updated successfully.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context); // العودة للصفحة السابقة بعد التحديث
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية من الـ Assets
          Positioned.fill(
            child: Image.asset(
              'images/background4.png', // استبدل بمسار الصورة
              fit: BoxFit.cover, // لتغطية الشاشة بالكامل
            ),
          ),

          // المحتوى داخل الـ SafeArea لضمان أن المحتوى لا يتداخل مع الـ StatusBar أو الـ Notch
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey, // ربط النموذج بالمفتاح للتحقق من المدخلات
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60), // المسافة العلوية

                    // السهم للرجوع
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context); // للرجوع إلى الصفحة السابقة
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xff44564A),
                          ),
                        ),
                        const Text(
                          "Password Manager",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff44564A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 80), // المسافة بعد العنوان

                    // حقل كلمة المرور الحالية
                    _buildTextField(
                      controller: currentPasswordController,
                      label: "Current Password",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your current password'; // التحقق من المدخل
                        }
                        return null;
                      },
                      obscureText: true, // لإخفاء النص في كلمة المرور
                    ),

                    // حقل كلمة المرور الجديدة
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: newPasswordController,
                      label: "New Password",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your new password'; // التحقق من المدخل
                        }
                        return null;
                      },
                      obscureText: true, // لإخفاء النص في كلمة المرور
                    ),

                    // حقل تأكيد كلمة المرور
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: confirmPasswordController,
                      label: "Confirm Password",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your new password'; // رسالة الخطأ إذا كان الحقل فارغًا
                        }
                        if (value != newPasswordController.text) {
                          return 'Passwords do not match'; // التحقق من تطابق كلمتي المرور
                        }
                        return null;
                      },
                      obscureText: true, // لإخفاء النص في كلمة المرور
                    ),

                    const SizedBox(height: 40), // المسافة قبل الزر

                    // زر تحديث كلمة المرور
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState != null &&
                              _formKey.currentState!.validate()) {
                            // تحقق من كلمة المرور الحالية مع Firebase
                            try {
                              final user = FirebaseAuth.instance.currentUser;
                              final credential = EmailAuthProvider.credential(
                                email: user!.email!,
                                password: currentPasswordController.text,
                              );

                              // التحقق من كلمة المرور الحالية
                              await user.reauthenticateWithCredential(credential);

                              // تحديث كلمة المرور الجديدة
                              await user.updatePassword(newPasswordController.text);

                              // عرض رسالة النجاح
                              _showSuccessDialog(context);
                            } on FirebaseAuthException catch (e) {
                              // التعامل مع الأخطاء
                              if (e.code == 'wrong-password') {
                                _showErrorDialog(context, 'Wrong current password');
                              } else {
                                _showErrorDialog(context, 'Error updating password');
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff44564A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 70, vertical: 15),
                        ),
                        child: const Text(
                          "Update Password",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(), // المسافة لتوسيع النص
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // دالة لإنشاء الحقول
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xff44564A),
        ),
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }
}
