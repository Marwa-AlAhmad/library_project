import 'package:flutter/material.dart';

class Mytextformfield extends StatelessWidget {
  final String hintText;
  final TextEditingController mycontroller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextDirection textDirection;
  final TextAlign textAlign;
  final TextDirection? hintTextDirection;

  const Mytextformfield({
    super.key,
    required this.hintText,
    required this.mycontroller,
    this.validator,
    this.onChanged,
    this.textDirection = TextDirection.ltr,
    this.textAlign = TextAlign.left,
    this.hintTextDirection,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(
              0xFF4E342E,
            ).withOpacity(0.5), // لون الظل ودرجة شفافيته (يفضل أن يكون خفيفاً)
            spreadRadius: 2, // مدى انتشار وتوسع الظل حول الكونتينر
            blurRadius:
                10, // درجة نعومة وتغبيش الظل (كلما زاد، أصبح الظل أنعم وأكثر واقعية)
            offset: const Offset(
              0,
              4,
            ), // مكان تموضع الظل (X: لليمين/اليسار , Y: للأعلى/الأسفل) هنا مائل للأسفل قريلاً
          ),
        ],
      ),
      child: TextFormField(
        
        onChanged: onChanged,
        controller: mycontroller,
        validator: validator,
        textDirection: textDirection,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: hintText,
          hintTextDirection: hintTextDirection,
          hintStyle: TextStyle(fontSize: 18, color: Colors.grey[600]),
          contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: Color(0xFF4E342E)),
          ),
        ),
      ),
    );
    ;
  }
}
