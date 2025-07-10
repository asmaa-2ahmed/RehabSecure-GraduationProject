import 'package:account_gp/home_pageT.dart';
import 'package:account_gp/patient_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:account_gp/doctor_validation.dart'; // 🔹 Import your smart contract helper

class TherapistSignupPage extends StatefulWidget {
  const TherapistSignupPage({Key? key}) : super(key: key);

  @override
  _TherapistSignupPageState createState() => _TherapistSignupPageState();
}

class _TherapistSignupPageState extends State<TherapistSignupPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _licenseNumberController = TextEditingController();
  final TextEditingController _specializationController = TextEditingController();
  final TextEditingController _yearsOfExperienceController = TextEditingController();
  final TextEditingController _universityController = TextEditingController(); // 🔹 New controller

  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _licenseNumberController.dispose();
    _specializationController.dispose();
    _yearsOfExperienceController.dispose();
    _universityController.dispose(); // 🔹 dispose university controller
    super.dispose();
  }

  Future<bool> validateUniversityWithBlockchain(String universityName) async {
    DoctorValidation validator = DoctorValidation();
    return await validator.validateUniversity(universityName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/background2.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Color(0xff44564A),
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "THERAPIST SIGN UP",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff44564A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 110),

                      CustomTextField(
                        controller: _firstNameController,
                        labelText: "First Name",
                        validator: (value) => value == null || value.isEmpty ? 'Please enter your first name' : null,
                      ),
                      const SizedBox(height: 40),

                      CustomTextField(
                        controller: _lastNameController,
                        labelText: "Last Name",
                        validator: (value) => value == null || value.isEmpty ? 'Please enter your last name' : null,
                      ),
                      const SizedBox(height: 40),

                      CustomTextField(
                        controller: _emailController,
                        labelText: "Email",
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter your email';
                          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) return 'Enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),

                      CustomTextField(
                        controller: _passwordController,
                        labelText: "Password",
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter your password';
                          if (value.length < 6) return 'Password must be at least 6 characters';
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),

                      CustomTextField(
                        controller: _licenseNumberController,
                        labelText: "License Number",
                        validator: (value) => value == null || value.isEmpty ? 'Please enter your license number' : null,
                      ),
                      const SizedBox(height: 40),

                      CustomTextField(
                        controller: _specializationController,
                        labelText: "Specialization",
                        validator: (value) => value == null || value.isEmpty ? 'Please enter your specialization' : null,
                      ),
                      const SizedBox(height: 40),

                      CustomTextField(
                        controller: _yearsOfExperienceController,
                        labelText: "Years of Experience",
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty ? 'Please enter your years of experience' : null,
                      ),
                      const SizedBox(height: 40),

                      CustomTextField(
                        controller: _universityController,
                        labelText: "University Name",
                        validator: (value) => value == null || value.isEmpty ? 'Please enter your university' : null,
                      ),
                      const SizedBox(height: 40),

                      Center(
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => _isLoading = true);

                                    String university = _universityController.text.trim();
                                    bool isValid = await validateUniversityWithBlockchain(university);

                                    if (!isValid) {
                                      setState(() => _isLoading = false);
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: Text("Validation Failed"),
                                          content: Text("Your university is not approved."),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: Text("OK"),
                                            ),
                                          ],
                                        ),
                                      );
                                      return;
                                    }

                                    try {
                                      final email = _emailController.text.trim();
                                      final password = _passwordController.text.trim();

                                      UserCredential userCredential =
                                          await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                        email: email,
                                        password: password,
                                      );

                                      await FirebaseFirestore.instance
                                          .collection('therapists')
                                          .doc(userCredential.user?.uid)
                                          .set({
                                        'firstName': _firstNameController.text,
                                        'lastName': _lastNameController.text,
                                        'email': email,
                                        'licenseNumber': _licenseNumberController.text,
                                        'specialization': _specializationController.text,
                                        'yearsOfExperience': _yearsOfExperienceController.text,
                                        'university': university,
                                      });

                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PatientPage(),
                                        ),
                                      );
                                    } on FirebaseAuthException catch (e) {
                                      String errorMessage = 'An error occurred. Please try again.';
                                      if (e.code == 'email-already-in-use') {
                                        errorMessage = 'The email address is already in use.';
                                      }
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: Text('Error'),
                                          content: Text(errorMessage),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    } finally {
                                      setState(() => _isLoading = false);
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff44564A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                          ),
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  "SIGN UP",
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
          ),
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.controller,
    this.isPassword = false,
    this.validator,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: const Color(0xffE9EBEA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }
}