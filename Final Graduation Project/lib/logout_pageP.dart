//import 'package:account_gp/patient_page.dart';
import 'package:flutter/material.dart';

import 'patient_page.dart';


class LogoutPageP extends StatelessWidget {
  const LogoutPageP({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية من الـ Assets
          Positioned.fill(
            child: Image.asset(
              'images/background4.png', // مسار الصورة
              fit: BoxFit.cover, // لتغطية الشاشة بالكامل
            ),
          ),

          // المحتوى داخل الـ SafeArea لضمان أن المحتوى لا يتداخل مع الـ StatusBar أو الـ Notch
          SafeArea(
            child: Column(
              children: [
                // السهم للرجوع
                const SizedBox(height: 60), // المسافة العلوية
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
                      "Logout",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff44564A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 80), // مسافة إضافية بين العنوان والمحتوى التالي

                // محتوى صفحة تسجيل الخروج
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Are you sure you want to logout?',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff44564A),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'By logging out, you will no longer have access to the app until you sign in again.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 100),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // زر تسجيل الخروج
                          ElevatedButton(
                            onPressed: () {
                              // هنا تضيف منطق الخروج
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PatientPage(), // العودة للصفحة الرئيسية أو شاشة تسجيل الدخول
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff44564A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                            ),
                            child: const Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20), // مساحة بين الأزرار
                          // زر إلغاء الخروج
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // العودة إلى الصفحة السابقة
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
