import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'customText.dart';

class ComplaintCard extends StatelessWidget {
  final String complaintNumber;
  final String status;
  final Color statusColor;
  final Color statusTextColor;
  final String name;
  final String date;
  final String description;

  ComplaintCard({
    required this.complaintNumber,
    required this.status,
    required this.statusColor,
    required this.statusTextColor,
    required this.name,
    required this.date,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    // Get the screen size to make adjustments
    double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 5, // This controls the shadow's intensity
      child: Padding(
        padding: EdgeInsets.only(
          top: 3,
          left: screenWidth * 0.04, // Adjust padding based on screen width
          right: screenWidth * 0.04,
          bottom: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const CustomText(
                      text: 'Complaint Number',
                      fontFamily: "Plus",
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF676A6C),
                      fontSize: 12,
                    ),
                    CustomText(
                      text:  complaintNumber,
                      fontFamily: "Plus",
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                    height: 43,
                    width: screenWidth * 0.3, // Adjust the width based on screen size
                    alignment: Alignment.center, // Center the text inside
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child:  CustomText(
                      text:  status,
                      color: statusTextColor,
                      fontFamily: "Plus",
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SvgPicture.asset(
                  "assets/Svgs/Profile.svg",
                  width: screenWidth * 0.05, // Adjust size based on screen width
                ),
                const SizedBox(width: 4),

                CustomText(
                  text:   name,
                  color: Colors.black,
                  fontFamily: "Plus",
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                const Spacer(),
                SvgPicture.asset(
                  "assets/Svgs/calendar.svg",
                  width: screenWidth * 0.05, // Adjust size based on screen width
                ),
                const SizedBox(width: 4),

                CustomText(
                  text:   date,
                  color: Colors.black,
                  fontFamily: "Plus",
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                ),
              ],
            ),
            const SizedBox(height: 10),
            const CustomText(
              text:    'Complaint Description',
              color: Colors.black,
              fontFamily: "Plus",
              fontWeight: FontWeight.w700,

            ),

            const SizedBox(height: 15),
            CustomText(
              text:  description,
              color: Color(0xFF252525),
              fontFamily: "Plus",
              fontSize: 12,
              maxLines: 3,


            ),
          ],
        ),
      ),
    );
  }
}
