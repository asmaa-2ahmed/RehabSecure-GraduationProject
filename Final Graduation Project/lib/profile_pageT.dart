import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePageT extends StatefulWidget {
  const ProfilePageT({Key? key}) : super(key: key);

  @override
  _ProfilePageTState createState() => _ProfilePageTState();
}

class _ProfilePageTState extends State<ProfilePageT> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final genderController = TextEditingController();
  final dobController = TextEditingController();
  final licenseController = TextEditingController();
  final specializationController = TextEditingController();
  final experienceController = TextEditingController();

  bool isLoading = true; // حالة التحميل حتى يتم جلب البيانات

  // جلب بيانات الـ Therapist من Firestore
  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('therapists')  // تغيير الـ Collection إلى 'therapists'
          .doc(user.uid)  // استخدام الـ UID الخاص بالـ Therapist
          .get();
      final data = doc.data();
      if (data != null) {
        setState(() {
          // تعبئة الـ TextEditingControllers بالبيانات المسترجعة
          firstNameController.text = data['firstName'] ?? '';
          lastNameController.text = data['lastName'] ?? '';
          emailController.text = data['email'] ?? '';
          genderController.text = data['gender'] ?? '';
          dobController.text = data['dob'] ?? '';
          licenseController.text = data['licenseNumber'] ?? '';
          specializationController.text = data['specialization'] ?? '';
          experienceController.text = data['experience'] ?? '';
          isLoading = false; // تغيير حالة التحميل بعد إتمام الجلب
        });
      } else {
        setState(() {
          isLoading = false; // إذا لم يتم العثور على بيانات
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No data found for this therapist.'),
        ));
      }
    }
  }

  // تحديث بيانات الـ Therapist في Firestore
  Future<void> _updateUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('therapists').doc(user.uid).update({
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'email': emailController.text,
        'gender': genderController.text,
        'dob': dobController.text,
        'licenseNumber': licenseController.text,
        'specialization': specializationController.text,
        'experience': experienceController.text,
      });
      _showSuccessDialog();
    }
  }

  // عرض رسالة نجاح عند تحديث البيانات
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Your profile has been updated successfully.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // جلب بيانات الـ Therapist عند تحميل الصفحة
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // عرض دائرة التحميل
          : Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'images/background4.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                "Profile",
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff44564A),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 120),
                          _buildTextField(
                            controller: firstNameController,
                            label: "First Name",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: lastNameController,
                            label: "Last Name",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: emailController,
                            label: "Email",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: genderController,
                            label: "Gender",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your gender';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: dobController,
                            label: "Date of Birth",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your date of birth';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: licenseController,
                            label: "License Number",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your license number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: specializationController,
                            label: "Specialization",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your specialization';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: experienceController,
                            label: "Years of Experience",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your years of experience';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 60),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState != null &&
                                    _formKey.currentState!.validate()) {
                                  _updateUserData(); // تحديث البيانات
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
                                "Update Profile",
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
                ),
              ],
            ),
    );
  }

  // دالة لإنشاء TextFormField
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xff44564A),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }
}

