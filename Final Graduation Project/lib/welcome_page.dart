//import 'package:account_gp/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'patient_page.dart'; 
//import 'therapist_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEAD2C6),
      body: Container(
        
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
      
              SizedBox(height: 150), // مسافة أعلى
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: Text(
                  'Welcome to',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 40, // حجم النص
                    fontWeight: FontWeight.normal,
                    color: Color(0xff44564A),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(right: 80.0),
                child: Center(
                  child: Text(
                    'FlexiCare',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 40, // حجم النص
                      fontWeight: FontWeight.bold,
                      color: Color(0xff44564A), // لون النص
                    ),
                  ),
                ),
              ),
              SizedBox(height: 230), // مسافة بين النصوص والزر
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // التنقل إلى صفحة patientOrtherapist
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PatientPage(), // الصفحة التالية
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff44564A), // لون الزر
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40), // حواف مستديرة
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  ),
                  child: Text(
                    'Get started',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontFamily: 'Alexandria',
                    ),
                  ),
                ),
              ),
              Spacer(), // مسافة أسفل
            ],
          ),
        ),
      ),
    );
  }
}


