
import 'package:flutter/material.dart';
import 'profile_pageP.dart'; // تأكد من استيراد الصفحات المناسبة
import 'passwordmanager_pageP.dart';
import 'privacy_pageP.dart';
import 'logout_pageP.dart';
//import 'home_pageP.dart';

class SettingsPageP extends StatelessWidget {
  const SettingsPageP({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/background3.png'), // ضع المسار الصحيح للخلفية
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // السهم مع العنوان
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context); // للعودة إلى صفحة تسجيل الدخول
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xff44564A),
                        ),
                      ),
                      const Text(
                        "Settings",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff44564A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // الخيارات
                  Expanded(
                    child: ListView(
                      children: [
                        _buildSettingOption(
                          context,
                          title: "Profile",
                          onTap: () {
                            // الانتقال إلى صفحة Profile
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  ProfilePageP(),
                              ),
                            );
                          },
                        ),
                        const Divider(color: Colors.grey),
                        _buildSettingOption(
                          context,
                          title: "Password Manager",
                          onTap: () {
                            // الانتقال إلى صفحة Password Manager
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PasswordManagerPageP(),
                              ),
                            );
                          },
                        ),
                        const Divider(color: Colors.grey),
                        _buildSettingOption(
                          context,
                          title: "Privacy",
                          onTap: () {
                            // الانتقال إلى صفحة Privacy
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PrivacyPageP(),
                              ),
                            );
                          },
                        ),
                        const Divider(color: Colors.grey),
                        _buildSettingOption(
                          context,
                          title: "Logout",
                          onTap: () {
                            // الانتقال إلى صفحة Logout
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LogoutPageP(),
                              ),
                            );
                          },
                        ),
                        const Divider(color: Colors.grey),
                      ],
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

  // عنصر فردي لعرض خيار الإعدادات
  Widget _buildSettingOption(BuildContext context,
      {required String title, required VoidCallback onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          color: Color(0xff44564A),
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Color(0xff44564A),
        size: 20,
      ),
      onTap: onTap,
    );
  }
}
