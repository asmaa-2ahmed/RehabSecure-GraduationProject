//import 'dart:math';
//import 'package:mailer/mailer.dart';
//import 'package:mailer/smtp_server.dart';

//import 'package:mailer/smtp_server/gmail.dart';
//import 'package:flutter_email_sender/flutter_email_sender.dart';

//incrypted###########################################################################
//import 'dart:convert';
//import 'package:encrypt/encrypt.dart' as encrypt; // Prefixed 'encrypt' for clarity
//incrypted###########################################################################

import 'package:account_gp/home_pageP.dart';
import 'package:account_gp/home_pageT.dart';
import 'package:account_gp/therapist_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PatientPage extends StatefulWidget {
  @override
  _PatientPageState createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      // تسجيل الدخول عبر Firebase
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      // التحقق مما إذا كان المستخدم معالجًا أم مريضًا
      bool isTherapist = await _checkIfTherapist(uid);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                isTherapist ? HomePageT() : HomePageP(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e);
    } catch (e) {
      print('Unexpected error: $e');
      _showErrorDialog(FirebaseAuthException(
          code: 'unknown-error', message: 'An unexpected error occurred.'));
    }
  }

  Future<bool> _checkIfTherapist(String uid) async {
    try {
      // البحث في مجموعة المعالجين أولًا
      DocumentSnapshot therapistDoc = await FirebaseFirestore.instance
          .collection('therapists')
          .doc(uid)
          .get();

      if (therapistDoc.exists) {
        return true; // هو معالج
      }

      // البحث في مجموعة المرضى
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      return userDoc.exists; // إذا وُجد هنا، فهو مريض
    } catch (e) {
      print('Error checking if therapist: $e');
      return false; // لو حصل خطأ هنرجع false عشان مش هنقدر نكمل
    }
  }

  void _showErrorDialog(FirebaseAuthException e) {
    String errorMessage = 'An unknown error occurred. Please try again.';

    // نعرض أخطاء Firebase بشكل أوضح
    if (e.code == 'user-not-found') {
      errorMessage = 'No user found for that email.';
    } else if (e.code == 'wrong-password') {
      errorMessage = 'Wrong password provided.';
    } else {
      errorMessage = e.message ?? 'An unexpected error occurred.';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
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
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/background2.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  const Text(
                    "LOGIN",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff44564A),
                    ),
                  ),
                  const SizedBox(height: 150),
                  _buildTextField(
                    controller: emailController,
                    label: "Email",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: passwordController,
                    label: "Password",
                    obscureText: true,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        // انتقل لصفحة نسيان كلمة المرور
                      },
                      child: const Text(
                        "Forget password?",
                        style: TextStyle(
                          color: Color(0xff44564A),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 70),
                  Center(
                    child: ElevatedButton(
                      onPressed: _loginUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff44564A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 70, vertical: 15),
                      ),
                      child: const Text(
                        "LOGIN",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff44564A),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PatientOrTherapistPage(), // ضع اسم صفحة التسجيل هنا
                              ),
                            );
                          },
                          child: const Text(
                            "SIGNUP",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff44564A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(labelText: label),
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter $label' : null,
    );
  }
}

