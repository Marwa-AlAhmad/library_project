import 'package:flutter/material.dart';

class Mytextformfield extends StatelessWidget {
  final String hintText;
  final TextEditingController mycontroller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextDirection textDirection;
  final TextAlign textAlign;
  final TextDirection? hintTextDirection;
  final bool showShadow;

  const Mytextformfield({
    super.key,
    required this.hintText,
    required this.mycontroller,
    this.validator,
    this.onChanged,
    this.textDirection = TextDirection.ltr,
    this.textAlign = TextAlign.left,
    this.hintTextDirection, this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
       boxShadow: showShadow 
      ? [
          BoxShadow(
            color: Color(
                0xFF462619,
              ).withOpacity(0.5), // كود الظل القديم الخاص بكِ هنا كما هو
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ]
      : [],
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
          fillColor: Color.fromARGB(255, 238, 217, 198),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: Color.fromARGB(255, 96, 80, 76),
             width: 2),
            
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              color: Color(
                0xFF462619,
              ), // اجعليه نفس اللون البني الدافئ لتختفي الحدود الرمادية تماماً أثناء الكتابة
              width: 2.0, // زيادة السماكة قليلاً لتعطي إيحاءً بالتفاعل والتركيز
            ),
          ),
        ),
      ),
    );
    ;
  }
}
