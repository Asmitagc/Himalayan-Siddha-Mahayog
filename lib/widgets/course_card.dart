import 'package:flutter/material.dart';

import '../models/course_model.dart';

class CourseCard extends StatelessWidget {

  final CourseModel course;

  final VoidCallback onExplore;

  const CourseCard({
    super.key,
    required this.course,
    required this.onExplore,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      margin: const EdgeInsets.symmetric(
        horizontal: 8,
      ),

      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(28),

        gradient: const LinearGradient(

          colors: [
            Color(0xFFFF7900),
            Color(0xFFD35A6B),
            Color(0xFF8E3FA0),
          ],

          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),

      child: Stack(
        children: [


          Padding(
            padding: const EdgeInsets.only(
              left: 42,
              top: 45,
              right: 30,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  course.title,

                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  course.subtitle,

                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),

                const SizedBox(height: 35),


                SizedBox(
                  width: 300,
                  height: 68,

                  child: ElevatedButton(

                    onPressed: onExplore,

                    style: ElevatedButton.styleFrom(

                      backgroundColor:
                          const Color(0xFFFF8A00),

                      foregroundColor:
                          Colors.white,

                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(22),
                      ),
                    ),

                    child: const Text(
                      'Explore',

                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            right: -20,
            bottom: -30,

            child: Icon(
              Icons.local_florist,

              size: 240,

              color: Colors.white.withOpacity(0.15),
            ),
          ),
        ],
      ),
    );
  }
}