class PatientOrTherapistPage extends StatelessWidget {
  const PatientOrTherapistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/backgroundhello.png'), // مسار الصورة
              fit: BoxFit.cover, // لجعل الصورة تغطي الشاشة بالكامل
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // زر الرجوع
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back,
                          size: 30, color: Color(0xff44564A)),
                      onPressed: () {
                        Navigator.pop(context); // الرجوع للصفحة السابقة
                      },
                    ),
                  ),
                ),

                // باقي العناصر داخل Column
                Column(
                  children: [
                    SizedBox(height: 160),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Please Select your user type to continue',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 30,
                          fontWeight: FontWeight.normal,
                          color: Color(0xff44564A),
                        ),
                      ),
                    ),
                    SizedBox(height: 200),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          // التنقل إلى صفحة تسجيل المرضى
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff44564A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                        ),
                        child: Text(
                          'Patient',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      child: ElevatedButton(
                        onPressed: () {
                          // التنقل إلى صفحة تسجيل المعالجين
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const TherapistSignupPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff44564A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                        ),
                        child: Text(
                          'Therapist',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// صفحة التسجيل

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  // تحديد الـ controllers لجميع الحقول
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  String? _selectedGender;
  bool _isLoading = false; // لتخزين حالة التحميل

  @override
  void dispose() {
    // تأكد من التخلص من الـ controllers بعد استخدامها
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية
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
                            "PATIENT SIGN UP",
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff44564A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 110),

                      // First Name Field
                      CustomTextField(
                        controller: _firstNameController,
                        labelText: "First Name",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),

                      // Last Name Field
                      CustomTextField(
                        controller: _lastNameController,
                        labelText: "Last Name",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),

                      // Email Field
                      CustomTextField(
                        controller: _emailController,
                        labelText: "Email",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),

                      // Password Field
                      CustomTextField(
                        controller: _passwordController,
                        labelText: "Password",
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),

                      // Gender Field (Dropdown with improved design)
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffE9EBEA),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _selectedGender,
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            labelStyle: TextStyle(color: Colors.black54),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            border: InputBorder.none,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Male',
                              child: Text('Male'),
                            ),
                            DropdownMenuItem(
                              value: 'Female',
                              child: Text('Female'),
                            ),
                            DropdownMenuItem(
                              value: 'Non',
                              child: Text('Non'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your gender';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Date of Birth Field (Date Picker)
                      TextFormField(
                        controller: _dobController,
                        decoration: InputDecoration(
                          labelText: 'Date of Birth',
                          filled: true,
                          fillColor: const Color(0xffE9EBEA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _dobController.text =
                                  '${pickedDate.toLocal()}'.split(' ')[0];
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select your date of birth';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),

                      // Signup Button
                      Center(
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState != null &&
                                      _formKey.currentState!.validate()) {
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    try {
                                      final email =
                                          _emailController.text.trim();
                                      final password =
                                          _passwordController.text.trim();

                                      UserCredential userCredential =
                                          await FirebaseAuth.instance
                                              .createUserWithEmailAndPassword(
                                        email: email,
                                        password: password,
                                      );

                                      // إضافة بيانات المستخدم إلى Firestore
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(userCredential.user?.uid)
                                          .set({
                                        'firstName': _firstNameController.text,
                                        'lastName': _lastNameController.text,
                                        'email': _emailController.text,
                                        'gender': _selectedGender,
                                        'dob': _dobController.text,
                                      });

                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomePageP(),
                                        ),
                                      );
                                    } on FirebaseAuthException catch (e) {
                                      String errorMessage =
                                          'An unknown error occurred. Please try again.';
                                      if (e.code == 'email-already-in-use') {
                                        errorMessage =
                                            'The email address is already in use.';
                                      }

                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Error'),
                                            content: Text(errorMessage),
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
                                    } finally {
                                      setState(() {
                                        _isLoading = false;
                                      });
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
                          child: _isLoading
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
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

// Custom Widget for TextField to avoid repetition and add validation
class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.controller, // التأكد من أنه الـ controller تم تمريره هنا
    this.isPassword = false,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller, // التأكد من أنه الـ controller تم تمريره هنا
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: const Color(0xffE9EBEA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator, // إضافة الـ validator هنا
    );
  }
}

// encrypted##########################################################################################

// class SignupPage extends StatefulWidget {
//   const SignupPage({Key? key}) : super(key: key); // Use 'Key?' from flutter/material.dart

//   @override
//   _SignupPageState createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _dobController = TextEditingController();
//   String? _selectedGender;
//   bool _isLoading = false;

//   // AES Encryption
//   final _key = encrypt.Key.fromLength(32);
//   final _iv = encrypt.IV.fromLength(16);
//   late final encrypt.Encrypter _encrypter;

//   @override
//   void initState() {
//     super.initState();
//     _encrypter = encrypt.Encrypter(encrypt.AES(_key));
//   }

//   String encryptData(String input) {
//     final encrypted = _encrypter.encrypt(input, iv: _iv);
//     return encrypted.base64;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('images/background2.png'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: SingleChildScrollView(
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: 20),
//                       Row(
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                             child: const Icon(
//                               Icons.arrow_back_ios,
//                               color: Color(0xff44564A),
//                               size: 30,
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           const Text(
//                             "SIGN UP",
//                             style: TextStyle(
//                               fontSize: 36,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xff44564A),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 110),

//                       CustomTextField(
//                         controller: _firstNameController,
//                         labelText: "First Name",
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your first name';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 40),

//                       CustomTextField(
//                         controller: _lastNameController,
//                         labelText: "Last Name",
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your last name';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 40),

//                       CustomTextField(
//                         controller: _emailController,
//                         labelText: "Email",
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your email';
//                           }
//                           if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
//                             return 'Please enter a valid email address';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 40),

//                       CustomTextField(
//                         controller: _passwordController,
//                         labelText: "Password",
//                         isPassword: true,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your password';
//                           }
//                           if (value.length < 6) {
//                             return 'Password must be at least 6 characters';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 40),

//                       DropdownButtonFormField<String>(
//                         value: _selectedGender,
//                         decoration: const InputDecoration(
//                           labelText: 'Gender',
//                           contentPadding: EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 15),
//                           border: InputBorder.none,
//                         ),
//                         items: const [
//                           DropdownMenuItem(
//                             value: 'Male',
//                             child: Text('Male'),
//                           ),
//                           DropdownMenuItem(
//                             value: 'Female',
//                             child: Text('Female'),
//                           ),
//                           DropdownMenuItem(
//                             value: 'Non',
//                             child: Text('Non'),
//                           ),
//                         ],
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedGender = value;
//                           });
//                         },
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please select your gender';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 40),

//                       TextFormField(
//                         controller: _dobController,
//                         decoration: InputDecoration(
//                           labelText: 'Date of Birth',
//                           filled: true,
//                           fillColor: const Color(0xffE9EBEA),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(30),
//                             borderSide: BorderSide.none,
//                           ),
//                         ),
//                         readOnly: true,
//                         onTap: () async {
//                           DateTime? pickedDate = await showDatePicker(
//                             context: context,
//                             initialDate: DateTime.now(),
//                             firstDate: DateTime(1900),
//                             lastDate: DateTime.now(),
//                           );
//                           if (pickedDate != null) {
//                             setState(() {
//                               _dobController.text =
//                                   '${pickedDate.toLocal()}'.split(' ')[0];
//                             });
//                           }
//                         },
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please select your date of birth';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 40),

//                       Center(
//                         child: ElevatedButton(
//                           onPressed: _isLoading
//                               ? null
//                               : () async {
//                                   if (_formKey.currentState != null &&
//                                       _formKey.currentState!.validate()) {
//                                     setState(() {
//                                       _isLoading = true;
//                                     });

//                                     try {
//                                       final email =
//                                           _emailController.text.trim();
//                                       final password =
//                                           _passwordController.text.trim();

//                                       UserCredential userCredential =
//                                           await FirebaseAuth.instance
//                                               .createUserWithEmailAndPassword(
//                                         email: email,
//                                         password: password,
//                                       );

//                                       await FirebaseFirestore.instance
//                                           .collection('users')
//                                           .doc(userCredential.user?.uid)
//                                           .set({
//                                         'firstName': encryptData(
//                                             _firstNameController.text),
//                                         'lastName': encryptData(
//                                             _lastNameController.text),
//                                         'email': encryptData(
//                                             _emailController.text),
//                                         'gender': encryptData(_selectedGender!),
//                                         'dob': encryptData(
//                                             _dobController.text),
//                                       });

//                                       Navigator.pushReplacement(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => HomePage(),
//                                         ),
//                                       );
//                                     } finally {
//                                       setState(() {
//                                         _isLoading = false;
//                                       });
//                                     }
//                                   }
//                                 },
//                           child: _isLoading
//                               ? const CircularProgressIndicator()
//                               : const Text("SIGN UP"),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Custom Widget for TextField
// class CustomTextField extends StatelessWidget {
//   final String labelText;
//   final bool isPassword;
//   final TextEditingController controller;
//   final String? Function(String?)? validator;

//   const CustomTextField({
//     Key? key,
//     required this.labelText,
//     required this.controller,
//     this.isPassword = false,
//     this.validator,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       obscureText: isPassword,
//       decoration: InputDecoration(
//         labelText: labelText,
//         filled: true,
//         fillColor: const Color(0xffE9EBEA),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30),
//           borderSide: BorderSide.none,
//         ),
//       ),
//       validator: validator,
//     );
//   }
// }

// encrypted##########################################################################################

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final String? email; // ← إضافة متغير email

  ForgotPasswordPage({Key? key, this.email}) : super(key: key) {
    if (email != null) {
      _emailController.text = email!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background5.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            const Text(
              'Forgot\nPassword',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xff44564A),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Email',
              style: TextStyle(fontSize: 18, color: Color(0xff44564A)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff44564A),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () async {
                  final email = _emailController.text.trim();

                  if (email.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter your email'),
                      ),
                    );
                    return;
                  }

                  try {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: email);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Password reset link sent to your email',
                        ),
                      ),
                    );
                  } on FirebaseAuthException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.message ?? 'An error occurred'),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Send Reset Link',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // الرجوع للصفحة السابقة
              },
              child: const Text(
                '← Back to LOGIN',
                style: TextStyle(color: Color(0xff44564A), fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
