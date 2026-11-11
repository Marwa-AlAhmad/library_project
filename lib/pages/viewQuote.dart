import 'package:flutter/material.dart';

class Viewquote extends StatefulWidget {
  final String quoteId;
  final String quoteText;
  const Viewquote({super.key, required this.quoteId, required this.quoteText});

  @override
  State<Viewquote> createState() => _ViewquoteState();
}

class _ViewquoteState extends State<Viewquote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/imageviewquote.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Text(
              widget.quoteText,
               textDirection: TextDirection.rtl,
              textAlign: TextAlign.center, 
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight(700),
                color: const Color(0xFF462619),
                shadows: [
                  Shadow(
                    color: const Color.fromARGB(255, 33, 18, 12).withOpacity(0.5), // ظل بني ناعم وخفيف
                    offset: const Offset(
                      2,
                      2,
                    ), // دفع الظل مائلاً قليلاً لليمين والأسفل
                    blurRadius: 4, // درجة نعومة وتغبيش ظل الحروف
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
