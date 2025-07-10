import 'package:flutter/material.dart';

class PrivacyPageT extends StatelessWidget {
  const PrivacyPageT({super.key});

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
            child: Padding(
              padding: const EdgeInsets.all(16.0), // إضافة padding لراحة التوزيع
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        "Privacy Policy",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff44564A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50), // مسافة إضافية بين العنوان والمحتوى التالي

                  // محتوى صفحة سياسة الخصوصية
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            'Last Updated: December 2024',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'At [Your App Name], we respect your privacy and are committed to protecting the personal information you share with us. This Privacy Policy explains how we collect, use, and protect your data.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            '1. Information Collection',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff44564A),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'We may collect personal information such as your name, email address, license number, specialization, and other professional details when you use our services as a therapist. This information is used solely for the purpose of providing better services and improving your experience with the app.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            '2. Data Security',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff44564A),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'We take data security seriously and implement measures to safeguard your information. However, no method of data transmission over the internet is 100% secure, so we cannot guarantee absolute security.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            '3. Sharing Your Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff44564A),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'We do not share your personal information with third parties unless required by law or with your explicit consent.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            '4. Changes to This Privacy Policy',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff44564A),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'We may update this Privacy Policy from time to time. We encourage you to review this page periodically to stay informed about our privacy practices.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context); // العودة إلى الصفحة السابقة
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff44564A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                              ),
                              child: const Text(
                                'Back to Settings',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
