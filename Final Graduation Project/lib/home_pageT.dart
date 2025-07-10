import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:account_gp/settings_pageT.dart'; // تأكدي من المسار الصحيح للصفحة

class HomePageT extends StatefulWidget {
  const HomePageT({super.key});

  @override
  HomePageTState createState() => HomePageTState();
}

class HomePageTState extends State<HomePageT> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background5.png'), // الخلفية من الـ assets
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50), // هامش علوي
            // عنوان الصفحة مع زر الرجوع والإعدادات
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Text(
                        'Home',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff44564A),
                        ),
                      ),
                    ],
                  ),
                  // زر الإعدادات
                  IconButton(
                    icon: const Icon(Icons.settings),
                    color: const Color(0xff44564A),
                    onPressed: () {
                      // قم بتحديد صفحة الإعدادات الخاصة بالـ Therapist هنا
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SettingsPageT()), // تأكد من استبدال SettingsPageT بصفحتك الخاصة
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // عرض المواعيد القادمة
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Upcoming Appointments',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff44564A),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // قائمة المواعيد القادمة
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('appointments') // تأكدي من أن هذه هي المجموعة اللي فيها المواعيد
                  .where('therapistId', isEqualTo: 'therapist_id') // استبدلي بـ ID الخاص بالـ therapist
                  .orderBy('appointmentTime') // ترتيب المواعيد
                  .limit(5) // عرض أول 5 مواعيد
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No upcoming appointments"));
                }

                var appointments = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    var appointment = appointments[index];
                    var appointmentTime =
                        (appointment['appointmentTime'] as Timestamp).toDate();
                    return ListTile(
                      title: Text(appointment['patientName']),
                      subtitle: Text('Time: ${appointmentTime.toString()}'),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // عملية تعديل الموعد هنا
                        },
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 30),
            // عرض التقييمات
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff44564A),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // قائمة التقييمات
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('reviews')
                  .where('therapistId', isEqualTo: 'therapist_id') // استبدلي بـ ID الخاص بالـ therapist
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No reviews yet"));
                }

                var reviews = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    var review = reviews[index];
                    return ListTile(
                      title: Text('Rating: ${review['rating']}'),
                      subtitle: Text(review['comment']),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}






// class PainPage extends StatelessWidget {
//   const PainPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // قائمة الأوصاف والنصائح
//     final List<String> painDescriptions = [
//       'Stretching exercise to relieve knee pain.',
//       'Strengthening muscles around the knee.',
//       'Balance exercise to improve stability.',
//       'Flexibility routine for better mobility.',
//       'Pain relief exercise for joints.',
//       'Low-impact exercise for knees.',
//       'Relaxation and pain management movements.',
//       'Post-injury recovery stretches.'
//     ];

//     final List<String> painTips = [
//       'Hold each stretch for 30 seconds.',
//       'Focus on slow, controlled movements.',
//       'Use a stable surface for balance.',
//       'Breathe deeply during the exercise.',
//       'Avoid overexertion; stop if pain increases.',
//       'Perform the exercise on a soft mat.',
//       'Relax your muscles between sets.',
//       'Consult a therapist if you feel discomfort.'
//     ];

//     return Scaffold(
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Image.asset(
//               'images/background6.png',
//               fit: BoxFit.cover,
//             ),
//           ),
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.arrow_back_ios),
//                         color: const Color(0xff44564A),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                       ),
//                       const Text(
//                         'Pain Exercises',
//                         style: TextStyle(
//                           fontSize: 36,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xff44564A),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 50),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: painDescriptions.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: Card(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             elevation: 5,
//                             child: ListTile(
//                               title: Text(
//                                 'Exercise ${index + 1}',
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xff44564A),
//                                 ),
//                               ),
//                               subtitle: Text(
//                                 painDescriptions[index],
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: Color(0xff44564A),
//                                 ),
//                               ),
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => ExercisesPage(
//                                       exerciseIndex: index,
//                                       description: painDescriptions[index],
//                                       tips: painTips[index],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // صفحة FitnessPage
// class FitnessPage extends StatelessWidget {
//   const FitnessPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // قائمة الأوصاف والنصائح
//     final List<String> fitnessDescriptions = [
//       'Full-body workout to improve strength.',
//       'Cardio exercise to boost heart health.',
//       'Core strengthening routine.',
//       'Flexibility and stretching exercises.',
//       'Upper body workout for strength.',
//       'Lower body exercises for endurance.',
//       'High-intensity interval training (HIIT).',
//       'Cool-down and relaxation stretches.'
//     ];

//     final List<String> fitnessTips = [
//       'Start with a light warm-up.',
//       'Maintain steady breathing during cardio.',
//       'Engage your core muscles throughout.',
//       'Stretch slowly to avoid injury.',
//       'Use proper form to prevent strain.',
//       'Take breaks if you feel fatigued.',
//       'Alternate between high and low intensity.',
//       'End with a gentle cool-down.'
//     ];

//     return Scaffold(
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Image.asset(
//               'images/background6.png',
//               fit: BoxFit.cover,
//             ),
//           ),
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.arrow_back_ios),
//                         color: const Color(0xff44564A),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                       ),
//                       const Text(
//                         'Fitness Exercises',
//                         style: TextStyle(
//                           fontSize: 36,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xff44564A),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 50),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: fitnessDescriptions.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: Card(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             elevation: 5,
//                             child: ListTile(
//                               title: Text(
//                                 'Exercise ${index + 1}',
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xff44564A),
//                                 ),
//                               ),
//                               subtitle: Text(
//                                 fitnessDescriptions[index],
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: Color(0xff44564A),
//                                 ),
//                               ),
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => ExercisesPage(
//                                       exerciseIndex: index,
//                                       description: fitnessDescriptions[index],
//                                       tips: fitnessTips[index],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // صفحة تفاصيل التمرين (تُستخدم لكل من Pain و Fitness)
// class ExercisesPage extends StatelessWidget {
//   final int exerciseIndex;
//   final String description;
//   final String tips;

//   const ExercisesPage({
//     super.key,
//     required this.exerciseIndex,
//     required this.description,
//     required this.tips,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // الخلفية من صفحة PainPage
//           Positioned.fill(
//             child: Image.asset(
//               'images/background6.png', // الخلفية الخاصة بالتمرين
//               fit: BoxFit.cover,
//             ),
//           ),
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // العنوان مع التأثيرات
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.arrow_back_ios),
//                         color: const Color(0xff44564A),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                       ),
//                       const SizedBox(width: 10),
//                       Text(
//                         'Exercise Details',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xff44564A),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 80),
//                   // الفيديو داخل إطار دائري مع ظل
//                   Container(
//                     height: 250,
//                     width: 250,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15),
//                       color: Colors.black,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           spreadRadius: 2,
//                           blurRadius: 8,
//                           offset: Offset(0, 4), // تأثير الظل
//                         ),
//                       ],
//                     ),
//                     child: Center(
//                       child: Text(
//                         'Video for Exercise ${exerciseIndex + 1}',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   // وصف التمرين داخل Card مع حواف دائرية
//                   Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     elevation: 5,
//                     color: Colors.white.withOpacity(0.8),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Text(
//                         description,
//                         style: TextStyle(
//                           fontSize: 18,
//                           color: Colors.black87,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   // النصائح مع تأثير خط مميز
//                   Text(
//                     'Tips:',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xff44564A),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Text(
//                       tips,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black54,
//                         fontStyle: FontStyle.italic,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   // زر العودة إلى الصفحة الرئيسية
//                   SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
